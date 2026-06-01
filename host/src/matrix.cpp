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

static_assert(sizeof(MatrixDataBlock) == 256 / 8);

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

std::ostream& operator<<(std::ostream& ostr, Entry e) {
    ostr << std::format("[{},{}]*{}", e.x, e.y, e.val);
    return ostr;
}
std::ostream& operator<<(std::ostream& ostr, MatrixDataBlock m_data) {
    if(m_data.float5.mode == 0b1111) {
        uint64_t x_indices[5] = {
            m_data.float5.x_index_0,
            m_data.float5.x_index_1,
            m_data.float5.x_index_2,
            m_data.float5.x_index_3,
            m_data.float5.x_index_4
        };
        uint64_t dys[5] = {
            m_data.float5.y_delta0,
            m_data.float5.y_delta1,
            m_data.float5.y_delta2,
            m_data.float5.y_delta3,
            m_data.float5.y_delta4
        };
        ostr << "Float5";
        for(int i = 0; i < 5; i++) {
            ostr << std::format(" [{}]*{}", x_indices[i], m_data.float5.weights[i]);
            if(dys[i] != 0) {
                ostr << std::format("(+{})", dys[i]);
            }
        }
        if(m_data.float5.last_in_x) {
            ostr << " X Last";
        }
        if(m_data.float5.last_in_y) {
            ostr << " Y Last";
        }
    } else {
        uint64_t x_indices[6] = {
            m_data.float6.x_index_0,
            m_data.float6.x_index_1,
            m_data.float6.x_index_2,
            m_data.float6.x_index_3,
            m_data.float6.x_index_4,
            m_data.float6.x_index_5
        };
        bool lasts[6];
        uint8_t last_mask = LAST_MASKS[m_data.float6.mode];
        for(int i = 0; i < 6; i++) {
            lasts[i] = (last_mask & (1 << i)) != 0;
        }
        for(int i = 0; i < 6-1; i++) {
            if(x_indices[i+1] <= x_indices[i]) {
                lasts[i] |= true;
            }
        }
        ostr << "Float6";
        for(int i = 0; i < 6; i++) {
            ostr << std::format(" [{}]*{}", x_indices[i], m_data.float6.weights[i]);
            if(lasts[i]) {
                ostr << "(+1)";
            }
        }
    }
    return ostr;
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
            m.entries.push_back(Entry{ x: row, y: col, val: skew_symmetric ? -value : value });
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

    // Check no duplicates
    Entry prev {x: 1ull << 63, y: 1ull << 63, val: 0.0};
    for(Entry e : m.entries) {
        if(prev.x == e.x && prev.y == e.y) {
            std::cout << std::format("Duplicate element for X: {}, Y: {}", e.x, e.y) << std::endl;
            exit(1);
        }
        prev = e;
    }

    return m;
}

bool Matrix::compare(Matrix &m) {
	bool equal = true;
	if (entries.size() != m.entries.size()) {
		std::cout << entries.size() << "  " << m.entries.size() << std::endl;
		equal = false;
	}
	for (uint64_t i = 0; i < entries.size() && i < m.entries.size(); i++) {
		if (entries[i].x != m.entries[i].x || entries[i].y != m.entries[i].y || entries[i].val != m.entries[i].val) {
            std::cout << entries[i] << "  " << m.entries[i] << std::endl;
			equal = false;
		} else {
            //std::cout << entries[i] << std::endl;
		}
	}
	if (!equal) {	
        std::cout << "DISCREPANCY BETWEEN matrices FOUND!" << std::endl;
	}
	return equal;
}

std::vector<float> Matrix::mul(std::vector<float>& v) {
    assert(v.size() == width);
    std::vector<float> r(height, 0.0);

    for (Entry &entry : this->entries) {
        r[entry.y] += entry.val * v[entry.x];
    }

    return r;
}

std::vector<float> ComputeUnitData::mul(std::vector<float>& x_vec) {
    std::vector<float> result(this->height, 0.0);

    for(size_t compute_unit = 0; compute_unit < this->hbm_buffers.size(); compute_unit++) {
        float cur_x_tile[TILE_X_WIDTH];
        double cur_y_tile[MAX_TILE_Y_HEIGHT];
        uint64_t cur_x = 0;
        uint64_t cur_y = 0;
        uint64_t cur_y_repeat = 0;
        double cur_accumulator = 0.0;
        for(size_t i = 0; i < TILE_X_WIDTH; i++) {
            cur_x_tile[i] = 0.0;
        }
        for(size_t i = 0; i < TILE_X_WIDTH && cur_x < x_vec.size(); i++) {
            cur_x_tile[i] = x_vec[cur_x++];
        }
        for(size_t i = 0; i < MAX_TILE_Y_HEIGHT; i++) {
            cur_y_tile[i] = 0.0;
        }
        std::cout << "Compute Unit " << compute_unit << std::endl;
        for(MatrixDataBlock& elem : this->hbm_buffers[compute_unit]) {
            std::cout << elem << std::endl;
            if(elem.float5.mode == 0b1111) {
                // It's a float5
                uint64_t x_indices[5] = {
                    elem.float5.x_index_0,
                    elem.float5.x_index_1,
                    elem.float5.x_index_2,
                    elem.float5.x_index_3,
                    elem.float5.x_index_4
                };
                uint64_t dys[5] = {
                    elem.float5.y_delta0,
                    elem.float5.y_delta1,
                    elem.float5.y_delta2,
                    elem.float5.y_delta3,
                    elem.float5.y_delta4
                };
                // To more closely match hardware behavior, use sub accumulator
                double cur_subaccum = 0.0;
                for(int i = 0; i < 5; i++) {
                    float term = elem.float5.weights[i] * cur_x_tile[x_indices[i]];
                    cur_subaccum += static_cast<double>(term);

                    if(dys[i] != 0) {
                        cur_y_tile[cur_y] += cur_accumulator + cur_subaccum;
                        cur_y += dys[i];
                        cur_accumulator = 0.0;
                        cur_subaccum = 0.0;
                    }
                }
                cur_accumulator += cur_subaccum;

                if(elem.float5.last_in_y) {
                    cur_x = 0;
                }
                if(elem.float5.last_in_x) {
                    for(size_t i = 0; i < TILE_X_WIDTH; i++) {
                        cur_x_tile[i] = 0.0;
                    }
                    for(size_t i = 0; i < TILE_X_WIDTH && cur_x < x_vec.size(); i++) {
                        cur_x_tile[i] = x_vec[cur_x++];
                    }
                    cur_y = 0;
                    assert(cur_accumulator == 0.0);
                }

                if(elem.float5.last_in_y) {
                    size_t section = cur_y_repeat * this->hbm_buffers.size() + compute_unit;
                    uint64_t y_from = this->y_froms[section];
                    uint64_t y_to = this->y_froms[section+1];
                    for(size_t y = y_from; y < y_to; y++) {
                        result[y] = static_cast<float>(cur_y_tile[y - y_from]);
                        std::cout << "Write to Y " << y << ": " << result[y] << std::endl;
                    }
                    for(size_t i = 0; i < MAX_TILE_Y_HEIGHT; i++) {
                        cur_y_tile[i] = 0.0;
                    }
                    cur_y_repeat++;
                }
            } else {
                // It's a float6
                uint64_t x_indices[6] = {
                    elem.float6.x_index_0,
                    elem.float6.x_index_1,
                    elem.float6.x_index_2,
                    elem.float6.x_index_3,
                    elem.float6.x_index_4,
                    elem.float6.x_index_5
                };
                
                bool lasts[6];
                uint8_t last_mask = LAST_MASKS[elem.float6.mode];
                for(int i = 0; i < 6; i++) {
                    lasts[i] = (last_mask & (1 << i)) != 0;
                }
                for(int i = 0; i < 6-1; i++) {
                    if(x_indices[i+1] <= x_indices[i]) {
                        lasts[i] |= true;
                    }
                }

                double cur_subaccum = 0.0;
                for(int i = 0; i < 6; i++) {
                    float term = elem.float6.weights[i] * cur_x_tile[x_indices[i]];

                    cur_subaccum += static_cast<double>(term);

                    if(lasts[i]) {
                        cur_y_tile[cur_y] = +cur_accumulator + cur_subaccum;
                        cur_y += 1;
                        cur_accumulator = 0.0;
                        cur_subaccum = 0.0;
                    }
                }
                cur_accumulator += cur_subaccum;
            }
        }
    }

    return result;
}

Matrix ComputeUnitData::convert(uint64_t cols, uint64_t rows) {
    Matrix m = Matrix{
    	width: cols,
        height: rows,
        entries: std::vector<Entry>()
    };

    for(size_t compute_unit = 0; compute_unit < this->hbm_buffers.size(); compute_unit++) {
        uint64_t cur_x = 0;
        uint64_t cur_y = 0;
        uint64_t y_section = compute_unit;
        for(MatrixDataBlock& elem : this->hbm_buffers[compute_unit]) {
            uint64_t y_from = this->y_froms[y_section];
            if(elem.float5.mode == 0b1111) {
                // It's a float5
                uint64_t x_indices[5] = {
                    elem.float5.x_index_0,
                    elem.float5.x_index_1,
                    elem.float5.x_index_2,
                    elem.float5.x_index_3,
                    elem.float5.x_index_4
                };
                uint64_t dys[5] = {
                    elem.float5.y_delta0,
                    elem.float5.y_delta1,
                    elem.float5.y_delta2,
                    elem.float5.y_delta3,
                    elem.float5.y_delta4
                };
                for(int i = 0; i < 5; i++) {
                	if (elem.float5.weights[i] != 0.0) {
	                    m.entries.push_back(Entry{ x:  cur_x + x_indices[i], y: cur_y + y_from, val: elem.float5.weights[i] });
                    }
                    cur_y += dys[i];
                }

                if(elem.float5.last_in_x) {
                    cur_x += TILE_X_WIDTH;
                    cur_y = 0;
                }
                if(elem.float5.last_in_y) {
                    cur_x = 0;
                    cur_y = 0;
       				y_section += this->hbm_buffers.size();
                }
            } else {
                // It's a float6
                uint64_t x_indices[6] = {
                    elem.float6.x_index_0,
                    elem.float6.x_index_1,
                    elem.float6.x_index_2,
                    elem.float6.x_index_3,
                    elem.float6.x_index_4,
                    elem.float6.x_index_5
                };
                bool lasts[6];
                uint8_t last_mask = LAST_MASKS[elem.float6.mode];
                for(int i = 0; i < 6; i++) {
                    lasts[i] = (last_mask & (1 << i)) != 0;
                }
                for(int i = 0; i < 6-1; i++) {
                    if(x_indices[i+1] <= x_indices[i]) {
                        lasts[i] |= true;
                    }
                }

                for(int i = 0; i < 6; i++) {
                	if (elem.float6.weights[i] != 0.0) {
	                    m.entries.push_back(Entry{ x:  cur_x + x_indices[i], y: cur_y + y_from, val: elem.float6.weights[i] });
                    }
                    if(lasts[i]) {
                        cur_y += 1;
                    }
                }
            }
        }
    }

    std::sort(m.entries.begin(), m.entries.end(), [](const Entry &a, const Entry &b) {
        if (a.y == b.y) {
            return a.x < b.x;
        } else {
            return a.y < b.y;
        }
    });

    return m;
}

bool has_bank_conflics(uint64_t *y, uint64_t new_idx) {
    for (uint64_t i = 0; i < new_idx; i++) {
        if (y[i] % NUM_Y_BANKS == y[new_idx] % NUM_Y_BANKS && y[i] != y[new_idx]) {
            // bank conflict
            return true;
        }
    }
    return false;
}

void append_tile_entries(std::vector<Entry>& entries, std::vector<MatrixDataBlock>& data, bool is_last_in_y) {
    uint64_t first_entry_idx = 0;
    uint64_t block_count = 0;
    uint64_t cur_y = 0;

    while (true) {
        block_count += 1;
        float    val[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        uint64_t x[6]   = {0, 0, 0, 0, 0, 0};
        uint64_t y[6]   = {0, 0, 0, 0, 0, 0};
        uint8_t  dy[6]  = {0, 0, 0, 0, 0, 0};
        uint64_t count  = 0;
        for (uint64_t i = 0; i < 6; i++) {
            uint64_t j = first_entry_idx + i;
            if(j >= entries.size()) {
                break;
            }

            uint64_t delta_y = 1;
            if (j+1 < entries.size()) {
                delta_y = entries[j+1].y - entries[j].y;
            }

            uint64_t entry_y = entries[j].y;
            if (entry_y != cur_y) {
                // insert zero
                x[i] = 0;
                y[i] = entries[j].y;
                dy[i] = delta_y;
                val[i] = 0.0;
            }

            if (delta_y > 255) {
                // insert zero
                for (uint64_t tries = 0; tries < 16; tries++) {
                    uint64_t next_y = entries[j].y + 255 - tries;
                    y[i] = next_y;
                    if (i == 5 || !has_bank_conflics(y, i)) {
                        break;
                    }
                }
                x[i] = 0;
                y[i] = entries[j].y;
                dy[i] = delta_y;
                val[i] = 0.0;
            } else {
                x[i] = entries[j].x;
                y[i] = entries[j].y;
                dy[i] = delta_y;
                val[i] = entries[j].val;
            }

            // check for bank conflicts
            if (has_bank_conflics(y, i)) {
                break;
            }
            count += 1;
        }
        
        // check if we can use a `Float6` block here
        bool use_float6 = true;
        // only use Float6 iff
        // - we actually have six values
        // - it is not the last block of the tile (must be Float5)
        if (count != 6) {
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
        bool required_last_mask[6] = {false, false, false, false, false, false};
        for (int i = 0; i < 6; i++) {
            if (dy[i] != 0) {
                required_last_mask[i] = true;
            }
        }
        // Remove implicit lasts before adding last mask
        for(int i = 0; i < 6 - 1; i++) {
            if(x[i+1] <= x[i]) {
                required_last_mask[i] = false;
            }
        }

        // check if the computed last_mask is available
        uint8_t required_last = 0b000000;
        for(int i = 0; i < 6; i++) {
            if(required_last_mask[i]) {
                required_last |= 1 << i;
            }
        }
        uint8_t mode = 0b1111;
        for (uint64_t i = 0; i < 15; i++) {
            if (LAST_MASKS[i] == required_last) {
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
            if(count > 5) {
                count = 5; // Float5 can only send 5 floats.
            }
            MatrixDataBlock block;
            bool last_in_x = first_entry_idx + count >= entries.size();
            bool last_in_y = last_in_x && is_last_in_y;
            block.float5 = Float5{
                weights: { val[0], val[1], val[2], val[3], val[4] },
                y_delta0 : dy[0],
                y_delta1 : dy[1],
                y_delta2 : dy[2],
                y_delta3 : dy[3],
                y_delta4 : dy[4],
                last_in_x : last_in_x ? 1u : 0u,
                last_in_y : last_in_y ? 1u : 0u,
                x_index_4: x[4],
                x_index_3: x[3],
                x_index_2: x[2],
                x_index_1: x[1],
                x_index_0: x[0],
                mode     : 0b1111,
            };
            data.push_back(block);
            std::cout << block << std::endl;
            if(last_in_x) {
                std::cout << "first_entry_idx: " << first_entry_idx << std::endl;
                std::cout << "count: " << count << std::endl;
                std::cout << "entries.size(): " << entries.size() << std::endl;
                assert(first_entry_idx + count == entries.size());
                // Check that on a last block, the output accumulator will be zero. 
                for(int i = 4; i >= 0; i--) {
                    if(dy[i] == 0) {
                        assert(val[i] == 0.0);
                    } else {
                        break;
                    }
                }
                break;
            }
            first_entry_idx += count;
        }
    }

    // in case the tile is very empty, we must add some filler blocks to prevent conflicts with the next tile.
    while ((block_count < MIN_BLOCKS_PER_TILE) && !is_last_in_y) {
        block_count += 1;

        MatrixDataBlock block;
        block.float5 = Float5{
            weights: { 0.0, 0.0, 0.0, 0.0, 0.0 },
            y_delta0 : 0,
            y_delta1 : 0,
            y_delta2 : 0,
            y_delta3 : 0,
            y_delta4 : 0,
            last_in_x : 0u, // Append blocks for an empty start to the next tile. 
            last_in_y : 0u,
            x_index_4: 0,
            x_index_3: 0,
            x_index_2: 0,
            x_index_1: 0,
            x_index_0: 0,
            mode     : 0b1111,
        };
        //std::cout << "MinBlockFillerBlock" << std::endl;
        data.push_back(block);
    }
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


	std::vector<Builder> builders(compute_units);
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
            bool last_in_y = tile_x == current_x_tile_split.size()-1;
            if (current_x_tile_split[tile_x].size() == 0) {
            	// completely empty tile
	            Entry entry = Entry{x: 0, y: 0, val: 0.0};
                builders[cur_hbm].add(entry, true, last_in_y);
            }
            for(size_t entry_idx = 0; entry_idx < current_x_tile_split[tile_x].size(); entry_idx++) {
                bool last_in_tile = entry_idx == current_x_tile_split[tile_x].size() - 1;
                builders[cur_hbm].add(current_x_tile_split[tile_x][entry_idx], last_in_tile, last_in_tile && last_in_y);
            }
        }
    }
    for(size_t i = 0; i < compute_units; i++) {
    	hbm_buffers[i] = builders[i].blocks;
	}

    return ComputeUnitData{
        hbm_buffers: hbm_buffers,
        x_tiles: tiles_per_row,
        y_repeats: num_y_repeats,
        width: width,
        height: height,
        y_froms: y_froms
    };
}

Builder::Builder() {
    first_entry_in_tile = true;
    y_pos = 0;
}

bool Builder::has_bank_conflict(uint64_t *y, uint64_t len, uint64_t new_y) {
    for (uint64_t i = 0; i < len; i++) {
        if (y[i] % NUM_Y_BANKS == new_y % NUM_Y_BANKS && y[i] != new_y) {
            // bank conflict
            return true;
        }
    }
    return false;
}

bool Builder::has_y_conflict(uint64_t y) {
    // A y-pos can only be reused after `MIN_BLOCKS_PER_TILE` blocks
    // => Check if `entry.y` was used recently in a different tile
    //    I.e. if there was at least one different y in between
    bool new_tile = false;
    for (int64_t i = conflict_entries.size()-1; i >= 0; i--) {
        if (conflict_entries[i].block_idx + MIN_BLOCKS_PER_TILE < blocks.size()) {
            // remove entries that are so far away they have no effect anymore
            conflict_entries.erase(conflict_entries.begin(), conflict_entries.begin() + i);
            break;
        }
        if (conflict_entries[i].y != y) {
            new_tile = true;
        }
        if (new_tile && conflict_entries[i].y == y) {
            return true;
        }
    }
    return false;
}

void Builder::add(Entry &entry, bool last_in_x, bool last_in_y) {
    assert(entry.x < TILE_X_WIDTH);
    assert(entry.y < MAX_TILE_Y_HEIGHT);

    if (first_entry_in_tile && entry.y != 0) {
        entries.push_back(BuilderEntry{ x: 0, y: 0, val: 0.0, last_in_x: false, last_in_y: false });
    }
    first_entry_in_tile = false;

    uint64_t delta_y = entry.y - y_pos;
	assert(entry.y >= y_pos);
    while (delta_y > 255) {
        entries.push_back(BuilderEntry{ x: 0, y: y_pos + 255, val: 0.0, last_in_x: false, last_in_y: false });
        delta_y -= 255;
        y_pos += 255;
    }

    while (has_y_conflict(entry.y)) {
        std::cout << "conflict" << std::endl;
        build_block();
    }
int i = 0;
    entries.push_back(BuilderEntry{ x: entry.x, y: entry.y, val: entry.val, last_in_x: last_in_x, last_in_y: last_in_y });
    while (((last_in_x || last_in_y) && entries.size() != 0) || entries.size() == 7) {
    	std::cout << "build" << i << "  " <<  entries.size() << "  " << last_in_x << last_in_y<< std::endl;
        build_block();
        i++;
    }

    if (last_in_x || last_in_y) {
        std::cout << entries.size() << std::endl;
        first_entry_in_tile = true;
        y_pos = 0;
    } else {
    	y_pos = entry.y;
    }
}

void Builder::build_block() {
    float    val[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    uint64_t x[6]   = {0, 0, 0, 0, 0, 0};
    uint64_t y[6]   = {0, 0, 0, 0, 0, 0};
    uint8_t  dy[6]  = {0, 0, 0, 0, 0, 0};
    uint64_t count = 0;
    bool is_last = false;
    for (uint64_t i = 0; i < 6; i++) {
        if (i >= entries.size()) {
            break;
        }

        uint64_t delta_y = 1;
        if (i+1 < entries.size() && !entries[i].last_in_x) {
            delta_y = entries[i+1].y - entries[i].y;
        }

        assert(delta_y <= 255);

        if (has_bank_conflict(y, i, entries[i].y)) {
            break;
        }

        x[i] = entries[i].x;
        y[i] = entries[i].y;
        dy[i] = delta_y;
        val[i] = entries[i].val;

        count += 1;
        if (entries[i].last_in_x) {
	        is_last = true;
            break;
        }
    }
    
    // check if we can use a `Float6` block here
    bool use_float6 = true;
    // only use Float6 iff
    // - we actually have six values
    // - it is not the last block of the tile (must be Float5)
    if (count != 6 || is_last) {
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
    bool required_last_mask[6] = {false, false, false, false, false, false};
    for (int i = 0; i < 6; i++) {
        if (dy[i] != 0) {
            required_last_mask[i] = true;
        }
    }
    // Remove implicit lasts before adding last mask
    for(int i = 0; i < 6 - 1; i++) {
        if(x[i+1] <= x[i]) {
            required_last_mask[i] = false;
        }
    }

    // check if the computed last_mask is available
    uint8_t required_last = 0b000000;
    for(int i = 0; i < 6; i++) {
        if(required_last_mask[i]) {
            required_last |= 1 << i;
        }
    }
    uint8_t mode = 0b1111;
    for (uint64_t i = 0; i < 15; i++) {
        if (LAST_MASKS[i] == required_last) {
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
        blocks.push_back(block);
        for (uint64_t i = 0; i < 6; i++) {
        	conflict_entries.push_back(BuilderEntry{ x: entries[i].x, y: entries[i].y, val: entries[i].val, last_in_x: entries[i].last_in_x, last_in_y: entries[i].last_in_y, block_idx: blocks.size() });
        }
        entries.erase(entries.begin(), entries.begin() + 6);
        std::cout << block << std::endl;
    } else {
        if(count > 5) {
            count = 5; // Float5 can only send 5 floats.
        }
        MatrixDataBlock block;
        bool last_in_x = count == 0 ? false : entries[count-1].last_in_x;
        bool last_in_y = count == 0 ? false : entries[count-1].last_in_y;
        block.float5 = Float5{
            weights: { val[0], val[1], val[2], val[3], val[4] },
            y_delta0 : dy[0],
            y_delta1 : dy[1],
            y_delta2 : dy[2],
            y_delta3 : dy[3],
            y_delta4 : dy[4],
            last_in_x : last_in_x ? 1u : 0u,
            last_in_y : last_in_y ? 1u : 0u,
            x_index_4: x[4],
            x_index_3: x[3],
            x_index_2: x[2],
            x_index_1: x[1],
            x_index_0: x[0],
            mode     : 0b1111,
        };
        blocks.push_back(block);
        for (uint64_t i = 0; i < count; i++) {
        	conflict_entries.push_back(BuilderEntry{ x: entries[i].x, y: entries[i].y, val: entries[i].val, last_in_x: entries[i].last_in_x, last_in_y: entries[i].last_in_y, block_idx: blocks.size() });
        }
        entries.erase(entries.begin(), entries.begin() + count);
        std::cout << block << std::endl;
        /*if(last_in_x) {
            std::cout << "first_entry_idx: " << first_entry_idx << std::endl;
            std::cout << "count: " << count << std::endl;
            std::cout << "entries.size(): " << entries.size() << std::endl;
            assert(first_entry_idx + count == entries.size());
            // Check that on a last block, the output accumulator will be zero. 
            for(int i = 4; i >= 0; i--) {
                if(dy[i] == 0) {
                    assert(val[i] == 0.0);
                } else {
                    break;
                }
            }
            break;
        }*/
    }
}
