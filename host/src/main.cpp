#include <tapasco.hpp>
#include "matrix.h"
#include "consts.h"
#include <vector>
#include <random>
#include <format>
#include <cmath>

#define HBM_ARG(N) (HBM_BASE + HBM_STRIDE * N), (N >= COMPUTE_UNITS ? 0 : data.hbm_buffers[N].size())

int dump_hex(Matrix& m, ComputeUnitData& data, std::vector<float>& x_vec);

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
	        std::cout << std::format("Y: {}, Mat.mul: {}\tData.mul: {}", i, y_vec_m[i], y_vec_data[i]) << std::endl;
        }
    }
    if(any_error) {
        std::cout << "DISCREPANCY BETWEEN Mat.mul and Data.mul FOUND!" << std::endl;
        //exit(1);
    }
}

int main(int argc, char **argv) {
    if (argc != 3) {
        std::cout << "usage: ./suspmv <path to .mtx> <iterations>\nSet <iterations> to 0 for simulation hex dump" << std::endl;
        return 0;
    }
    std::string path(argv[1]);
    uint64_t iterations = std::stoi(argv[2]);

    // load matrix from file
    std::cout << "Loading " << path << std::endl;
    Matrix m = Matrix::load(path);
    std::cout << "Constructing ComputeUnitData..." << std::endl;
    ComputeUnitData data = m.get_compute_unit_data();
    std::cout << "ComputeUnitData done" << std::endl;

    std::vector<float> x_vec = random_x_vec(m.width);
    //std::vector<float> x_vec(m.width, 1.0);

    check_mul(m, data, x_vec);
    
    if(iterations == 0) {
		Matrix m2 = data.convert();
		m.compare(m2);

        dump_hex(m, data, x_vec);
        return 0;
    }

    // initialize TaPaSCo
    tapasco::Tapasco tapasco = tapasco::Tapasco(tapasco::tlkm_access::TlkmAccessExclusive, TAPASCO_DEVICE_IDX);

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
            v_buffer, r_buffer,
            data.x_tiles, data.y_repeats,
            HBM_ARG( 0), HBM_ARG( 1), HBM_ARG( 2), HBM_ARG( 3), HBM_ARG( 4), HBM_ARG( 5), HBM_ARG( 6), HBM_ARG( 7),
            HBM_ARG( 8), HBM_ARG( 9), HBM_ARG(10), HBM_ARG(11), HBM_ARG(12), HBM_ARG(13), HBM_ARG(14), HBM_ARG(15),
            HBM_ARG(16), HBM_ARG(17), HBM_ARG(18), HBM_ARG(19), HBM_ARG(20), HBM_ARG(21), HBM_ARG(22), HBM_ARG(23),
            HBM_ARG(24), HBM_ARG(25), HBM_ARG(26), HBM_ARG(27), HBM_ARG(28), HBM_ARG(29), HBM_ARG(30), HBM_ARG(31)
        );
        job();
        std::cout << "Cycles: " << cycles << std::endl;

        // check result integrity
        std::vector<float> reference = m.mul(x_vec);
        uint64_t errors = 0;
        for (uint64_t i = 0; i < m.height; i++) {
            if (!are_equalish(result[i], reference[i])) {
                std::cout << result[i] << " " <<  reference[i] << std::endl;
                errors += 1;
            }
        }
        std::cout << "Errors: " << errors << std::endl;
    }

    return 0;
}
