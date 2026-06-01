#include <tapasco.hpp>
#include "matrix.h"
#include "consts.h"
#include <vector>
#include <random>
#include <format>
#include <cmath>

int dump_hex(Matrix& m, ComputeUnitData& data, std::vector<float>& x_vec);

#define SUSPMV_PE_ID 100

std::vector<float> random_x_vec(size_t len) {
    std::vector<float> x_vec(len, 0.0);

    std::random_device rd;  // Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); // Standard mersenne_twister_engine seeded with rd()
    std::uniform_real_distribution<float> dis(-2.0, 2.0);

    for (uint64_t i = 0; i < x_vec.size(); i++) {
        x_vec[i] = dis(gen);
    }

    return x_vec;
}

bool are_equalish(float a, float b) {
    float max_abs = std::max(std::max(std::abs(a), std::abs(b)), 0.000000000001f);

    float delta = (a - b) / max_abs;
    return delta >= -0.00001 && delta <= 0.00001;
}

void check_mul(Matrix& m, ComputeUnitData& data, std::vector<float>& x_vec) {
    std::vector<float> y_vec_m = m.mul(x_vec);
    std::vector<float> y_vec_data = data.mul(x_vec);

    assert(y_vec_m.size() == y_vec_data.size());

    bool any_error = false;
    for(size_t i = 0; i < y_vec_m.size(); i++) {
        if(!are_equalish(y_vec_m[i], y_vec_data[i])) {
            any_error = true;
        }
        std::cout << std::format("Y: {}, Mat.mul: {}\tData.mul: {}", i, y_vec_m[i], y_vec_data[i]) << std::endl;
    }
    if(any_error) {
        std::cout << "DISCREPANCY BETWEEN Mat.mul and Data.mul FOUND!" << std::endl;
        //exit(1);
    }
}
/*
Float6 [256]*185.1852(+1) [141]*-21.55172 [254]*-31.44654 [257]*261.8486 [260]*-128.2051 [326]*-80.64516(+1)
Float5 [239]*-7.917656 [258]*20.85427 [277]*-12.93661(+1) [0]*0 [0]*0 X Last
Float5 [0]*0(+64) [70]*-15.92357(+5) [0]*0 [0]*0 [0]*0
Float5 [70]*-15.92357(+5) [38]*-4.623209 [40]*-16.47446 [49]*-3.195909(+7) [25]*-5000(+32)
Float5 [4]*-10000(+115) [1]*-7.267442(+1) [0]*0 [0]*0 [0]*0 X Last Y Last
Placing Y 259..538 (entries 1012..2027) in compute unit 1


4054  4059
[1062,69]*-4.623209  [1094,69]*-15.92357
[1064,69]*-16.47446  [63,70]*-40.98361
[1073,69]*-3.195909  [70,70]*96.53917
[63,70]*-40.98361  [71,70]*-55.55556
[70,70]*96.53917  [70,71]*-55.55556
[71,70]*-55.55556  [71,71]*84.92064
[70,71]*-55.55556  [72,71]*-5.555555
[71,71]*84.92064  [120,71]*-23.80952
[72,71]*-5.555555  [71,72]*-5.555555
[120,71]*-23.80952  [72,72]*5.555555
[71,72]*-5.555555  [65,73]*-32.65326
[72,72]*5.555555  [67,73]*-47.5921
[65,73]*-32.65326  [73,73]*384.9024
[67,73]*-47.5921  [74,73]*-40.32258
[73,73]*384.9024  [75,73]*-25.44529
[74,73]*-40.32258  [77,73]*-34.3871
[75,73]*-25.44529  [79,73]*-15.82279
[77,73]*-34.3871  [118,73]*-188.6792
[79,73]*-15.82279  [73,74]*-40.32258
[118,73]*-188.6792  [74,74]*693.1041
[73,74]*-40.32258  [203,74]*-645.1613
[74,74]*693.1041  [809,74]*-4.608295
[203,74]*-645.1613  [917,74]*-3.012048
[809,74]*-4.608295  [1062,74]*-4.623209
[917,74]*-3.012048  [1064,74]*-16.47446
[73,75]*-25.44529  [1073,74]*-3.195909

*/


int main(int argc, char **argv) {
    if (argc != 3) {
        std::cout << "usage: ./suspmv <path to .mtx> <iterations>" << std::endl;
        return 0;
    }
    std::string path(argv[1]);
    uint64_t iterations = std::stoi(argv[2]);

    // Temporary, should be computed automatically in the future
    uint64_t y_repeats = 2;

    // load matrix from file
    std::cout << "Loading " << path << std::endl;
    Matrix m = Matrix::load(path);
    std::cout << "Constructing ComputeUnitData..." << std::endl;
    ComputeUnitData data = m.get_compute_unit_data(COMPUTE_UNITS, y_repeats);
    std::cout << "ComputeUnitData done" << std::endl;

    // std::vector<float> x_vec = random_x_vec(m.width);
    std::vector<float> x_vec(m.width, 1.0);

    check_mul(m, data, x_vec);
    
    if(iterations == 0) {
		Matrix m2 = data.convert(m.width, m.height);
		m.compare(m2);

        dump_hex(m, data, x_vec);
        return 0;
    }

    // initialize TaPaSCo
    tapasco::Tapasco tapasco;

    // upload matrix to device distributed across hbm banks
    for (uint64_t i = 0; i < COMPUTE_UNITS; i++) {
        uint64_t hbm_addr = HBM_BASE + HBM_STRIDE * i;
        uint8_t* hbm_data_ptr = reinterpret_cast<uint8_t*>(data.hbm_buffers[i].data());
        size_t hbm_data_size = data.hbm_buffers[i].size() * sizeof(MatrixDataBlock);
        tapasco.copy_to(hbm_data_ptr, hbm_addr, hbm_data_size);
    }

    for (uint64_t iter = 0; iter < iterations; iter++) {
        // generate & upload test vector
        std::vector<float> result(m.height);

        auto v_buffer = tapasco::makeInOnly(tapasco::makeWrappedPointer(x_vec.data(), x_vec.size() * sizeof(float)));
        auto r_buffer = tapasco::makeOutOnly(tapasco::makeWrappedPointer(result.data(), result.size() * sizeof(float)));

        // launch SUSpMV
        uint64_t cycles = -1;
        tapasco::RetVal<uint64_t> ret_val(&cycles);
        auto job = tapasco.launch(
            SUSPMV_PE_ID,
            ret_val,
            m.width, m.height,
            v_buffer, r_buffer
        );
        job();
        std::cout << "Cycles: " << cycles << std::endl;

        // check result integrity
        std::vector<float> reference = m.mul(x_vec);
        uint64_t errors = 0;
        for (uint64_t i = 0; i < m.height; i++) {
            if (std::abs(result[i] - reference[i]) > 0.1) {
                errors += 1;
            }
        }
        std::cout << "Errors: " << errors << std::endl;
    }

    return 0;
}
