#include "matrix.h"
#include "consts.h"
#include <random>
#include <iostream>
#include <iomanip>
#include <format>

template<typename T, size_t ROW_BITS>
void store(std::string path, const std::vector<T>& data) {
    std::cout << "Data element size is " << sizeof(T) << std::endl;
    const uint8_t* data_ptr = reinterpret_cast<const uint8_t*>(data.data());
    size_t data_len = data.size() * sizeof(T);

    std::cout << "Writing Hex Data to " << path << std::endl;

    std::ofstream out(path);

    constexpr size_t ROW_BYTES = ROW_BITS / 8;

    char row_buf[ROW_BYTES * 2 + 2];
    row_buf[ROW_BYTES * 2] = '\n';
    row_buf[ROW_BYTES * 2 + 1] = '\0';
    for(size_t i = 0; i < data_len; i += ROW_BYTES) {
        for(size_t j = 0; j < ROW_BYTES; j++) {
            constexpr const char* HEX = "0123456789abcdef";
            uint8_t v;
            if(i + j < data_len) {
                v = data_ptr[i + j];
            } else {
                v = 0;
            }
            row_buf[ROW_BYTES * 2 - 2 - j*2] = HEX[v / 16];
            row_buf[ROW_BYTES * 2 - 2 - j*2 + 1] = HEX[v % 16];
        }
        out << row_buf;
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
        store<MatrixDataBlock, 256>(std::format("hbm{}.mem", i), data.hbm_buffers[i]);
    }

    out.close();
}

int dump_hex(Matrix& m, ComputeUnitData& data, std::vector<float>& x_vec) {
    std::vector<float> expected_result = data.mul(x_vec);

    // Store the vector 
    store<float, 512>("x_vec.mem", x_vec);
    store<float, 512>("expected.mem", expected_result);

    store_matrix_size("matrix_params.vh", m, data);

    return 0;
}
