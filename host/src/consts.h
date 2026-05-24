
const size_t TILE_X_WIDTH = 1024;
const size_t MIN_BLOCKS_PER_TILE = 18;
const size_t NUM_Y_BANKS = 16;

// accelerator config
const uint64_t COMPUTE_UNITS = 2;
const uint64_t MAX_TILE_Y_HEIGHT = 2048 * NUM_Y_BANKS;

// memory layout
const uint64_t HBM_BASE = 0x800000000;
const uint64_t HBM_STRIDE = 0x1000000;
