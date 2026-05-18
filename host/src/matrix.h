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

class Tile {
public:
    uint64_t tx;
    uint64_t ty;
    uint64_t x;
    uint64_t y;
    uint64_t width;
    uint64_t height;
    std::vector<Entry> entries;

    void append(std::vector<uint8_t> &data, uint64_t min_blocks_per_tile);

    void rearrange_entries();

};

class Matrix {

public:
    uint64_t tile_width;
    uint64_t tile_height;
    uint64_t width;
    uint64_t height;
    std::vector<Tile> tiles;

    static Matrix load(std::string path, uint64_t tile_height);
    std::vector<float> mul(std::vector<float> &v);
    std::vector<uint8_t> get_compute_unit_data(uint64_t i, uint64_t compute_units, uint64_t min_blocks_per_tile);

};
