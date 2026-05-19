# This is a plugin for TaPaSCo, which effects the PE AXI4-Master connections.
# It will instantiate the AU280 HBM and connect the PE as desired.
# How to use:
#   1. Copy this plugin file to $TAPASCO_HOME_TOOLFLOW/vivado/platform/AU280/plugins/
#   2. Delete line 84 in $TAPASCO_HOME_TOOLFLOW/vivado/platform/pcie/pcie_base.tcl
#      error "No address defined for [get_property NAME $m], please make sure to define one in post-address-map plugin"
#   3. Run `tapasco --jobsFile job_au280.json` using the job_au280.json file from this directory.

if {[tapasco::is_feature_enabled "suspmv"]} {
    proc create_custom_subsystem_hbm {{args {}}} {
        puts "suspmv::create_custom_subsystem_hbm"
        # create refclk
        current_bd_instance
        set hbm_ref_clk_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 hbm_ref_clk ]
        set_property CONFIG.FREQ_HZ 100000000 $hbm_ref_clk_0

        # create hbm core
        set pe [get_bd_cells /arch/target_ip_00_000/internal_target_ip_00_000]
        set hbmports [get_bd_intf_pins -of_objects $pe -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*hbm*"}]
        current_bd_instance /hbm
        suspmv::generate_hbm_core $hbmports
        save_bd_design
    }
}

namespace eval suspmv {

    proc remove_ports { pe unused } {
        puts "suspmv::remove_ports"
        set pe [get_bd_cells $pe]
        set group [current_bd_instance .]

        # prevent hbm ports from being connected to ddr
        set hbmports [get_bd_intf_pins -of_objects $group -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*hbm*"}]
        delete_bd_objs $hbmports
        save_bd_design
    }

    proc generate_hbm_core { hbmports } {
        puts "Generating HBM Core"

        # create and configure HBM IP
        set pe_ports [llength $hbmports]
        if { $pe_ports > 32 } {
            set pe_ports 32
        }
        set total_ports $pe_ports
        #set total_ports [expr $pe_ports + 1]
        #if { $total_ports > 32 } {
        #    set total_ports 32
        #}
        puts $pe_ports
        puts $total_ports

        set bothStacks [expr ($total_ports > 16)]
        set hbm_properties [create_hbm_properties $total_ports]
        set hbm [tapasco::ip::create_hbm "hbm_0"]
        set_property -dict $hbm_properties $hbm
        set_property -dict [list \
            CONFIG.USER_SWITCH_ENABLE_00 {TRUE} \
            CONFIG.USER_SWITCH_ENABLE_01 {TRUE} \
        ] $hbm
        save_bd_design

        # clocking
        set ibuf [tapasco::ip::create_util_buf ibuf]
        set_property -dict [ list CONFIG.C_BUF_TYPE {IBUFDS}  ] $ibuf
        connect_bd_intf_net [get_bd_intf_ports /hbm_ref_clk] [get_bd_intf_pins $ibuf/CLK_IN_D]

        # clocking left stack
        connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/HBM_REF_CLK_0]
        connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/APB_0_PCLK]
        connect_bd_net [get_bd_pins /host/axi_pcie3_0/user_lnk_up] [get_bd_pins $hbm/APB_0_PRESET_N]

        if {$bothStacks} {
            # clocking right stack
            connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/HBM_REF_CLK_1]
            connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/APB_1_PCLK]
            connect_bd_net [get_bd_pins /host/axi_pcie3_0/user_lnk_up] [get_bd_pins $hbm/APB_1_PRESET_N]
        }

        set aclk [get_bd_pins design_clk]
        set aresetn [get_bd_pins design_interconnect_aresetn]
        save_bd_design

        # create DMA port
        #set_property CONFIG.NUM_MI {2} [get_bd_cells /memory/mig_ic]
        #set dma_master [get_bd_intf_pins /memory/mig_ic/M01_AXI]
        #puts $dma_master

        puts "connect pes"
        puts $total_ports
        # connect PEs
        for {set i 0} {$i < $total_ports} {incr i} {
            set master [lindex $hbmports $i]
            set hbm_index [format %02s $i]
    
            # create interconnect for protocol conversion (AXI4->AXI3)
            #if { $i == $pe_ports } {
            #    # port is used by DMA engine only
            #    set dma_slave [get_bd_intf_pins $hbm/SAXI_${hbm_index}]
            #    set dma_slave_clk [get_bd_pins $hbm/AXI_${hbm_index}_ACLK]
            #    set dma_slave_rst [get_bd_pins $hbm/AXI_${hbm_index}_ARESET_N]
            #} else {
            #    if { $i == 31 } {
            #        # port is used by PE and DMA engine
            #        set converter [tapasco::ip::create_axi_ic converter_ic_${i} 2 1]
            #        set dma_slave [get_bd_intf_pins $converter/S01_AXI]
            #        set dma_slave_clk [get_bd_pins $converter/S01_ACLK]
            #        set dma_slave_rst [get_bd_pins $converter/S01_ARESETN]
            #    } else {
                    set converter [tapasco::ip::create_axi_ic converter_ic_${i} 1 1]
            #    }
                connect_bd_net $aclk [get_bd_pins $converter/S00_ACLK] [get_bd_pins $converter/ACLK] [get_bd_pins $converter/M00_ACLK] [get_bd_pins $hbm/AXI_${hbm_index}_ACLK]
                connect_bd_net $aresetn [get_bd_pins $converter/S00_ARESETN] [get_bd_pins $converter/ARESETN] [get_bd_pins $converter/M00_ARESETN] [get_bd_pins $hbm/AXI_${hbm_index}_ARESET_N]
                connect_bd_intf_net $master [get_bd_intf_pins $converter/S00_AXI]
                puts [get_bd_intf_pins $converter/M00_AXI]
                puts [get_bd_intf_pins $hbm/SAXI_${hbm_index}]
                connect_bd_intf_net [get_bd_intf_pins $converter/M00_AXI] [get_bd_intf_pins $hbm/SAXI_${hbm_index}]
            #}
        }
        save_bd_design
        # connect DMA engine
        #connect_bd_intf_net $dma_master $dma_slave
        #connect_bd_intf_net [get_bd_pins memory_clk] [get_bd_pins /memory/mig_ic/M01_ACLK] $dma_slave_clk
        #connect_bd_intf_net [get_bd_pins memory_interconnect_aresetn] [get_bd_pins /memory/mig_ic/M01_ARESETN] $dma_slave_rst
        save_bd_design

        # address map
        for {set i 0} {$i < $pe_ports} {incr i} {
            set hbm_index [format %02s $i]
            assign_bd_address -target_address_space /arch/target_ip_00_000/internal_target_ip_00_000/maxi_hbm${hbm_index} [get_bd_addr_segs hbm/hbm_0/SAXI_${hbm_index}/] -force
        }

        # apply constraints for one or both stacks
        current_bd_instance /hbm
        set constraints_l "$::env(TAPASCO_HOME_TCL)/platform/AU280/plugins/hbm_l.xdc"
        read_xdc $constraints_l
        set_property PROCESSING_ORDER EARLY [get_files $constraints_l]

        if {$bothStacks} {
            set constraints_r "$::env(TAPASCO_HOME_TCL)/platform/AU280/plugins/hbm_r.xdc"
            read_xdc $constraints_r
            set_property PROCESSING_ORDER EARLY [get_files $constraints_r]
        }
    }

    proc create_hbm_properties {numInterfaces} {
        # disable APB debug port
        # disable AXI crossbar (global addressing)
        # configure AXI clock freq
        set hbm_properties [list \
            CONFIG.USER_APB_EN {false} \
            CONFIG.USER_SWITCH_ENABLE_00 {false} \
            CONFIG.USER_SWITCH_ENABLE_01 {false} \
            CONFIG.USER_AXI_INPUT_CLK_FREQ {450} \
            CONFIG.USER_AXI_INPUT_CLK_NS {2.222} \
            CONFIG.USER_AXI_INPUT_CLK_PS {2222} \
            CONFIG.USER_AXI_INPUT_CLK_XDC {2.222} \
            CONFIG.HBM_MMCM_FBOUT_MULT0 {51} \
            CONFIG.USER_XSDB_INTF_EN {FALSE}
        ]

        # configure stacks used
        if {$numInterfaces <= 16} {
            set maxSlaves 16
            lappend hbm_properties \
            CONFIG.USER_HBM_DENSITY {4GB} \
            CONFIG.USER_HBM_STACK {1} \
        } else {
            set maxSlaves 32
            lappend hbm_properties \
            CONFIG.USER_HBM_DENSITY {8GB} \
        }


        # enable HBM ports and memory controllers as required (two ports per mc)
        for {set i $numInterfaces} {$i < $maxSlaves} {incr i} {
            set saxi [format %02s $i]
            lappend hbm_properties CONFIG.USER_SAXI_${saxi} {false}
            if { $i % 2 == 0 } {
                set mc [format %02s [expr {$i / 2}]]
                lappend hbm_properties CONFIG.USER_MC_ENABLE_${mc} {false}
            }
        }


        # configure memory controllers
        for {set i 0} { $i < $maxSlaves } {incr i} {
            if { $i % 2 == 0 } {
                set mc [format %s [expr {$i / 2}]]
                lappend hbm_properties CONFIG.USER_MC${mc}_ECC_BYPASS false
                lappend hbm_properties CONFIG.USER_MC${mc}_ECC_CORRECTION false
                lappend hbm_properties CONFIG.USER_MC${mc}_EN_DATA_MASK true
                lappend hbm_properties CONFIG.USER_MC${mc}_TRAFFIC_OPTION {Linear}
                lappend hbm_properties CONFIG.USER_MC${mc}_BG_INTERLEAVE_EN true
            }
        }

        return $hbm_properties
    }

    proc addressmap {{args {}}} {
        set pe [get_bd_cells /arch/target_ip_00_000/internal_target_ip_00_000]
        set hbmports [get_bd_intf_pins -of_objects $pe -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*hbm*"}]

        for {set i 0} {$i < [llength $hbmports]} {incr i} {
            set args [lappend args maxi_hbm${i} [list 0 0 -1 ""]]
        }
        puts $args
        return $args
    }

}

if {[tapasco::is_feature_enabled "suspmv"]} {
    tapasco::register_plugin "platform::suspmv::remove_ports" "post-pe-create"
    #tapasco::register_plugin "platform::suspmv::addressmap" "post-address-map"
}
