#include <tapasco.hpp>
#include "matrix.h"
#include "consts.h"
#include <vector>
#include <random>
#include <format>
#include <cmath>
#include <chrono>

#define HBM_ARG(N) (HBM_STRIDE * N), (N >= HW_COMPUTE_UNITS ? 0 : data.hbm_buffers[N].size())

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

    uint64_t errors = 0;
    for(size_t i = 0; i < y_vec_m.size(); i++) {
        if(!are_equalish(y_vec_m[i], y_vec_data[i])) {
            errors++;
            if (errors < 16)
            std::cout << std::format("Y: {}, Mat.mul: {}\tData.mul: {}", i, y_vec_m[i], y_vec_data[i]) << std::endl;
        }
    }
    if(errors) {
        std::cout << "DISCREPANCY BETWEEN Mat.mul and Data.mul FOUND! Errors: " << errors << std::endl;
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
    std::cout << "Shuffle" << std::endl;
//    m.shuffle_random();
    std::cout << "Constructing ComputeUnitData..." << std::endl;
    ComputeUnitData data = m.get_compute_unit_data();
    std::cout << "ComputeUnitData done" << std::endl;

    if(iterations == 0) {
        //std::vector<float> x_vec = random_x_vec(m.width);
        std::vector<float> x_vec(m.width, 1.0);
        std::cout << "check mul" << std::endl;
        check_mul(m, data, x_vec);
        std::cout << "convert back" << std::endl;
        Matrix m2 = data.convert();
        std::cout << "compare" << std::endl;
        m.compare(m2);
        std::cout << "dump" << std::endl;
        dump_hex(m, data, x_vec);
        return 0;
    }

    // initialize TaPaSCo
    tapasco::Tapasco tapasco = tapasco::Tapasco(tapasco::tlkm_access::TlkmAccessExclusive, TAPASCO_DEVICE_IDX);

    // upload matrix to device distributed across hbm banks
    std::cout << "upload hbm data" << std::endl;
    for (uint64_t i = 0; i < HW_COMPUTE_UNITS; i++) {
        uint64_t hbm_addr = HBM_BASE + HBM_STRIDE * i;
        uint8_t* hbm_data_ptr = reinterpret_cast<uint8_t*>(data.hbm_buffers[i].data());
        size_t hbm_data_size = data.hbm_buffers[i].size() * sizeof(MatrixDataBlock);
        tapasco.copy_to(hbm_data_ptr, hbm_addr, hbm_data_size);
        std::vector<uint8_t> hbm_data2(hbm_data_size, 0);
        tapasco.copy_from(hbm_addr, (uint8_t*) hbm_data2.data(), hbm_data_size);
        for (uint64_t j = 0; j < data.hbm_buffers[i].size(); j++) {
            assert(hbm_data2[j] == hbm_data_ptr[j]);
        }
    }

    std::cout << "start runs" << std::endl;
    for (uint64_t iter = 0; iter < iterations; iter++) {
        // generate & upload test vector
//        std::vector<float> x_vec = random_x_vec(m.width);
        std::vector<float> x_vec(m.width, 1.0);
        std::vector<float> extended_x_vec(((x_vec.size() + 4095) / 4096) * 4096, 0.0);
        for (uint64_t i = 0; i < m.width; i++) {
            extended_x_vec[i] = x_vec[i];
        }
        std::vector<float> y_vec(m.height, 10.0);

//        auto tapasco_start = std::chrono::steady_clock::now();
//        auto device_x_vec = tapasco::makeInOnly(tapasco::makeWrappedPointer(extended_x_vec.data(), extended_x_vec.size() * sizeof(float)));
//        auto device_y_vec = tapasco::makeOutOnly(tapasco::makeWrappedPointer(y_vec.data(), y_vec.size() * sizeof(float)));
//        auto device_y_vec = tapasco::makeWrappedPointer(y_vec.data(), y_vec.size() * sizeof(float));
        std::cout << "copy x_vec" << std::endl;
        tapasco.copy_to((uint8_t*)extended_x_vec.data(), 0, extended_x_vec.size() * sizeof(float));
        tapasco.copy_to((uint8_t*)y_vec.data(), 0x10000000, y_vec.size() * sizeof(float));
//        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        std::cout << "launch: " << iter << std::endl;
        auto tapasco_start = std::chrono::steady_clock::now();

        // launch SUSpMV
        uint64_t cycles = -1;
        tapasco::RetVal<uint64_t> ret_val(&cycles);
        auto job = tapasco.launch(
            SUSPMV_PE_ID,
            ret_val,
//            device_x_vec, device_y_vec,
            0, 0x10000000,
            data.x_tiles, data.y_repeats,
            HBM_ARG( 0), HBM_ARG( 1), HBM_ARG( 2), HBM_ARG( 3), HBM_ARG( 4), HBM_ARG( 5), HBM_ARG( 6), HBM_ARG( 7),
            HBM_ARG( 8), HBM_ARG( 9), HBM_ARG(10), HBM_ARG(11), HBM_ARG(12), HBM_ARG(13), HBM_ARG(14), HBM_ARG(15),
            HBM_ARG(16), HBM_ARG(17), HBM_ARG(18), HBM_ARG(19), HBM_ARG(20), HBM_ARG(21), HBM_ARG(22), HBM_ARG(23),
            HBM_ARG(24), HBM_ARG(25), HBM_ARG(26), HBM_ARG(27), HBM_ARG(28), HBM_ARG(29), HBM_ARG(30), HBM_ARG(31)
        );
        job();
//      std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        auto tapasco_end = std::chrono::steady_clock::now();
        tapasco.copy_from(0x10000000, (uint8_t*)y_vec.data(), y_vec.size() * sizeof(float));


//        auto tapasco_end = std::chrono::steady_clock::now();
        auto tapasco_duration = std::chrono::duration_cast<std::chrono::microseconds>(tapasco_end - tapasco_start);
        std::cout << "Cycles: " << cycles << std::endl;

        // reference CPU implementation
        auto cpu_start = std::chrono::steady_clock::now();
        std::vector<float> reference = data.mul(x_vec);
        auto cpu_end = std::chrono::steady_clock::now();
        auto cpu_duration = std::chrono::duration_cast<std::chrono::microseconds>(cpu_end - cpu_start);

        std::cout << "SUSpMV: " << tapasco_duration << ", CPU: " << cpu_duration << std::endl;

        // check result integrity
        uint64_t errors = 0;
        for (uint64_t i = 0; i < m.height; i++) {
            if (!are_equalish(y_vec[i], reference[i])) {
                if (errors < 16)
                std::cout << i << ": " << y_vec[i] << " " <<  reference[i] << std::endl;
                errors += 1;
            }
        }
        std::cout << "Errors: " << errors << std::endl;
    }

    return 0;
}
