
# set_property USER_SLR_ASSIGNMENT SLR0 [get_cells suspmv_slr0]
# set_property USER_SLR_ASSIGNMENT SLR1 [get_cells suspmv_slr1]
set_property USER_SLR_ASSIGNMENT SLR2 [get_cells suspmv_slr2]

# On SLR1 in the center
create_pblock pblock_xy_vector
add_cells_to_pblock [get_pblocks pblock_xy_vector] [get_cells -quiet [list x_vector_reader y_result_writer]]
resize_pblock [get_pblocks pblock_xy_vector] -add {CLOCKREGION_X4Y4:CLOCKREGION_X5Y7}

set_property USER_SLR_ASSIGNMENT SLR1 [get_cells -quiet [list x_vector_reader y_result_writer]]

# A corner of SLR0 in the center
create_pblock pblock_ctrl
add_cells_to_pblock [get_pblocks pblock_ctrl] [get_cells ctrl]
resize_pblock [get_pblocks pblock_ctrl] -add {CLOCKREGION_X4Y1:CLOCKREGION_X4Y1}

set_property USER_SLR_ASSIGNMENT SLR0 [get_cells ctrl]


# Bottom of SLR0
create_pblock hbm_access_pblock
add_cells_to_pblock [get_pblocks hbm_access_pblock] [get_cells hbm*_reader]
resize_pblock [get_pblocks hbm_access_pblock] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y0}

set_property USER_SLR_ASSIGNMENT SLR0 [get_cells hbm*_reader]
