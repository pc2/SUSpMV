create_pblock pblock_tapasco_memory_slr0
resize_pblock [get_pblocks pblock_tapasco_memory_slr0] -add {CLOCKREGION_X5Y0:CLOCKREGION_X7Y3}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_memory_slr0]
add_cells_to_pblock [get_pblocks pblock_tapasco_memory_slr0] [get_cells -quiet [list \
    system_i/arch/ddr_slr_crossing/inst/ar12.slr_master_ar \
    system_i/arch/ddr_slr_crossing/inst/r12.slr_master_r \
    system_i/arch/ddr_slr_crossing/inst/aw12.slr_master_aw \
    system_i/arch/ddr_slr_crossing/inst/w12.slr_master_w \
    system_i/arch/ddr_slr_crossing/inst/b12.slr_master_b \
]]

create_pblock pblock_tapasco_memory_slr1
resize_pblock [get_pblocks pblock_tapasco_memory_slr1] -add {CLOCKREGION_X5Y4:CLOCKREGION_X7Y5}
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

create_pblock pblock_tapasco_hbm_left
resize_pblock [get_pblocks pblock_tapasco_hbm_left] -add {CLOCKREGION_X0Y0:CLOCKREGION_X3Y3}
# resize_pblock [get_pblocks pblock_tapasco_memory_slr1] -add {CLOCKREGION_X4Y4:CLOCKREGION_X4Y7}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_hbm_left]
add_cells_to_pblock [get_pblocks pblock_tapasco_hbm_left] [get_cells -quiet [list \
    system_i/hbm/converter_0 \
    system_i/hbm/converter_1 \
    system_i/hbm/converter_2 \
    system_i/hbm/converter_3 \
    system_i/hbm/converter_4 \
    system_i/hbm/converter_5 \
    system_i/hbm/converter_6 \
    system_i/hbm/converter_7 \
    system_i/hbm/converter_8 \
    system_i/hbm/converter_9 \
    system_i/hbm/converter_10 \
    system_i/hbm/converter_11 \
    system_i/hbm/converter_12 \
    system_i/hbm/converter_13 \
    system_i/hbm/converter_14\
    system_i/hbm/converter_15 \
]]

create_pblock pblock_tapasco_hbm_right
resize_pblock [get_pblocks pblock_tapasco_hbm_right] -add {CLOCKREGION_X4Y0:CLOCKREGION_X7Y3}
# resize_pblock [get_pblocks pblock_tapasco_memory_slr1] -add {CLOCKREGION_X4Y4:CLOCKREGION_X4Y7}
set_property IS_SOFT FALSE [get_pblocks pblock_tapasco_hbm_right]
add_cells_to_pblock [get_pblocks pblock_tapasco_hbm_right] [get_cells -quiet [list \
    system_i/hbm/converter_16 \
    system_i/hbm/converter_17 \
    system_i/hbm/converter_18 \
    system_i/hbm/converter_19 \
    system_i/hbm/converter_ic_dma \
    system_i/hbm/converter_21 \
    system_i/hbm/converter_22 \
    system_i/hbm/converter_23 \
    system_i/hbm/converter_24 \
    system_i/hbm/converter_25 \
    system_i/hbm/converter_26 \
    system_i/hbm/converter_27 \
    system_i/hbm/converter_28 \
    system_i/hbm/converter_29 \
    system_i/hbm/converter_30 \
    system_i/hbm/converter_31 \
]]

# create_pblock converter_ic_dma_pblock
# resize_pblock [get_pblocks converter_ic_dma_pblock] -add {CLOCKREGION_X5Y0:CLOCKREGION_X5Y1}
# set_property IS_SOFT TRUE [get_pblocks converter_ic_dma_pblock]
# add_cells_to_pblock [get_pblocks converter_ic_dma_pblock] [get_cells -quiet [list # 	system_i/hbm/converter_ic_dma # ]]

