#include <tapasco.hpp>
#include "matrix.h"
#include "consts.h"
#include <vector>
#include <random>

#define SUSPMV_PE_ID 100

int dump_hex(Matrix& m, ComputeUnitData& data);

int main(int argc, char **argv) {
    if (argc != 3) {
        std::cout << "usage: ./suspmv <path to .mtx> <iterations>" << std::endl;
        return 0;
    }
    std::string path(argv[1]);
    uint64_t iterations = std::stoi(argv[2]);

    // Temporary, should be computed automatically in the future
    uint64_t y_repeats = 1;

    // load matrix from file
    Matrix m = Matrix::load(path);
    ComputeUnitData data = m.get_compute_unit_data(COMPUTE_UNITS, y_repeats);

    if(iterations == 0) {
        dump_hex(m, data);
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
        std::vector<float> v(m.width, 0.0);
        std::vector<float> result(m.height);
        for (uint64_t i = 0; i < v.size(); i++) {
            v[i] = random();
        }

        auto v_buffer = tapasco::makeInOnly(tapasco::makeWrappedPointer(v.data(), v.size() * sizeof(float)));
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
        std::vector<float> reference = m.mul(v);
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
