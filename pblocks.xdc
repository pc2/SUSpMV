
create_pblock pblock_suspmv_slr0
# add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells suspmv_slr0]
# resize_pblock [get_pblocks pblock_suspmv_slr0] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y3}
resize_pblock [get_pblocks pblock_suspmv_slr0] -add {SLR0}
set_property IS_SOFT FALSE [get_pblocks pblock_suspmv_slr0]

create_pblock pblock_suspmv_slr1
# add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells suspmv_slr1]
# resize_pblock [get_pblocks pblock_suspmv_slr1] -add {CLOCKREGION_X0Y4:CLOCKREGION_X7Y7}
resize_pblock [get_pblocks pblock_suspmv_slr1] -add {SLR1}
set_property IS_SOFT FALSE [get_pblocks pblock_suspmv_slr1]

create_pblock pblock_suspmv_slr2
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells suspmv_slr2]
# resize_pblock [get_pblocks pblock_suspmv_slr2] -add {CLOCKREGION_X0Y8:CLOCKREGION_X7Y11}
resize_pblock [get_pblocks pblock_suspmv_slr2] -add {SLR2}
set_property IS_SOFT FALSE [get_pblocks pblock_suspmv_slr2]

# XY Vector memory on SLR1 in the center
create_pblock pblock_xy_vector
set_property PARENT [get_pblocks pblock_suspmv_slr1] [get_pblocks pblock_xy_vector]
add_cells_to_pblock [get_pblocks pblock_xy_vector] [get_cells -quiet [list x_vector_reader y_result_writer]]
resize_pblock [get_pblocks pblock_xy_vector] -add {CLOCKREGION_X4Y4:CLOCKREGION_X5Y7}

# CTRL goes in the center of SLR0, so it's close to all HBMs
create_pblock pblock_ctrl
set_property PARENT [get_pblocks pblock_suspmv_slr0] [get_pblocks pblock_ctrl]
add_cells_to_pblock [get_pblocks pblock_ctrl] [get_cells ctrl]
resize_pblock [get_pblocks pblock_ctrl] -add {CLOCKREGION_X4Y1:CLOCKREGION_X4Y1}


# HBM Banks stay at the Bottom of SLR0
create_pblock pblock_hbm00_03
resize_pblock pblock_hbm00_03 -add {CLOCKREGION_X0Y0:CLOCKREGION_X0Y0}
add_cells_to_pblock [get_pblocks pblock_hbm00_03] [get_cells [list hbm00_reader hbm01_reader]]


# Long lines crossing SLRs. 
# Covered by (* user_sll_reg = 1 *)?
# set_property USER_SLL_REG 1 [get_cells */suspmv_din_laguna_reg]
# set_property USER_SLL_REG 1 [get_cells */suspmv_dout_laguna_reg]

add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_ctrl_to_hbms]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells pipe_ctrl_to_ddr1/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_ctrl_to_ddr1/to_slr]

add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_x_vector_info_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_x_vector_info_slr2/to_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_x_page_releases_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_x_page_releases_slr2/to_slr]

add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_start_y_bursts_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_start_y_bursts_slr2/to_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_may_y_valid_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_may_y_valid_slr2/to_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells pipe_y_valid_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells pipe_y_valid_slr2/to_slr]

# Long lines for HBMs
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet pipe_weights_*_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet pipe_weights_*_slr2/middle_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells -quiet pipe_weights_*_slr2/to_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells -quiet pipe_may_push_*_slr2/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet pipe_may_push_*_slr2/middle_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet pipe_may_push_*_slr2/to_slr]

add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet pipe_weights_*_slr1/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet pipe_weights_*_slr1/to_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet pipe_may_push_*_slr1/from_slr]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet pipe_may_push_*_slr1/to_slr]

add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet pipe_weights_*_slr0]
