#include "matrix.h"
#include "consts.h"
#include <random>
#include <iostream>
#include <iomanip>
#include <format>

template<typename T>
void store(std::string path, const std::vector<T>& data, size_t row_bits) {
    const uint8_t* data_ptr = reinterpret_cast<const uint8_t*>(data.data());
    size_t data_len = data.size() * sizeof(T);

    std::cout << "Writing Hex Data to " << path << std::endl;

    std::ofstream out(path);

    size_t row_bytes = row_bits / 8;
    for (size_t i = 0; i < data_len; ++i) {
        out << std::format("{:02x}", data_ptr[i]);

        if (i % row_bytes == row_bytes-1 || i == data_len-1) {
            out << '\n';
        }
    }

    out.close();
}

void store_matrix_size(std::string path, Matrix& m, ComputeUnitData& data) {
    std::cout << "Writing Matrix Size Information to " << path << std::endl;

    std::ofstream out(path);

    out << "`define X_VEC_LEN " << m.width << std::endl;
    out << "`define Y_VEC_LEN " << m.height << std::endl;
    out << "`define COMPUTE_UNITS " << COMPUTE_UNITS << std::endl;
    out << "`define X_TILES " << data.x_tiles << std::endl;
    out << "`define Y_REPEATS " << data.y_repeats << std::endl;

    for(size_t i = 0; i < COMPUTE_UNITS; i++) {
        uint64_t hbm_addr = HBM_BASE + HBM_STRIDE * i;
        out << std::format("`define HBM{}_ADDR {}", i, hbm_addr) << std::endl;
        out << std::format("`define HBM{}_LEN {}", i, data.hbm_buffers[i].size()) << std::endl;

        // cue to store the compute unit data in files
        store(std::format("hbm{}.mem", i), data.hbm_buffers[i], 256);
    }

    out.close();
}

int dump_hex(Matrix& m, ComputeUnitData& data) {
    // generate a test vector
    std::vector<float> x_vec(m.width, 0.0);
    for (uint64_t i = 0; i < x_vec.size(); i++) {
        x_vec[i] = random();
    }
    std::vector<float> expected_result = m.mul(x_vec);

    // Store the vector 
    store("x_vec.mem", x_vec, 512);
    store("expected.mem", expected_result, 512);

    store_matrix_size("matrix_params.vh", m, data);

    return 0;
}
