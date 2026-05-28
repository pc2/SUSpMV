#pragma once

#include <cstdint>
#include <vector>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <cassert>

struct Entry {
    uint64_t x;
    uint64_t y;
    float val;
};

struct Float5 {
    float weights[5];
    uint8_t y_delta0;
    uint8_t y_delta1;
    uint8_t y_delta2;
    uint8_t y_delta3;
    uint64_t y_delta4  : 8;
    uint64_t last_in_x : 1;
    uint64_t last_in_y : 1;
    uint64_t x_index_4 : 10;
    uint64_t x_index_3 : 10;
    uint64_t x_index_2 : 10;
    uint64_t x_index_1 : 10;
    uint64_t x_index_0 : 10;
    uint64_t mode      : 4; // == 4'b1111
};

struct Float6 {
    float weights[6];
    uint64_t x_index_5 : 10;
    uint64_t x_index_4 : 10;
    uint64_t x_index_3 : 10;
    uint64_t x_index_2 : 10;
    uint64_t x_index_1 : 10;
    uint64_t x_index_0 : 10;
    uint64_t mode      : 4;
};

union MatrixDataBlock {
    Float5 float5;
    Float6 float6;
};

struct BuilderEntry {
    uint64_t x;
    uint64_t y;
    float val;
    bool last_in_x;
    bool last_in_y;
};

struct Builder {
    std::vector<MatrixDataBlock> blocks;
    std::vector<BuilderEntry> entries;
    bool first_entry_in_tile;
    uint64_t y_pos;

    Builder();
    void add(Entry &entry, bool last_in_tile, bool last_in_y);

private:
    bool has_bank_conflict(uint64_t *y, uint64_t new_idx);
    bool has_y_conflict(uint64_t y);
    void build_block();
};

std::ostream& operator<<(std::ostream& ostr, MatrixDataBlock m_data);

struct ComputeUnitData {
    std::vector<std::vector<MatrixDataBlock>> hbm_buffers;
    uint64_t x_tiles;
    /// y_tiles would then be y_repeats * COMPUTE_UNITS
    uint64_t y_repeats;

    uint64_t width;
    uint64_t height;
    std::vector<size_t> y_froms;

    /// For sanity-check against the hardware impl
    std::vector<float> mul(std::vector<float>& v);
};

struct Matrix {
    uint64_t width;
    uint64_t height;
    std::vector<Entry> entries;

    static Matrix load(std::string path);
    std::vector<float> mul(std::vector<float>& v);
    ComputeUnitData get_compute_unit_data(uint64_t compute_units, uint64_t num_y_repeats);
};
