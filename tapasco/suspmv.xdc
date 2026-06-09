create_pblock pblock_tapasco_memory
resize_pblock [get_pblocks pblock_tapasco_memory] -add {CLOCKREGION_X4Y4:CLOCKREGION_X7Y7}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_memory]
add_cells_to_pblock [get_pblocks pblock_tapasco_memory] [get_cells -quiet [list \
	system_i/memory/mig_ic \
	system_i/memory/dma \
]]
