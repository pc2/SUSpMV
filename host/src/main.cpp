#include <tapasco.hpp>
#include "matrix.h"
#include <random>
#include <format>
#include <iostream>
#include <iomanip>

#define SUSPMV_PE_ID 100

void store(std::string path, std::vector<uint8_t> &data) {
    std::ofstream out(path);

    for (size_t i = 0; i < data.size(); ++i) {
        out << std::format("{:02x}", data[i]);

        if (i % 32 == 31 || i == data.size()-1) {
            out << '\n';
        }
    }

    out.close();
}

int main(int argc, char **argv) {
    if (argc != 3) {
        std::cout << "usage: ./suspmv <path to .mtx> <iterations>" << std::endl;
        return 0;
    }
    std::string path(argv[1]);
    uint64_t iterations = std::stoi(argv[2]);

    // initialize TaPaSCo
    tapasco::Tapasco tapasco;

    // accelerator config
    uint64_t compute_units = 1;
    uint64_t tile_height = 1024 * 32;
    uint64_t min_blocks_per_tile = 16;

    // load matrix from file
    Matrix m = Matrix::load(path, tile_height);

    // memory layout
    uint64_t hbm_base = 0x800000000;
    uint64_t hbm_stride = 0x1000000;

    // upload matrix to device distributed across hbm banks
    for (uint64_t i = 0; i < compute_units; i++) {
        std::vector<uint8_t> data = m.get_compute_unit_data(i, compute_units, min_blocks_per_tile);
        uint64_t hbm_addr = hbm_base + hbm_stride * i;
        tapasco.copy_to(data.data(), hbm_addr, data.size());

        if (iterations == 0) {
            // cue to store the compute unit data in files
            store(std::format("data{}.hex", i), data);
        }
    }

    for (uint64_t iter = 0; iter < iterations; iter++) {
        // generate & upload test vector
        std::vector<float> v(m.width, 0.0);
        std::vector<float> result(m.height);
        for (uint64_t i = 0; i < v.size(); i++) {
            v[i] = random();
        }

        auto v_buffer = tapasco::makeInOnly(tapasco::makeWrappedPointer(v.data(), v.size() * sizeof(float)));
        auto r_buffer = tapasco::makeOutOnly(tapasco::makeWrappedPointer(result.data(), result.size() * sizeof(float)));

        // launch spvm
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
        std::vector<float> reference = m.mul(v);
        uint64_t errors = 0;
        for (uint64_t i = 0; i < m.height; i++) {
            if (abs(result[i] - reference[i]) > 0.1) {
                errors += 1;
            }
        }
        std::cout << "Errors: " << errors << std::endl;
    }

    return 0;
}
