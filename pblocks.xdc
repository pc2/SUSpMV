create_pblock pblock_suspmv_slr0
# add_cells_to_pblock [get_pblocks pblock_suspmv_slr0] [get_cells -quiet [list suspmv_slr0]]
resize_pblock [get_pblocks pblock_suspmv_slr0] -add {SLR0}
create_pblock pblock_suspmv_slr1
# add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet [list suspmv_slr1]]
resize_pblock [get_pblocks pblock_suspmv_slr1] -add {SLR1}
create_pblock pblock_suspmv_slr2
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells -quiet [list suspmv_slr2]]
resize_pblock [get_pblocks pblock_suspmv_slr2] -add {SLR2}
## Don't know how to target DDR1 for these???
# create_pblock pblock_xy_vector
# add_cells_to_pblock [get_pblocks pblock_xy_vector] [get_cells -quiet [list x_vector_reader y_result_writer]]
# resize_pblock [get_pblocks pblock_xy_vector] -add {CLOCKREGION_X3Y4:CLOCKREGION_X4Y7}
create_pblock pblock_ctrl
add_cells_to_pblock [get_pblocks pblock_ctrl] [get_cells -quiet [list ctrl]]
resize_pblock [get_pblocks pblock_ctrl] -add {SLICE_X104Y61:SLICE_X116Y119}
resize_pblock [get_pblocks pblock_ctrl] -add {BUFCE_LEAF_X528Y4:BUFCE_LEAF_X591Y7}
resize_pblock [get_pblocks pblock_ctrl] -add {BUFCE_ROW_FSR_X118Y1:BUFCE_ROW_FSR_X131Y1}
resize_pblock [get_pblocks pblock_ctrl] -add {DSP48E2_X14Y20:DSP48E2_X15Y41}
resize_pblock [get_pblocks pblock_ctrl] -add {HARD_SYNC_X14Y2:HARD_SYNC_X15Y3}
resize_pblock [get_pblocks pblock_ctrl] -add {RAMB18_X7Y26:RAMB18_X7Y47}
resize_pblock [get_pblocks pblock_ctrl] -add {RAMB36_X7Y13:RAMB36_X7Y23}
set_property PARENT pblock_suspmv_slr0 [get_pblocks pblock_ctrl]
set_property PARENT pblock_suspmv_slr0 [get_pblocks hbm_access_pblock]
create_pblock hbm_access_pblock
add_cells_to_pblock [get_pblocks hbm_access_pblock] [get_cells -quiet [list hbm00_reader hbm01_reader]]
resize_pblock [get_pblocks hbm_access_pblock] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y0}

