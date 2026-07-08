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
    uint64_t block_idx;
};

struct Builder {
    std::vector<MatrixDataBlock> blocks;
    std::vector<BuilderEntry> entries;
    std::vector<BuilderEntry> conflict_entries;
    uint64_t unit;
    bool first_entry_in_tile;
    bool y_max_added;
    bool accumulator_zero;
    uint64_t x_tile;
    uint64_t y_pos;
    uint64_t y_max;
    uint64_t y_max_tile_idx;
    uint64_t failed_float6_due_to_last_map;
    uint64_t float6_count;
    uint64_t bank_conflicts;
    uint64_t bank_conflict_zeroes;
    uint64_t y_conflicts;
    uint64_t y_conflict_zeroes;
    uint64_t trampolin_zeroes;
    uint64_t endoftile_zeroes;

    Builder();
    void add(Entry entry, bool last_in_tile, bool last_in_y);

    bool has_bank_conflict(uint64_t *y, uint64_t len, uint64_t new_y);
    bool has_y_conflict(uint64_t y);
    void build_block();
};

std::ostream& operator<<(std::ostream& ostr, MatrixDataBlock m_data);

struct Matrix;
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
    Matrix convert();
};

struct Matrix {
    uint64_t width;
    uint64_t height;
    std::vector<Entry> entries;
    std::vector<size_t> y_froms;

    static Matrix load(std::string path);
    static Matrix load2(std::string path);
    void shuffle_random();
    void shuffle();
    std::vector<float> mul(std::vector<float>& v);
    bool compare(Matrix &m);
    ComputeUnitData get_compute_unit_data();
    std::vector<size_t> get_count_per_col();
    std::vector<size_t> get_count_per_row();
    void cut_to_range(size_t from_x, size_t from_y, size_t to_x, size_t to_y);
};

struct Shuffler {
	Matrix *m;
    float seg_width;
    float seg_height;
    uint64_t hm_width;
    uint64_t hm_height;
    std::vector<int64_t> heatmap;
    std::vector<std::vector<uint64_t>> col_idx;
    std::vector<std::vector<uint64_t>> row_idx;
    std::vector<uint64_t> shuffle_row;
    std::vector<uint64_t> shuffle_col;
    std::vector<uint64_t> ishuffle_row;
    std::vector<uint64_t> ishuffle_col;

    void init(Matrix *mat);
    void shuffle();

    int64_t test_swap_rows(uint64_t a, uint64_t b, std::vector<int64_t> &delta);
    int64_t test_swap_cols(uint64_t a, uint64_t b, std::vector<int64_t> &delta);

    void swap_rows(uint64_t a, uint64_t b, std::vector<int64_t> &delta);
    void swap_cols(uint64_t a, uint64_t b, std::vector<int64_t> &delta);

};
