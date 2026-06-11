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
    suspmv_slr2
]]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr1] [get_cells -quiet [list \
    suspmv_slr1
]]
add_cells_to_pblock [get_pblocks pblock_suspmv_slr2] [get_cells -quiet [list \
    suspmv_slr0
]]
