# ========= #
# Full SLRs #
# ========= #

create_pblock pblock_suspmv_slr0
# resize_pblock [get_pblocks pblock_suspmv_slr0] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y3}
resize_pblock [get_pblocks pblock_suspmv_slr0] -add {SLR0}
set_property IS_SOFT FALSE [get_pblocks pblock_suspmv_slr0]

create_pblock pblock_suspmv_slr1
# resize_pblock [get_pblocks pblock_suspmv_slr1] -add {CLOCKREGION_X0Y4:CLOCKREGION_X7Y7}
resize_pblock [get_pblocks pblock_suspmv_slr1] -add {SLR1}
set_property IS_SOFT FALSE [get_pblocks pblock_suspmv_slr1]

create_pblock pblock_suspmv_slr2
# resize_pblock [get_pblocks pblock_suspmv_slr2] -add {CLOCKREGION_X0Y8:CLOCKREGION_X7Y11}
resize_pblock [get_pblocks pblock_suspmv_slr2] -add {SLR2}
set_property IS_SOFT FALSE [get_pblocks pblock_suspmv_slr2]

add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet [list \
    suspmv_slr0/x_value_cross \
    suspmv_slr0/may_y_valid_cross \
    suspmv_slr0/y_value_cross \
    suspmv_slr0/rst_pipeline \
]]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet [list \
    suspmv_slr1/x_value_cross \
    suspmv_slr1/may_y_valid_cross \
    suspmv_slr1/y_value_cross \
    suspmv_slr1/rst_pipeline \
]]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells -quiet [list \
    suspmv_slr2/x_value_cross \
    suspmv_slr2/may_y_valid_cross \
    suspmv_slr2/y_value_cross \
    suspmv_slr2/rst_pipeline \
]]

# ========= #
# Half SLRs #
# ========= #

create_pblock slr0_left
set_property PARENT pblock_suspmv_slr0 [get_pblocks slr0_left]
resize_pblock [get_pblocks slr0_left] -add {CLOCKREGION_X0Y0:CLOCKREGION_X3Y3}
set_property IS_SOFT FALSE [get_pblocks slr0_left]
add_cells_to_pblock [get_pblocks slr0_left] [get_cells suspmv_slr0/left_half]

create_pblock slr0_right
set_property PARENT pblock_suspmv_slr0 [get_pblocks slr0_right]
resize_pblock [get_pblocks slr0_right] -add {CLOCKREGION_X4Y0:CLOCKREGION_X7Y3}
set_property IS_SOFT FALSE [get_pblocks slr0_right]
# add_cells_to_pblock [get_pblocks slr0_right] [get_cells suspmv_slr0/right_half]

create_pblock slr1_left
set_property PARENT pblock_suspmv_slr1 [get_pblocks slr1_left]
resize_pblock [get_pblocks slr1_left] -add {CLOCKREGION_X0Y4:CLOCKREGION_X3Y7}
set_property IS_SOFT FALSE [get_pblocks slr1_left]
add_cells_to_pblock [get_pblocks slr1_left] [get_cells suspmv_slr1/left_half]

create_pblock slr1_right
set_property PARENT pblock_suspmv_slr1 [get_pblocks slr1_right]
resize_pblock [get_pblocks slr1_right] -add {CLOCKREGION_X4Y4:CLOCKREGION_X7Y7}
set_property IS_SOFT FALSE [get_pblocks slr1_right]
add_cells_to_pblock [get_pblocks slr1_right] [get_cells suspmv_slr1/right_half]

create_pblock slr2_left
set_property PARENT pblock_suspmv_slr2 [get_pblocks slr2_left]
resize_pblock [get_pblocks slr2_left] -add {CLOCKREGION_X0Y8:CLOCKREGION_X3Y11}
set_property IS_SOFT FALSE [get_pblocks slr2_left]
add_cells_to_pblock [get_pblocks slr2_left] [get_cells suspmv_slr2/left_half]

create_pblock slr2_right
set_property PARENT pblock_suspmv_slr2 [get_pblocks slr2_right]
resize_pblock [get_pblocks slr2_right] -add {CLOCKREGION_X4Y8:CLOCKREGION_X7Y11}
set_property IS_SOFT FALSE [get_pblocks slr2_right]
add_cells_to_pblock [get_pblocks slr2_right] [get_cells suspmv_slr2/right_half]

# ================= #
# Ctrl & X/Y Vector #
# ================= #

# Special pblock to keep the x/y reader/writer together
create_pblock x_y_pblock
set_property PARENT slr0_left [get_pblocks x_y_pblock]
resize_pblock [get_pblocks x_y_pblock] -add {CLOCKREGION_X3Y2:CLOCKREGION_X3Y3}
set_property IS_SOFT TRUE [get_pblocks x_y_pblock]
add_cells_to_pblock [get_pblocks x_y_pblock] [get_cells x_vector_reader]
add_cells_to_pblock [get_pblocks x_y_pblock] [get_cells y_result_writer]

create_pblock ctrl_pblock
set_property PARENT slr0_left [get_pblocks ctrl_pblock]
resize_pblock [get_pblocks ctrl_pblock] -add {CLOCKREGION_X3Y1:CLOCKREGION_X3Y1}
set_property IS_SOFT TRUE [get_pblocks ctrl_pblock]
add_cells_to_pblock [get_pblocks ctrl_pblock] [get_cells ctrl]

# ================= #
# Bottom right unit #
# ================= #

# As opposed to the others, we create this pblock much smaller, since it only has to contain one unit
create_pblock slr0_right_single_unit
set_property PARENT slr0_right [get_pblocks slr0_right_single_unit]
resize_pblock [get_pblocks slr0_right_single_unit] -add {CLOCKREGION_X6Y2:CLOCKREGION_X7Y3}
set_property IS_SOFT TRUE [get_pblocks slr0_right_single_unit]
add_cells_to_pblock [get_pblocks slr0_right_single_unit] [get_cells suspmv_slr0/right_half]

# ============ #
# HBMs Readers #
# ============ #

create_pblock hbm_left
set_property PARENT slr0_left [get_pblocks hbm_left]
resize_pblock [get_pblocks hbm_left] -add {CLOCKREGION_X0Y0:CLOCKREGION_X3Y0}
set_property IS_SOFT TRUE [get_pblocks hbm_left]
add_cells_to_pblock [get_pblocks hbm_left] [get_cells -quiet [list \
    hbm00_reader \
    hbm01_reader \
    hbm02_reader \
    hbm03_reader \
    hbm04_reader \
    hbm05_reader \
    hbm06_reader \
    hbm07_reader \
    hbm08_reader \
    hbm09_reader \
    hbm10_reader \
    hbm11_reader \
    hbm12_reader \
    hbm13_reader \
    hbm14_reader \
    hbm15_reader \
]]

create_pblock hbm_right
set_property PARENT slr0_right [get_pblocks hbm_right]
resize_pblock [get_pblocks hbm_right] -add {CLOCKREGION_X4Y0:CLOCKREGION_X7Y0}
set_property IS_SOFT TRUE [get_pblocks hbm_right]
add_cells_to_pblock [get_pblocks hbm_right] [get_cells -quiet [list \
    hbm16_reader \
    hbm17_reader \
    hbm18_reader \
    hbm19_reader \
    hbm20_reader \
    hbm21_reader \
    hbm22_reader \
    hbm23_reader \
    hbm24_reader \
    hbm25_reader \
    hbm26_reader \
    hbm27_reader \
    hbm28_reader \
    hbm29_reader \
    hbm30_reader \
    hbm31_reader \
]]

# ==================== #
# Long-range Pipelines #
# ==================== #

# SLR0 local connections
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_ctrl_to_hbms]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_ctrl_to_ddr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_weights_*_slr0]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_aresetn_slr0]

# SLR0 -> SLR1
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_*_slr0_to_slr1/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_*_slr0_to_slr1/to_slr]

# SLR1 -> SLR2
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_*_slr1_to_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_*_slr1_to_slr2/to_slr]

# SLR2 -> SLR1
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_*_slr2_to_slr1/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_*_slr2_to_slr1/to_slr]

# SLR1 -> SLR0
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_*_slr1_to_slr0/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_*_slr1_to_slr0/to_slr]

# SLR0 -> SLR2
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_*_slr0_to_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_*_slr0_to_slr2/middle_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_*_slr0_to_slr2/to_slr]

# SLR2 -> SLR0
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_*_slr2_to_slr0/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_*_slr2_to_slr0/middle_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_*_slr2_to_slr0/to_slr]
