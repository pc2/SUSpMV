set PART [lindex $argv 0]
set XO_FILE [lindex $argv 1]
set SUS_FLOAT_LIB_PATH [lindex $argv 2]

# set PART xcvc1902-vsvd1760-2MP-e-S


set KERNEL_NAME SUSpMV_Full

create_project ${KERNEL_NAME} ./${KERNEL_NAME} -part $PART

add_files -norecurse \
{
    ../sus_codegen.sv \
}

import_ip [glob -type f ../../$SUS_FLOAT_LIB_PATH/xci_files/*.xci]

set_property top SUSpMV_Full [current_fileset]


update_compile_order -fileset sources_1


ipx::package_project -root_dir ./${KERNEL_NAME}_ip -vendor pc2 -library sus-designs -taxonomy /UserIP -import_files

#                                ???
# ipx::infer_bus_interface aclk  xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
# ipx::infer_bus_interface aresetn xilinx.com:signal:reset_rtl:1.0 [ipx::current_core]
# ipx::associate_bus_interfaces -clock aclk -reset aresetn [ipx::current_core]
# ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces aclk -of_objects [ipx::current_core]]

set_property ipi_drc {ignore_freq_hz false} [ipx::current_core]
set_property sdx_kernel true [ipx::current_core]
set_property sdx_kernel_type rtl [ipx::current_core]
set_property vitis_drc {ctrl_protocol ap_ctrl_hs} [ipx::current_core]
set_property ipi_drc {ignore_freq_hz true} [ipx::current_core]
set_property supported_families {{zynq Pre-Production virtex7 Pre-Production kintex7 Pre-Production artix7 Pre-Production zynquplus Pre-Production virtex7 Pre-Production qvirtex7 Pre-Production kintex7 Pre-Production kintex7l Pre-Production qkintex7 Pre-Production qkintex7l Pre-Production artix7 Pre-Production artix7l Pre-Production aartix7 Pre-Production qartix7 Pre-Production zynq Pre-Production qzynq Pre-Production azynq Pre-Production spartan7 Pre-Production virtexu Pre-Production virtexuplus Pre-Production virtexuplusHBM Pre-Production kintexuplus Pre-Production zynquplus Pre-Production kintexu Pre-Production versal Pre-Production}} [ipx::current_core]

# Control Registers
set CTRL_ADDR_BLOCK [ipx::get_address_blocks reg0 -of_objects [ipx::get_memory_maps s_axi_control -of_objects [ipx::current_core]]]

proc add_ctrl_reg { name description address_offset size } {
    global CTRL_ADDR_BLOCK
    ipx::add_register $name $CTRL_ADDR_BLOCK
    set_property description    $description    [ipx::get_registers $name -of_objects $CTRL_ADDR_BLOCK]
    set_property address_offset $address_offset [ipx::get_registers $name -of_objects $CTRL_ADDR_BLOCK]
    set_property size           $size           [ipx::get_registers $name -of_objects $CTRL_ADDR_BLOCK]
}

proc add_bus_interface { name width } {
    set BUS_INTERFACE [ipx::get_bus_interfaces $name -of_objects [ipx::current_core]]
    ipx::add_bus_parameter DATA_WIDTH $BUS_INTERFACE
    set_property value           $width [ipx::get_bus_parameters DATA_WIDTH -of_objects $BUS_INTERFACE]
}

proc associate_bus_interface { name on_reg } {
    global CTRL_ADDR_BLOCK
    set ADDR_REG [ipx::get_registers $on_reg -of_objects $CTRL_ADDR_BLOCK]
    ipx::add_register_parameter ASSOCIATED_BUSIF $ADDR_REG
    set_property value          $name          [ipx::get_register_parameters ASSOCIATED_BUSIF -of_objects $ADDR_REG]
}

# CTRL regs
add_ctrl_reg CTRL {Control Signals} 0x000 32
add_ctrl_reg X_VEC {X Vector Addr Start} 0x010 64
add_ctrl_reg Y_VEC_OUT {Y Vector Output Addr Start} 0x018 64
add_ctrl_reg NUM_X_ELEMS {Number of X elements} 0x020 32
add_ctrl_reg NUM_Y_REPETITIONS {Number of Y buffer batches to process per kernel instance} 0x024 32

add_bus_interface maxi_ddr00 512
associate_bus_interface maxi_ddr00 X_VEC
associate_bus_interface maxi_ddr00 Y_VEC_OUT

# HBM CTRL regs
add_ctrl_reg HBM00_ADDR {Start addr of HBM00 memory} 0x028 64
add_ctrl_reg HBM00_COUNT {Number of 256-bit blocks to be read from HBM00} 0x030 32

add_bus_interface maxi_hbm00 256
associate_bus_interface maxi_hbm00 HBM00_ADDR

add_ctrl_reg HBM01_ADDR {Start addr of HBM01 memory} 0x038 64
add_ctrl_reg HBM01_COUNT {Number of 256-bit blocks to be read from HBM01} 0x040 32

add_bus_interface maxi_hbm01 256
associate_bus_interface maxi_hbm01 HBM01_ADDR

set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity -kernel -xrt [ipx::current_core]
ipx::save_core [ipx::current_core]

package_xo -xo_path $XO_FILE -kernel_name ${KERNEL_NAME} -ctrl_protocol ap_ctrl_hs -ip_directory ./${KERNEL_NAME}_ip
 # -output_kernel_xml ../../${KERNEL_NAME}.xml
