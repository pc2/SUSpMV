# Simulate with Vivado

# U280
create_project -force proj /tmp/proj -part xcu280-fsvh2892-2L-e
# set_property board_part xilinx.com:au280:part0:1.2 [current_project]

add_files -fileset sources_1 ../../U280/sus_codegen.sv
add_files -fileset sources_1 ../../autopipeline.sv
add_files -fileset sim_1 testbench.sv
add_files -fileset sim_1 {hbm0.mem hbm1.mem x_vec.mem expected.mem}
add_files -fileset sim_1 matrix_params.vh

import_ip [glob -type f ../../sus-float/UltraScalePlus/xci_files/*.xci]
upgrade_ip [get_ips]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property top SUSpMV_Full_tb [get_filesets sim_1]

# set_property top proj [get_filesets sim_1]
# set_property top_lib xil_defaultlib [get_filesets sim_1]

start_gui
launch_simulation
run all
