
#define SUSPMV_PE_ID 100
#define TAPASCO_DEVICE_IDX 1

const size_t TILE_X_WIDTH = 1024;
const size_t MIN_BLOCKS_PER_TILE = 18;
const size_t NUM_Y_BANKS = 16;

// accelerator config
const uint64_t COMPUTE_UNITS = 4;
const uint64_t HW_COMPUTE_UNITS = 32;
const uint64_t MAX_TILE_Y_HEIGHT = 2048 * NUM_Y_BANKS;

// memory layout
const uint64_t HBM_BASE   = 0x400000000;
const uint64_t HBM_STRIDE =  0x10000000;

constexpr const uint8_t LAST_MASKS[15] = {
    0b000000,
    0b000001,
    0b000010,
    0b000100,
    0b001000,
    0b010000,
    0b100000,
    0b100001,
    0b010001,
    0b100010,
    0b001001,
    0b010010,
    0b100100,
    0b101000,
    0b110000,
};
