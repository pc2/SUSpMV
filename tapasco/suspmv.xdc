create_pblock pblock_tapasco_memory_slr0
resize_pblock [get_pblocks pblock_tapasco_memory_slr0] -add {CLOCKREGION_X4Y3:CLOCKREGION_X7Y3}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_memory_slr0]
add_cells_to_pblock [get_pblocks pblock_tapasco_memory_slr0] [get_cells -quiet [list \
	system_i/arch/ddr_slr_crossing/inst/ar12.slr_master_* \
]]

create_pblock pblock_tapasco_memory_slr1
resize_pblock [get_pblocks pblock_tapasco_memory_slr1] -add {CLOCKREGION_X4Y4:CLOCKREGION_X7Y4}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_memory_slr1]
add_cells_to_pblock [get_pblocks pblock_tapasco_memory_slr1] [get_cells -quiet [list \
	system_i/memory/mig_ic \
	system_i/memory/dma \
	system_i/arch/ddr_slr_crossing/inst/ar12.slr_slave_* \
]]
