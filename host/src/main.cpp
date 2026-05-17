//#include <tapasco.hpp>
#include "matrix.h"
#include <random>

#define SUSPMV_PE_ID 100

int main(int argc, char **argv) {
    if (argc != 2) {
        std::cout << "usage: ./suspmv <path to .mtx>" << std::endl;
        return 0;
    }
    std::string path(argv[1]);

    // initialize TaPaSCo
    //tapasco::Tapasco tapasco;

    // accelerator config
    uint64_t compute_units = 32;
    uint64_t tile_height = 1024 * 32;

    // load matrix from file
    Matrix m = Matrix::load(path, tile_height);

    // memory layout
    uint64_t hbm_base = 0x800000000;
    uint64_t hbm_stride = 0x1000000;
    uint64_t ddr_base   = 0x1800000000;
    uint64_t ddr_stride = sizeof(float) * (m.width + m.height);

    // upload matrix to device distributed across hbm banks
    for (uint64_t i = 0; i < compute_units; i++) {
        std::vector<uint8_t> data = m.get_compute_unit_data(i, compute_units);
        uint64_t hbm_addr = hbm_base + hbm_stride * i;
        //tapasco.copy_to(data.data(), hbm_addr, data.size());
    }

    for (uint64_t iter = 0; iter < 1; iter++) {
        // generate & upload test vector
        std::vector<float> v(m.width, 0.0);
        std::vector<float> result(m.height);
        for (uint64_t i = 0; i < v.size(); i++) {
            v[i] = random();
        }

        uint64_t v_addr = ddr_base + ddr_stride * iter;
        uint64_t r_addr = ddr_base + ddr_stride * iter + sizeof(float) * m.width;
        //tapasco.copy_to((uint8_t*)v.data(), v_addr, v.size() * sizeof(float));

        // launch spvm
        /*auto job = tapasco.launch(
            SUSPMV_PE_ID, 
            m.width, m.height,
            v_addr, r_addr
        );
        job();
        tapasco.copy_from(r_addr, (uint8_t*)result.data(), v.size() * sizeof(float));*/

        // check result integrity
        std::vector<float> reference = m.mul(v);
        for (uint64_t i = 0; i < m.height; i++) {
            //assert(abs(result[i] - reference[i]) < 0.1);
        }
    }

    return 0;
}
