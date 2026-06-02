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
[527,528]*-196.0784  [1046,527]*-11.38952
[528,528]*196.0784  [527,528]*-196.0784
[529,529]*261.7177  [528,528]*196.0784
[577,529]*-9.708738  [529,529]*261.7177
[582,529]*-9.259259  [577,529]*-9.708738
[779,529]*-5.390836  [582,529]*-9.259259
[796,529]*-4.800768  [779,529]*-5.390836
[802,529]*-232.5581  [796,529]*-4.800768
[500,530]*-42.55319  [802,529]*-232.5581
[525,530]*-32.67974  [500,530]*-42.55319
[530,530]*204.1382  [525,530]*-32.67974
[531,530]*-53.71729  [530,530]*204.1382
[533,530]*-75.18797  [531,530]*-53.71729
[530,531]*-53.71729  [533,530]*-75.18797
[531,531]*527.8732  [530,531]*-53.71729
[553,531]*-35.97123  [531,531]*527.8732
[646,531]*-113.6364  [553,531]*-35.97123
[651,531]*-91.3242  [646,531]*-113.6364
[662,531]*-45.87156  [651,531]*-91.3242
[667,531]*-63.29114  [662,531]*-45.87156
[671,531]*-12.97017  [667,531]*-63.29114
[672,531]*-32.78688  [671,531]*-12.97017
[676,531]*-28.24859  [672,531]*-32.78688
[907,531]*-13.75516  [676,531]*-28.24859
[911,531]*-18.48429  [907,531]*-13.75516
[917,531]*-6.426735  [911,531]*-18.48429
[1046,531]*-11.38952  [917,531]*-6.426735

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
