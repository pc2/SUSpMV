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
#include <random>

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

    if (field != "real" && field != "integer" && field != "pattern") {
        // other options are:
        // - complex (not supported by hardware)
        throw std::runtime_error("Only real, integer, or pattern matrices supported");
    }
    bool pattern = field == "pattern";

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
    m.entries.reserve(nnz);

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

		if (pattern) {
	        entry_stream >> row >> col;
	        value = 1.0;
		} else {
			entry_stream >> row >> col >> value;
		}

        if (!entry_stream) {
            throw std::runtime_error(
                "Invalid entry line: " + line
            );
        }

        // Matrix Market uses 1-based indexing
        col -= 1;
        row -= 1;

        if (value == 0.0 || col >= m.width || row >= m.height) {
            continue;
        }

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

    std::cout << "Matrix(w: " << m.width << ", h: " << m.height << ", nz: " << m.entries.size() << ")" << std::endl;
    return m;
}

void Matrix::shuffle_random() {
    std::vector<uint64_t> shuffle_row(height, 0);
    std::vector<uint64_t> shuffle_col(width, 0);
    std::vector<uint64_t> indices_row(height, 0);
    std::vector<uint64_t> indices_col(width, 0);
    for (uint64_t i = 0; i < width; i++) {
        indices_col[i] = i;
    }
    for (uint64_t i = 0; i < height; i++) {
        indices_row[i] = i;
    }

    std::random_device rd;  // Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); // Standard mersenne_twister_engine seeded with rd()
    std::uniform_real_distribution<double> dis(0, height + width);

    for (uint64_t i = 0; i < width; i++) {
        uint64_t idx = ((uint64_t)dis(gen)) % indices_col.size();
        shuffle_col[i] = indices_col[idx];
        if (!indices_col.empty()) {
            indices_col[idx] = indices_col[indices_col.size()-1];
            indices_col.pop_back();
        }
    }
    assert(indices_col.empty());

    for (uint64_t i = 0; i < height; i++) {
        uint64_t idx = ((uint64_t)dis(gen)) % indices_row.size();
        shuffle_row[i] = indices_row[idx];
        if (!indices_row.empty()) {
            indices_row[idx] = indices_row[indices_row.size()-1];
            indices_row.pop_back();
        }
    }
    assert(indices_row.empty());

    for (auto &entry : entries) {
        entry.x = shuffle_col[entry.x];
        entry.y = shuffle_row[entry.y];
    }

    std::sort(entries.begin(), entries.end(), [](const Entry &a, const Entry &b) {
        if (a.y == b.y) {
            return a.x < b.x;
        } else {
            return a.y < b.y;
        }
    });
}

void Matrix::shuffle() {
    Shuffler s;
    s.init(this);
    s.shuffle();
    std::sort(entries.begin(), entries.end(), [](const Entry &a, const Entry &b) {
        if (a.y == b.y) {
            return a.x < b.x;
        } else {
            return a.y < b.y;
        }
    });
}

void Shuffler::init(Matrix *mat) {
	m = mat;
    uint64_t target_seg_width = 4096;
    uint64_t target_seg_height = std::min((m->height + COMPUTE_UNITS-1) / COMPUTE_UNITS, (uint64_t) 32768);
    hm_width = (m->width + target_seg_width-1) / target_seg_width;
    hm_height = (m->height + target_seg_height-1) / target_seg_height;
    seg_width = m->width / (float) hm_width;
    seg_height = m->height / (float) hm_height;

    m->y_froms.clear();
	for (uint64_t i = 0; i < hm_height; i++) {
        m->y_froms.push_back(i * seg_height);
	}
    m->y_froms.push_back(m->height);

	shuffle_col  = std::vector<uint64_t>(m->width, (uint64_t) 0);
	ishuffle_col = std::vector<uint64_t>(m->width, (uint64_t) 0);
	shuffle_row  = std::vector<uint64_t>(m->height, (uint64_t) 0);
	ishuffle_row = std::vector<uint64_t>(m->height, (uint64_t) 0);
	for (uint64_t i = 0; i < m->width; i++) {
		shuffle_col[i] = i;
		ishuffle_col[i] = i;
	}
	for (uint64_t i = 0; i < m->height; i++) {
		shuffle_row[i] = i;
		ishuffle_row[i] = i;
	}
	
	col_idx = std::vector<std::vector<uint64_t>>(m->width);
	row_idx = std::vector<std::vector<uint64_t>>(m->height);

	heatmap = std::vector<int64_t>(hm_width*hm_height, (int64_t) 0);
    for (uint64_t i = 0; i < m->entries.size(); i++) {
	    auto &entry = m->entries[i];
        uint64_t sx = entry.x / seg_width;
        uint64_t sy = entry.y / seg_height;
        uint64_t idx = sy * hm_width + sx;
        heatmap[idx] += 1;
        
        row_idx[entry.y].push_back(i);
        col_idx[entry.x].push_back(i);
    }
}

void Shuffler::shuffle() {
    std::random_device rd;  // Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); // Standard mersenne_twister_engine seeded with rd()
    std::uniform_real_distribution<double> dis(0, m->width * m->height);

	// shuffle
    uint64_t failures = 0;
    for (uint64_t i = 0; i < 1000000 && failures < 1000; i++) {
        if (i % 2 == 0 || hm_width <= 1) {
            // swap row
            uint64_t a = ((uint64_t)dis(gen)) % m->height;
            uint64_t b = ((uint64_t)dis(gen)) % m->height;
            while (b / seg_height == a / seg_height) {
                b = ((uint64_t)dis(gen)) % m->height;
            }
            std::vector<int64_t> delta(std::max(m->width, m->height), 0);
            int64_t dcost = test_swap_rows(a, b, delta);
            if (dcost < 0) {
                swap_rows(a, b, delta);
                failures = 0;
            } else {
                failures++;
            }
        } else if (hm_width > 1) {
            // swap col
            uint64_t a = ((uint64_t)dis(gen)) % m->width;
            uint64_t b = ((uint64_t)dis(gen)) % m->width;
            while ((uint64_t) (b / seg_width) == (uint64_t) (a / seg_width)) {
                b = ((uint64_t)dis(gen)) % m->width;
            }
            std::vector<int64_t> delta(std::max(m->width, m->height), 0);
            int64_t dcost = test_swap_cols(a, b, delta);
            if (dcost < 0) {
                swap_cols(a, b, delta);
                failures = 0;
            } else {
                failures++;
            }
        }
    }

    // find inverse shuffle and verify shuffle integrity
	std::vector<uint64_t> ishuffle_col(m->width, (uint64_t) m->width);
	std::vector<uint64_t> ishuffle_row(m->height, (uint64_t) m->height);
	for (uint64_t i = 0; i < m->width; i++) {
		uint64_t idx = shuffle_col[i];
		assert(ishuffle_col[idx] == m->width); // verify shuffle integrity (no entry assigned twice)
		ishuffle_col[idx] = i;
	}
	for (uint64_t i = 0; i < m->height; i++) {
		uint64_t idx = shuffle_row[i];
		assert(ishuffle_row[idx] == m->height); // verify shuffle integrity (no entry assigned twice)
		ishuffle_row[idx] = i;
	}
	for (uint64_t i = 0; i < m->width; i++) {
		assert(ishuffle_col[i] < m->width); // verify shuffle integrity (no entry unassigned)
		assert(ishuffle_col[i] == this->ishuffle_col[i]); // verify ishuffle integrity
	}
	for (uint64_t i = 0; i < m->height; i++) {
		assert(ishuffle_row[i] < m->height); // verify shuffle integrity (no entry unassigned)
		assert(ishuffle_row[i] == this->ishuffle_row[i]); // verify ishuffle integrity
	}

    // apply shuffle
    for (auto &entry : m->entries) {
        entry.x = ishuffle_col[entry.x];
        entry.y = ishuffle_row[entry.y];
    }
    
    // verify heatmap integrity
    std::vector<int64_t> heatmap2(hm_width*hm_height, (int64_t) 0);
    for (auto &entry : m->entries) {
        uint64_t sx = entry.x / seg_width;
        uint64_t sy = entry.y / seg_height;
        uint64_t idx = sy * hm_width + sx;
        heatmap2[idx] += 1;
    }
    for (uint64_t i = 0; i < heatmap2.size(); i++) {
	    std::cout << heatmap[i] << " ";
    }
    std::cout << std::endl;
    for (uint64_t i = 0; i < heatmap2.size(); i++) {
	    assert(heatmap[i] == heatmap2[i]);
    }
}

int64_t Shuffler::test_swap_rows(uint64_t a, uint64_t b, std::vector<int64_t> &delta) {
	uint64_t ra = shuffle_row[a];
	uint64_t rb = shuffle_row[b];
	for (uint64_t i = 0; i < row_idx[ra].size(); i++) {
		uint64_t idx = row_idx[ra][i];
		Entry &entry = m->entries[idx];
		delta[(uint64_t) (ishuffle_col[entry.x] / seg_width)] += 1;
	}
	for (uint64_t i = 0; i < row_idx[rb].size(); i++) {
		uint64_t idx = row_idx[rb][i];
		Entry &entry = m->entries[idx];
		delta[(uint64_t) (ishuffle_col[entry.x] / seg_width)] -= 1;
	}

    int64_t cost_before = 0;
    int64_t cost_after = 0;
    for (uint64_t x = 0; x < hm_width; x++) {
        uint64_t idx_a = (uint64_t) (a/seg_height) * hm_width + x;
        uint64_t idx_b = (uint64_t) (b/seg_height) * hm_width + x;
        cost_before += std::abs(heatmap[idx_a] - heatmap[idx_b]);
        cost_after  += std::abs((heatmap[idx_a] - delta[x]) - (heatmap[idx_b] + delta[x]));
    }
    return cost_after - cost_before;
}

int64_t Shuffler::test_swap_cols(uint64_t a, uint64_t b, std::vector<int64_t> &delta) {
	uint64_t ca = shuffle_col[a];
	uint64_t cb = shuffle_col[b];
	for (uint64_t i = 0; i < col_idx[ca].size(); i++) {
		uint64_t idx = col_idx[ca][i];
		Entry &entry = m->entries[idx];
		delta[(uint64_t) (ishuffle_row[entry.y] / seg_height)] += 1;
	}
	for (uint64_t i = 0; i < col_idx[cb].size(); i++) {
		uint64_t idx = col_idx[cb][i];
		Entry &entry = m->entries[idx];
		delta[(uint64_t) (ishuffle_row[entry.y] / seg_height)] -= 1;
	}

    int64_t cost_before = 0;
    int64_t cost_after = 0;
    for (uint64_t y = 0; y < hm_height; y++) {
        uint64_t idx_a = y * hm_width + (uint64_t) (a/seg_width);
        uint64_t idx_b = y * hm_width + (uint64_t) (b/seg_width);
        // note: currently col-cost is handled the same as row-cost, but:
        // - we really don't care whether different cols are equally utilized
        // - we need all the tiles a col is part of to be equally utilized
        // but for now this achieves more or less the same goal
        cost_before += std::abs(heatmap[idx_a] - heatmap[idx_b]);
        cost_after  += std::abs((heatmap[idx_a] - delta[y]) - (heatmap[idx_b] + delta[y]));
    }
    return cost_after - cost_before;
}

void Shuffler::swap_rows(uint64_t a, uint64_t b, std::vector<int64_t> &delta) {
	uint64_t tmp = shuffle_row[a];
	shuffle_row[a] = shuffle_row[b];
	shuffle_row[b] = tmp;
    ishuffle_row[shuffle_row[a]] = a;
    ishuffle_row[shuffle_row[b]] = b;

    for (uint64_t x = 0; x < hm_width; x++) {
        uint64_t idx_a = (uint64_t) (a/seg_height) * hm_width + x;
        uint64_t idx_b = (uint64_t) (b/seg_height) * hm_width + x;
        heatmap[idx_a] -= delta[x];
        heatmap[idx_b] += delta[x];
    }
}

void Shuffler::swap_cols(uint64_t a, uint64_t b, std::vector<int64_t> &delta) {
	uint64_t tmp = shuffle_col[a];
	shuffle_col[a] = shuffle_col[b];
	shuffle_col[b] = tmp;
    ishuffle_col[shuffle_col[a]] = a;
    ishuffle_col[shuffle_col[b]] = b;

    for (uint64_t y = 0; y < hm_height; y++) {
        uint64_t idx_a = y * hm_width + (uint64_t) (a/seg_width);
        uint64_t idx_b = y * hm_width + (uint64_t) (b/seg_width);
        heatmap[idx_a] -= delta[y];
        heatmap[idx_b] += delta[y];
    }
}

bool Matrix::compare(Matrix &m) {
	bool equal = true;
	if (entries.size() != m.entries.size()) {
		std::cout << entries.size() << "  " << m.entries.size() << std::endl;
		equal = false;
	}
    uint64_t errors = 0;
	for (uint64_t i = 0; i < entries.size() && i < m.entries.size(); i++) {
		if (entries[i].x != m.entries[i].x || entries[i].y != m.entries[i].y || entries[i].val != m.entries[i].val) {
            if (errors < 100) {
                std::cout << entries[i] << "  " << m.entries[i] << std::endl;
            }
			equal = false;
            errors++;
		}
	}
	if (!equal) {	
        std::cout << "matrices differ (errors: " << errors << "/" << entries.size() << ")!" << std::endl;
	}
	return equal;
}

std::vector<float> Matrix::mul(std::vector<float>& v) {
    assert(v.size() == width);
    std::vector<double> r(height, 0.0);

    for (Entry &entry : this->entries) {
        r[entry.y] += entry.val * v[entry.x];
    }

    std::vector<float> result(height);
    for(size_t i = 0; i < height; i++) {
        result[i] = static_cast<float>(r[i]);
    }
    return result;
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
        //std::cout << "Compute Unit " << compute_unit << std::endl;
        for(MatrixDataBlock& elem : this->hbm_buffers[compute_unit]) {
            //std::cout << elem << std::endl;
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
                        //std::cout << "Write to Y " << y << ": " << result[y] << std::endl;
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
                        cur_y_tile[cur_y] += cur_accumulator + cur_subaccum;
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

Matrix ComputeUnitData::convert() {
    Matrix m = Matrix{
    	width: this->width,
        height: this->height,
        entries: std::vector<Entry>()
    };

    for(size_t compute_unit = 0; compute_unit < this->hbm_buffers.size(); compute_unit++) {
        uint64_t cur_x = 0;
        uint64_t cur_y = 0;
        uint64_t y_section = compute_unit;
        uint64_t y_max = 0;
        for(MatrixDataBlock& elem : this->hbm_buffers[compute_unit]) {
            uint64_t y_start = this->y_froms[y_section];
            uint64_t y_end = this->y_froms[y_section+1];
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
	                    m.entries.push_back(Entry{ x:  cur_x + x_indices[i], y: cur_y + y_start, val: elem.float5.weights[i] });
                    }
                    if (dys[i]) {
                        y_max = std::max(y_max, cur_y);
                        cur_y += dys[i];
                    }
                }

                if(elem.float5.last_in_x) {
                    cur_x += TILE_X_WIDTH;
                    cur_y = 0;
                }
                if(elem.float5.last_in_y) {
                    assert(y_max == y_end - y_start - 1);
                    y_max = 0;
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
	                    m.entries.push_back(Entry{ x:  cur_x + x_indices[i], y: cur_y + y_start, val: elem.float6.weights[i] });
                    }
                    if(lasts[i]) {
                        y_max = std::max(y_max, cur_y);
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

ComputeUnitData Matrix::get_compute_unit_data() {
    uint64_t tiles_per_row = (width + TILE_X_WIDTH - 1) / TILE_X_WIDTH;
	std::cout << "Compute Y Count Prefix Sum" << std::endl;
	// compute prefix sum for entry count per row
	std::vector<uint64_t> y_sum_count(height+1, 0);
	y_sum_count[0] = 0;
	for (uint64_t y = 0, e = 0; y < height; y++) {
		while (e < entries.size() && y >= entries[e].y) {
			e++;
		}
		y_sum_count[y+1] = e;
	}

	std::cout << "Determining Y splits" << std::endl;
    std::vector<size_t> y_split_points;
    std::vector<uint64_t> y_froms;
    double equality_threshold_min = 0.99;
    double equality_threshold_max = 1.01;
    uint64_t equality_threshold_diff = 20;
    uint64_t repeats = 0;
    uint64_t base_y = 0;
    uint64_t initial_height_min = 1;
    uint64_t initial_height_max = std::min(MAX_TILE_Y_HEIGHT, height-(COMPUTE_UNITS-1));
    y_froms.insert(y_froms.end(), COMPUTE_UNITS+1, 0);
    while (base_y < height) {
        uint64_t initial_height = (initial_height_max + initial_height_min + 1) / 2;
        //std::cout << "reapeat = " << repeats+1 << "  " << initial_height << std::endl;
        uint64_t y_end = std::min(base_y + initial_height, height - (COMPUTE_UNITS-1));
        uint64_t base_cost = y_sum_count[y_end] - y_sum_count[base_y] + tiles_per_row;
        bool retry_with_smaller_initial_height = false;
        //std::cout << " c[0].y = " << base_y << "  " << y_end << "  " << base_cost << std::endl;
        y_froms[repeats*COMPUTE_UNITS+1] = y_end;

        for (uint64_t c = 1; c < COMPUTE_UNITS; c++) {
            uint64_t y_start = y_end;
            y_end = std::min(y_start + MAX_TILE_Y_HEIGHT, height - (COMPUTE_UNITS-1-c));
            uint64_t max_cost = y_sum_count[y_end] - y_sum_count[y_start] + tiles_per_row;
            if (max_cost < base_cost * equality_threshold_min && max_cost < base_cost - equality_threshold_diff && initial_height > 1) {
                // too few entries in this tile causes imbalance
                // => reduce overall tile size
                retry_with_smaller_initial_height = true;
                //std::cout << " c["<<c<<"].y = " << y_start << "  " << y_end << "  " << max_cost << std::endl;
                break;
            }
            while (max_cost > base_cost * equality_threshold_max && max_cost > base_cost + equality_threshold_diff && y_end > y_start+1) {
                // too many entries in this tile causes imbalance
                // => reduce this tiles size
                y_end -= 1;
                max_cost = y_sum_count[y_end] - y_sum_count[y_start] + tiles_per_row;
            }
            if (c == COMPUTE_UNITS-1 && y_end >= height-COMPUTE_UNITS) {
                // edge case
                // => the last compute unit in this repeat did just barely not fill up the entire height
                if (y_start + MAX_TILE_Y_HEIGHT >= height) {
                    // fill up the rest
                    y_end = height;
                } else {
                    // leave big enough gap to squeeze in another repeat
                    y_end = height - COMPUTE_UNITS;
                }
                max_cost = y_sum_count[y_end] - y_sum_count[y_start] + tiles_per_row;
            }
            y_froms[repeats*COMPUTE_UNITS+c+1] = y_end;
            //std::cout << " c["<<c<<"].y = " << y_start << "  " << y_end << "  " << max_cost << std::endl;
        }
        if (retry_with_smaller_initial_height) {
            initial_height_max = initial_height-1;
        } else if (initial_height_max != initial_height_min) {
            initial_height_min = initial_height;
        } else {
            base_y = y_end;
            initial_height_max = std::min(MAX_TILE_Y_HEIGHT, (height-base_y)-(COMPUTE_UNITS-1));
            initial_height_min = 1;
            repeats++;
            y_froms.insert(y_froms.end(), COMPUTE_UNITS, 0);
        }
    }

    size_t total_y_partitions = COMPUTE_UNITS*repeats;

    if (!this->y_froms.empty()) {
        // the shuffler already gave us some y_froms
        y_froms = this->y_froms;
        total_y_partitions = this->y_froms.size() - 1;
        repeats = total_y_partitions / COMPUTE_UNITS;
    }
    for (uint64_t i = 0; i < y_froms.size(); i++) {
        y_split_points.push_back(y_sum_count[y_froms[i]]);
    }

    // Temporary memory to split a single rows block into its constituent tiles.
    std::vector<std::vector<Entry>> current_x_tile_split(tiles_per_row);
    // The final memory buffers, these should be uploaded to the FPGA.
    std::vector<std::vector<MatrixDataBlock>> hbm_buffers(COMPUTE_UNITS);
	std::vector<Builder> builders(COMPUTE_UNITS);
    for(size_t i = 0; i < total_y_partitions; i++) {
        size_t cur_hbm = i % COMPUTE_UNITS;
        builders[cur_hbm].unit = cur_hbm;

        size_t from = y_split_points[i];
        size_t to = y_split_points[i+1];

        std::cout << std::format("Placing Y {}(+{}) (entries {}..{}) in compute unit {}", y_froms[i], y_froms[i+1]-y_froms[i], from, to, cur_hbm);
        uint64_t blocks_before = builders[cur_hbm].blocks.size();

        assert(from <= to);
        assert(to <= this->entries.size());
        std::span<Entry> entries_here = std::span(this->entries).subspan(from, to - from);

        uint64_t y_max = y_froms[i+1]-1;
        uint64_t y_max_entry_idx = y_sum_count[y_max];
        builders[cur_hbm].y_max = y_max - y_froms[i];
        if (y_max_entry_idx >= entries.size()) {
            builders[cur_hbm].y_max_tile_idx = 0;
        } else if (entries[y_max_entry_idx].y == y_max) {
            builders[cur_hbm].y_max_tile_idx = tiles_per_row + 1;
        } else {
            builders[cur_hbm].y_max_tile_idx = entries[y_max_entry_idx].x / TILE_X_WIDTH;
        }

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

        uint64_t blocks_after = builders[cur_hbm].blocks.size();
        std::cout << std::format(" (in {} blocks)", blocks_after - blocks_before) << std::endl;
    }
    for(size_t i = 0; i < COMPUTE_UNITS; i++) {
    	hbm_buffers[i] = builders[i].blocks;
	}

    return ComputeUnitData{
        hbm_buffers: hbm_buffers,
        x_tiles: tiles_per_row,
        y_repeats: repeats,
        width: width,
        height: height,
        y_froms: y_froms
    };
}

Builder::Builder() {
    first_entry_in_tile = true;
    x_tile = 0;
    y_pos = 0;
    y_max = 0;
    y_max_tile_idx = 0;
    y_max_added = false;
    accumulator_zero = true;
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

void Builder::add(Entry entry, bool last_in_x, bool last_in_y) {
    assert(entry.x < TILE_X_WIDTH);
    assert(entry.y < MAX_TILE_Y_HEIGHT);

	// if the first entry is not in row 0, we must add a dummy-entry to increment the row
    if (first_entry_in_tile && entry.y != 0) {
    	add(Entry{ x: 0, y: 0, val: 0.0}, false, false);
    }
    first_entry_in_tile = false;

	uint64_t delta_y = entry.y - y_pos;
	assert(entry.y >= y_pos);
    while (delta_y > 255) {
    	// insert dummy entries to bridge the gap
    	// => call `Builder::add` recursively in case this causes other conflicts
    	add(Entry{ x: 0, y: y_pos + 255, val: 0.0}, false, false);
    	delta_y = entry.y - y_pos;
    }

	// the accelerator deduces the y-increment at a last_in_y by tracking the largest y value
	// => y_max must appear at least once in a y-section
	if (!y_max_added && y_max_tile_idx == x_tile && last_in_x) {
		//std::cout << y_max << "   " << y_max_seen << std::endl;
		// we must add an additional entry at the very end to inform the accelerator about the y-span of the y-section
        // => we chose this specific x-tile, because requires the fewest dummy entries to bridge the gap

		// push back the actual new entry
		entries.push_back(BuilderEntry{ x: entry.x, y: entry.y, val: entry.val, last_in_x: false, last_in_y: false });
    	y_pos = entry.y;
        y_max_added = true;
		// add the dummy entry at y_max
		add(Entry{ x: 0, y: y_max, val: 0.0}, true, last_in_y);
	} else {
		// push back the actual new entry
		entries.push_back(BuilderEntry{ x: entry.x, y: entry.y, val: entry.val, last_in_x: last_in_x , last_in_y: last_in_y });
	}

    while (((last_in_x || last_in_y) && entries.size() != 0) || entries.size() == 7) {
    	// we have enough entries buffered to build a new block
        build_block();
    }

    if (last_in_x || last_in_y) {
        first_entry_in_tile = true;
        y_pos = 0;
        y_max_added = false;
        x_tile = last_in_y ? 0 : x_tile + 1;
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

        uint64_t delta_y = 0;
        if (i+1 < entries.size() && !entries[i].last_in_x) {
            delta_y = entries[i+1].y - entries[i].y;
        } else if (entries[i].last_in_x) {
	        delta_y = 0;
        }

        assert(delta_y <= 255);

        if (has_bank_conflict(y, i, entries[i].y)) {
            break;
        }
        if (has_y_conflict(entries[i].y)) {
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

    // reduce count
    if (count == 6 && !use_float6) {
        count = 5; // Float5 can only send 5 floats.
    }

    // track accumulator
    for (uint64_t i = 0; i < count; i++) {
        if (dy[i] != 0) {
            accumulator_zero = true;
        } else if (val[i] != 0.0) {
            accumulator_zero = false;
        }
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
        //std::cout << block << std::endl;
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
            y_delta4 : last_in_x && (!accumulator_zero || y_max_tile_idx == x_tile) ? 1u : dy[4], // flush the accumulator on last x
            last_in_x : last_in_x ? 1u : 0u,
            last_in_y : last_in_y ? 1u : 0u,
            x_index_4: x[4],
            x_index_3: x[3],
            x_index_2: x[2],
            x_index_1: x[1],
            x_index_0: x[0],
            mode     : 0b1111,
        };
        if (block.float5.y_delta4 != 0) {
            accumulator_zero = true;
        }
        blocks.push_back(block);
        for (uint64_t i = 0; i < count; i++) {
        	conflict_entries.push_back(BuilderEntry{ x: entries[i].x, y: entries[i].y, val: entries[i].val, last_in_x: entries[i].last_in_x, last_in_y: entries[i].last_in_y, block_idx: blocks.size() });
        }
        entries.erase(entries.begin(), entries.begin() + count);
        //std::cout << block << std::endl;
    }
}
