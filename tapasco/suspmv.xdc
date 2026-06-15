create_pblock pblock_tapasco_memory_slr0
resize_pblock [get_pblocks pblock_tapasco_memory_slr0] -add {CLOCKREGION_X4Y0:CLOCKREGION_X7Y3}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_memory_slr0]
add_cells_to_pblock [get_pblocks pblock_tapasco_memory_slr0] [get_cells -quiet [list \
	system_i/arch/ddr_slr_crossing/inst/ar12.slr_master_ar \
	system_i/arch/ddr_slr_crossing/inst/r12.slr_master_r \
	system_i/arch/ddr_slr_crossing/inst/aw12.slr_master_aw \
	system_i/arch/ddr_slr_crossing/inst/w12.slr_master_w \
	system_i/arch/ddr_slr_crossing/inst/b12.slr_master_b \
]]

create_pblock pblock_tapasco_memory_slr1
resize_pblock [get_pblocks pblock_tapasco_memory_slr1] -add {CLOCKREGION_X4Y4:CLOCKREGION_X7Y4}
# resize_pblock [get_pblocks pblock_tapasco_memory_slr1] -add {CLOCKREGION_X4Y4:CLOCKREGION_X4Y7}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_memory_slr1]
add_cells_to_pblock [get_pblocks pblock_tapasco_memory_slr1] [get_cells -quiet [list \
	system_i/memory/mig_ic \
	system_i/memory/dma \
	system_i/arch/ddr_slr_crossing/inst/ar12.slr_slave_ar \
	system_i/arch/ddr_slr_crossing/inst/r12.slr_slave_r \
	system_i/arch/ddr_slr_crossing/inst/aw12.slr_slave_aw \
	system_i/arch/ddr_slr_crossing/inst/w12.slr_slave_w \
	system_i/arch/ddr_slr_crossing/inst/b12.slr_slave_b \
]]
