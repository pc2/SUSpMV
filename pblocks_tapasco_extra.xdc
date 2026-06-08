
### UNUSED - tapasco didn't seem to actually include this file, so I removed it again. 

# HBM controlling memory interface seems to cross the SLR0 boundary in an unfortunate manner. We constrain it to stay on the right side of SLR0
add_cells_to_pblock system_i_arch_target_ip_00_000_internal_target_ip_00_000_inst_slr0_right [get_cells [list system_i/host/out_ic]]

# Memory interface connecting to X & Y vec memory, seems to be pushed out of the vicinity. 
add_cells_to_pblock system_i_arch_target_ip_00_000_internal_target_ip_00_000_inst_x_y_pblock [get_cells [list system_i/memory/mig_ic/inst/s01_entry_pipeline system_i/memory/mig_ic/inst/s01_nodes]]
