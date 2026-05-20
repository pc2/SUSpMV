#include <tapasco.hpp>
#include "matrix.h"
#include <random>
#include <format>
#include <iostream>
#include <iomanip>

#define SUSPMV_PE_ID 100

void store(std::string path, const uint8_t* data, size_t data_len, size_t row_bits) {
    std::cout << "Writing Matrix Data to " << path << std::endl;

    std::ofstream out(path);

    size_t row_bytes = row_bits / 8;
    for (size_t i = 0; i < data_len; ++i) {
        out << std::format("{:02x}", data[i]);

        if (i % row_bytes == row_bytes-1 || i == data_len-1) {
            out << '\n';
        }
    }

    out.close();
}

void store_matrix_size(std::string path, Matrix& m, uint64_t compute_units) {
    std::cout << "Writing Matrix Data to " << path << std::endl;

    std::ofstream out(path);

    out << "`define X_VEC_LEN " << m.width << std::endl;
    out << "`define Y_VEC_LEN " << m.height << std::endl;
    out << "`define NUM_TILES " << m.tiles.size() << std::endl;
    out << "`define COMPUTE_UNITS " << compute_units << std::endl;
    out << "`define Y_REPEATS " << m.tiles.size() / compute_units << std::endl;

    for(size_t hbm = 0; hbm < m.tiles.size(); hbm++) {
        out << std::format("`define HBM{}_LEN {}", hbm, ) << std::endl;
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
    uint64_t compute_units = 2;
    uint64_t tile_height = 1024 * 32;
    uint64_t min_blocks_per_tile = 16;

    // load matrix from file
    Matrix m = Matrix::load(path, tile_height);

    // memory layout
    uint64_t hbm_base = 0x800000000;
    uint64_t hbm_stride = 0x1000000;

    if(iterations == 0) {
        // upload matrix to device distributed across hbm banks
        for (uint64_t i = 0; i < compute_units; i++) {
            std::vector<uint8_t> data = m.get_compute_unit_data(i, compute_units, min_blocks_per_tile);
            uint64_t hbm_addr = hbm_base + hbm_stride * i;
            //tapasco.copy_to(data.data(), hbm_addr, data.size());
            // cue to store the compute unit data in files
            store(std::format("hbm{}.mem", i), data.data(), data.size(), 256);
        }

        // generate a test vector
        std::vector<float> x_vec(m.width, 0.0);
        for (uint64_t i = 0; i < x_vec.size(); i++) {
            x_vec[i] = random();
        }
        std::vector<float> expected_result = m.mul(x_vec);

        // Store the vector 
        store("x_vec.mem", reinterpret_cast<const uint8_t*>(x_vec.data()), x_vec.size() * sizeof(float), 512);
        store("expected.mem", reinterpret_cast<const uint8_t*>(expected_result.data()), expected_result.size() * sizeof(float), 512);

        store_matrix_size("matrix_params.vh", m, compute_units);

        return;
    }

    for (uint64_t i = 0; i < compute_units; i++) {
        std::vector<uint8_t> data = m.get_compute_unit_data(i, compute_units, min_blocks_per_tile);
        uint64_t hbm_addr = hbm_base + hbm_stride * i;
        tapasco.copy_to(data.data(), hbm_addr, data.size());
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
