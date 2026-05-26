create_pblock pblock_suspmv_slr0
# add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet [list suspmv_slr0]]
resize_pblock [get_pblocks pblock_suspmv_slr0] -add {SLR0}
create_pblock pblock_suspmv_slr1
# add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet [list suspmv_slr1]]
resize_pblock [get_pblocks pblock_suspmv_slr1] -add {SLR1}
create_pblock pblock_suspmv_slr2
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells -quiet [list suspmv_slr2]]
resize_pblock [get_pblocks pblock_suspmv_slr2] -add {SLR2}

# On SLR1 in the center
create_pblock pblock_xy_vector
add_cells_to_pblock [get_pblocks pblock_xy_vector] [get_cells -quiet [list x_vector_reader y_result_writer]]
resize_pblock [get_pblocks pblock_xy_vector] -add {CLOCKREGION_X4Y4:CLOCKREGION_X5Y7}

# A corner of SLR0 in the center
create_pblock pblock_ctrl
add_cells_to_pblock [get_pblocks pblock_ctrl] [get_cells -quiet [list ctrl]]
resize_pblock [get_pblocks pblock_ctrl] -add {CLOCKREGION_X4Y1:CLOCKREGION_X4Y1}

# Bottom of SLR0
create_pblock hbm_access_pblock
add_cells_to_pblock [get_pblocks hbm_access_pblock] [get_cells hbm*_reader]
resize_pblock [get_pblocks hbm_access_pblock] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y0}

set_property PARENT pblock_suspmv_slr0 [get_pblocks pblock_ctrl]
set_property PARENT pblock_suspmv_slr0 [get_pblocks hbm_access_pblock]
