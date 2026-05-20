#include "matrix.h"

#include <cstdint>
#include <vector>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstring>
#include <cassert>

void Tile::append(std::vector<uint8_t> &data, uint64_t min_blocks_per_tile) {
    uint64_t first_entry_idx = 0;
    bool tile_last = false;
    uint64_t block_count = 0;

    while (!tile_last) {
        block_count += 1;
        float    val[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        uint64_t x[6]   = {0, 0, 0, 0, 0, 0};
        uint64_t y[6]   = {0, 0, 0, 0, 0, 0};
        uint64_t dy[6]  = {0, 0, 0, 0, 0, 0};
        uint64_t count  = 0;
        for (uint64_t i = 0; i < 6 && first_entry_idx + i < entries.size(); i++) {
            uint64_t j = i + first_entry_idx;
            tile_last = j + 1 == entries.size() && block_count >= min_blocks_per_tile;
            dy[i] = tile_last ? 255 : entries[j+1].y - entries[j].y;
            x[i] = entries[j].x % 1024;
            y[i] = entries[j].y;
            val[i] = entries[j].val;

            // check for bank conflicts
            bool bank_conflict = false;
            for (uint64_t k = 0; k < i; k++) {
                if (y[i] % 16 == y[k] % 16 && y[i] != y[k]) {
                    // bank conflict
                    bank_conflict = true;
                    break;
                }
            }
            if (bank_conflict) {
                break;
            }
            count += 1;
        }

        // check if we can use a `Float6` block here
        bool use_float6 = true;
        // only use Float6 iff
        // - we actually have six values
        // - it is not the last block of the tile (must be Float5)
        if (count != 6 || tile_last) {
            use_float6 = false;
        }
        // - no dy may be at more than 1
        for (uint64_t i = 0; i < 6; i++) {
            if (dy[i] > 1) {
                use_float6 = false;
                break;
            }
        }
        // - the last bits must be representable by a combination of mode and x values
        //   => compute the last mask by setting every necessary last bits (smaller new x value implies last bit)
        uint8_t last_mask = 0;
        for (uint64_t i = 0; i < 6; i++) {
            if (dy[i] == 1 && (i == 0 || x[i] > x[i-1])) {
                last_mask |= 1 << i;
            }
        }
        // check if the computed last_mask is available
        uint8_t mode = 0b1111;
        uint8_t available_last_masks[15] = {
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
        for (uint64_t i = 0; i < 15; i++) {
            if (available_last_masks[i] == last_mask) {
                mode = i;
                break;
            }
        }
        if (mode == 0b1111) {
            use_float6 = false;
        }

        // append new block
        if (use_float6) {
            Float6 block{
                weights: { val[0], val[1], val[2], val[3], val[4], val[5] },
                x_index_5: x[5],
                x_index_4: x[4],
                x_index_3: x[3],
                x_index_2: x[2],
                x_index_1: x[1],
                x_index_0: x[0],
                mode     : mode,
            };
            const uint8_t* ptr = reinterpret_cast<const uint8_t*>(&block);
            data.insert(data.end(), ptr, ptr + sizeof(Float6));
            first_entry_idx += 6;
        } else {
            Float5 block{
                weights: { val[0], val[1], val[2], val[3], val[4] },
                y_delta0 : dy[0],
                y_delta1 : dy[1],
                y_delta2 : dy[2],
                y_delta3 : dy[3],
                y_delta4 : dy[4],
                last_in_x : tile_last ? 1 : 0,
                last_in_y : tile_last ? 1 : 0,
                x_index_4: x[4],
                x_index_3: x[3],
                x_index_2: x[2],
                x_index_1: x[1],
                x_index_0: x[0],
                mode     : 0b1111,
            };
            const uint8_t* ptr = reinterpret_cast<const uint8_t*>(&block);
            data.insert(data.end(), ptr, ptr + sizeof(Float5));
            first_entry_idx += count > 5 ? 5 : count;
        }
    }

    // in case the tile is very empty, we must add some filler blocks to prevent conflicts with the next tile.
    while (block_count < 16) {
        block_count += 1;
        Float5 block{
            weights: { 0.0, 0.0, 0.0, 0.0, 0.0 },
            y_delta0 : 0,
            y_delta1 : 0,
            y_delta2 : 0,
            y_delta3 : 0,
            y_delta4 : 0,
            last_in_x : block_count == 16,
            last_in_y : block_count == 16,
            x_index_4: 0,
            x_index_3: 0,
            x_index_2: 0,
            x_index_1: 0,
            x_index_0: 0,
            mode     : 0b1111,
        };
        const uint8_t* ptr = reinterpret_cast<const uint8_t*>(&block);
        data.insert(data.end(), ptr, ptr + sizeof(Float5));
    }
}

void Tile::rearrange_entries() {
    // sort entries within each tile in ascending y, then x coordinate
    std::sort(this->entries.begin(), this->entries.end(), [](const Entry &a, const Entry &b) {
        if (a.y == b.y) {
            return a.x < b.x;
        } else {
            return a.y < b.y;
        }
    });

    // insert zero-entries to step through large empty regions
    for (size_t i = 1; i < entries.size(); i++) {
        if (entries[i].y - entries[i-1].y > 255) {
            // TODO: optimize, because this might cause avoidable bank conflics
            entries.insert(entries.begin()+i, Entry{x: 0, y: entries[i-1].y+255, val: 0.0});
        }
    }
}

Matrix Matrix::load(std::string path, uint64_t tile_height) {
    std::ifstream file(path);
    if (!file) {
        throw std::runtime_error("Failed to open file");
    }

    // ------------------------------------------------------------
    // Read header
    // ------------------------------------------------------------

    std::string header;

    if (!std::getline(file, header)) {
        throw std::runtime_error("Empty file");
    }

    if (!header.starts_with("%%MatrixMarket")) {
        throw std::runtime_error("Not a Matrix Market file");
    }

    std::istringstream header_stream(header);

    std::string banner;
    std::string object;
    std::string format;
    std::string field;
    std::string symmetry;

    header_stream
        >> banner
        >> object
        >> format
        >> field
        >> symmetry;

    if (!header_stream) {
        throw std::runtime_error("Invalid Matrix Market header");
    }

    if (object != "matrix") {
        throw std::runtime_error("Only matrix objects supported");
    }

    if (format != "coordinate") {
        // other options are:
        // - array: for dense matrices (we don't need those)
        throw std::runtime_error("Only coordinate format supported");
    }

    if (field != "real") {
        // other options are:
        // - integer (would be possible to support with rounding errors)
        // - complex (not supported by hardware)
        // - pattern (not supported by hardware)
        throw std::runtime_error("Only real matrices supported");
    }

    if (symmetry != "general" && symmetry != "symmetric" && symmetry != "skew-symmetric") {
        // other options are:
        // - hermitian
        throw std::runtime_error("Only general, symmetric, and skew-symmetric matrices supported");
    }
    bool symmetric = (symmetry == "symmetric");
    bool skew_symmetric = (symmetry == "skew-symmetric");

    // ------------------------------------------------------------
    // Skip comments and read size line
    // ------------------------------------------------------------

    std::string size_line;

    while (std::getline(file, size_line)) {

        auto first = size_line.find_first_not_of(" \t\r\n");

        if (first == std::string::npos) {
            continue;
        }

        if (size_line[first] == '%') {
            continue;
        }

        break;
    }

    if (size_line.empty()) {
        throw std::runtime_error("Missing size line");
    }

    // ------------------------------------------------------------
    // Read dimensions
    // ------------------------------------------------------------

    std::istringstream dims_stream(size_line);

    size_t rows;
    size_t cols;
    size_t nnz;

    dims_stream >> rows >> cols >> nnz;

    if (!dims_stream) {
        throw std::runtime_error("Invalid size line");
    }

    // create matrix
    Matrix m = Matrix{
        tile_width: 1024,
        tile_height: tile_height,
        width: cols,
        height: rows,
    };
    uint64_t tile_width = 1024;
    // create tiles
    for (uint64_t y = 0, ty = 0; y < m.height; y += m.tile_height, ty++) {
        for (uint64_t x = 0, tx = 0; x < m.width; x += m.tile_width, tx++) {
            m.tiles.push_back(Tile{
                tx: tx,
                ty: ty,
                x: x,
                y: y,
                width: std::min(m.width - x, tile_width),
                height: std::min(m.height - y, tile_height)
            });
        }
    }
    uint64_t tiles_per_row = (m.width + tile_width - 1) / tile_width;

    // ------------------------------------------------------------
    // Read entries
    // ------------------------------------------------------------

    // Note:
    // Entries are read and directly inserted into the correct tile as opposed to storing all entries in a large array and distributing them later.
    // This is because I anticipate that this matrix is very large and we don't want to store it in memory twice.

    std::string line;
    while (std::getline(file, line)) {
        auto first = line.find_first_not_of(" \t\r\n");
        if (first == std::string::npos) {
            continue;
        }
        if (line[first] == '%') {
            continue;
        }

        std::istringstream entry_stream(line);

        size_t col;
        size_t row;
        float value;

        entry_stream >> row >> col >> value;

        if (!entry_stream) {
            throw std::runtime_error(
                "Invalid entry line: " + line
            );
        }

        // Matrix Market uses 1-based indexing
        col -= 1;
        row -= 1;

        uint64_t tile_idx = (row / m.tile_height * tiles_per_row) + (col / tile_width);
        m.tiles[tile_idx].entries.push_back(Entry{ x: row, y: col, val: value });
        // Expand symmetry
        if ((symmetric || skew_symmetric) && row != col) {
            uint64_t tile_idx = (col / m.tile_height * tiles_per_row) + (row / tile_width);
            m.tiles[tile_idx].entries.push_back(Entry{ x: col, y: row, val: skew_symmetric ? -value : value });
        }
    }

    // post process tiles
    for (Tile &tile : m.tiles) {
        tile.rearrange_entries();
    }
    return m;
}

std::vector<float> Matrix::mul(std::vector<float> &v) {
    assert(v.size() == width);
    std::vector<float> r(height, 0.0);

    for (Tile &tile : tiles) {
        for (Entry &entry : tile.entries) {
            r[entry.y] += entry.val * v[entry.x];
        }
    }

    return r;
}

std::vector<uint8_t> Matrix::get_compute_unit_data(uint64_t i, uint64_t compute_units, uint64_t min_blocks_per_tile) {
    uint64_t tiles_per_row = (width + tile_width - 1) / tile_width;
    std::vector<uint8_t> blocks;

    for (Tile &tile : tiles) {
        if (tile.ty % compute_units == i) {
            tile.append(blocks, min_blocks_per_tile);
        }
    }

    return blocks;
}
