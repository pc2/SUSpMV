#include "matrix.h"
#include "consts.h"

#include <cstdint>
#include <vector>
#include <span>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <format>
#include <cstring>
#include <cassert>

/// Splits this y slice of the matrix across 1024-element wide tiles
/// 
/// As it splits up the X values, it subtracts the x_base from the tile, as well as the y_base provided, such that:
/// Entry x in 0..1024
/// Entry y in 0..32768
void split_region_tiles_x_axis(std::span<Entry> entry_span, std::vector<std::vector<Entry>>& x_tiles, size_t y_base) {
    for(std::vector<Entry>& e : x_tiles) {
        e.clear();
    }
    for(Entry e : entry_span) {
        assert(e.y >= y_base);
        x_tiles[e.x / TILE_X_WIDTH].push_back(Entry{
            x: e.x % TILE_X_WIDTH,
            y: e.y - y_base,
            val: e.val
        });
    }
}

void append_tile_entries(std::vector<Entry>& entries, std::vector<MatrixDataBlock>& data, bool is_last_in_y) {
    uint64_t first_entry_idx = 0;
    bool tile_last = false;
    uint64_t block_count = 0;

    while (!tile_last) {
        block_count += 1;
        float    val[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        uint64_t x[6]   = {0, 0, 0, 0, 0, 0};
        uint64_t y[6]   = {0, 0, 0, 0, 0, 0};
        uint8_t  dy[6]  = {0, 0, 0, 0, 0, 0};
        uint64_t count  = 0;
        for (uint64_t i = 0; i < 6 && first_entry_idx + i < entries.size(); i++) {
            uint64_t j = i + first_entry_idx;
            assert(j < entries.size());
            tile_last = j + 1 == entries.size() && block_count >= MIN_BLOCKS_PER_TILE;
            // TODO: Insert zeros when delta_y would not fit in 8 bit. 
            dy[i] = static_cast<uint8_t>(tile_last ? 255 : entries[j+1].y - entries[j].y);
            assert(entries[j].x < 1024);
            assert(entries[j].y < 2048 * 16);
            x[i] = entries[j].x;
            y[i] = entries[j].y;
            val[i] = entries[j].val;

            // check for bank conflicts
            bool bank_conflict = false;
            for (uint64_t k = 0; k < i; k++) {
                if (y[i] % NUM_Y_BANKS == y[k] % NUM_Y_BANKS && y[i] != y[k]) {
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
            MatrixDataBlock block;
            block.float6 = Float6{
                weights: { val[0], val[1], val[2], val[3], val[4], val[5] },
                x_index_5: x[5],
                x_index_4: x[4],
                x_index_3: x[3],
                x_index_2: x[2],
                x_index_1: x[1],
                x_index_0: x[0],
                mode     : mode,
            };
            data.push_back(block);
            first_entry_idx += 6;
        } else {
            MatrixDataBlock block;
            block.float5 = Float5{
                weights: { val[0], val[1], val[2], val[3], val[4] },
                y_delta0 : dy[0],
                y_delta1 : dy[1],
                y_delta2 : dy[2],
                y_delta3 : dy[3],
                y_delta4 : dy[4],
                last_in_x : tile_last ? 1u : 0u,
                last_in_y : tile_last ? 1u : 0u,
                x_index_4: x[4],
                x_index_3: x[3],
                x_index_2: x[2],
                x_index_1: x[1],
                x_index_0: x[0],
                mode     : 0b1111,
            };
            data.push_back(block);
            first_entry_idx += count > 5 ? 5 : count;
        }
    }

    // in case the tile is very empty, we must add some filler blocks to prevent conflicts with the next tile.
    while (block_count < MIN_BLOCKS_PER_TILE) {
        block_count += 1;

        MatrixDataBlock block;
        block.float5 = Float5{
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
        data.push_back(block);
    }
}

Matrix Matrix::load(std::string path) {
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
        width: cols,
        height: rows,
        entries: std::vector<Entry>()
    };

    // ------------------------------------------------------------
    // Read entries
    // ------------------------------------------------------------

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
        
        m.entries.push_back(Entry{x: col, y: row, val: value});
        // Expand symmetry
        if ((symmetric || skew_symmetric) && row != col) {
            m.entries.push_back(Entry{ x: col, y: row, val: skew_symmetric ? -value : value });
        }
    }

    // sort entries in ascending y, then x coordinate
    std::sort(m.entries.begin(), m.entries.end(), [](const Entry &a, const Entry &b) {
        if (a.y == b.y) {
            return a.x < b.x;
        } else {
            return a.y < b.y;
        }
    });

    return m;
}

std::vector<float> Matrix::mul(std::vector<float> &v) {
    assert(v.size() == width);
    std::vector<float> r(height, 0.0);

    for (Entry &entry : this->entries) {
        r[entry.y] += entry.val * v[entry.x];
    }

    return r;
}

// Currently we pass num_y_repeats as a simple parameter. In the future this function should itself decide how many repeats to use. 
ComputeUnitData Matrix::get_compute_unit_data(uint64_t compute_units, uint64_t num_y_repeats) {
    uint64_t tiles_per_row = (width + TILE_X_WIDTH - 1) / TILE_X_WIDTH;
    size_t total_y_partitions = compute_units*num_y_repeats;

    // Temporary memory to split a single rows block into its constituent tiles. 
    std::vector<std::vector<Entry>> current_x_tile_split(tiles_per_row);

    // The final memory buffers, these should be uploaded to the FPGA. 
    std::vector<std::vector<MatrixDataBlock>> hbm_buffers(compute_units);

    std::vector<size_t> y_split_points;
    y_split_points.reserve(total_y_partitions+1);
    std::vector<uint64_t> y_froms;
    y_froms.reserve(total_y_partitions);

    std::cout << "Determining Y splits" << std::endl;

    y_split_points.push_back(0);
    y_froms.push_back(0);
    for(size_t i = 1; i < total_y_partitions; i++) {
        size_t desired_split_location = this->entries.size() * i / total_y_partitions;

        uint64_t desired_split_y = this->entries[desired_split_location].y;
        while(desired_split_location >= 1 && this->entries[desired_split_location-1].y == desired_split_y) {
            desired_split_location--;
        }

        y_split_points.push_back(desired_split_location);
        y_froms.push_back(desired_split_y);
    }
    y_split_points.push_back(this->entries.size());
    y_froms.push_back(this->height);

    for(size_t i = 0; i < total_y_partitions; i++) {
        size_t cur_hbm = i % compute_units;

        size_t from = y_split_points[i];
        size_t to = y_split_points[i+1];

        std::cout << std::format("Placing Y {}..{} (entries {}..{}) in compute unit {}", y_froms[i], y_froms[i+1], from, to, cur_hbm) << std::endl;

        assert(from <= to);
        assert(to <= this->entries.size());
        std::span<Entry> entries_here = std::span(this->entries).subspan(from, to - from);

        for(Entry& e : entries_here) {
            assert(e.x < this->width);
            assert(e.y < this->height);
        }
        split_region_tiles_x_axis(entries_here, current_x_tile_split, y_froms[i]);
        for(std::vector<Entry>& tile : current_x_tile_split) {
            for(Entry& e : tile) {
                assert(e.x < TILE_X_WIDTH);
                assert(e.y < MAX_TILE_Y_HEIGHT);
            }
        }

        for(size_t tile_x = 0; tile_x < current_x_tile_split.size(); tile_x++) {
            append_tile_entries(current_x_tile_split[tile_x], hbm_buffers[cur_hbm], tile_x == current_x_tile_split.size()-1);
        }
    }

    return ComputeUnitData{
        hbm_buffers: hbm_buffers,
        x_tiles: tiles_per_row,
        y_repeats: num_y_repeats
    };
}
