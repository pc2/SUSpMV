# This is a plugin for TaPaSCo, which effects the PE AXI4-Master connections.
# It will instantiate the V80 HBM-NoC and DDR-NoC and connect the PE as desired.
# How to use:
#   1. Copy this plugin file to $TAPASCO_HOME_TOOLFLOW/vivado/platform/v80/plugins/
#   2. Run `tapasco --jobsFile job.json` using the job.json file from this directory.

namespace eval suspmv {

    variable clk
    variable rstn

    proc generate {} {
        clear
        configure_memory
        create_arch
    }

    proc clear {} {
        current_bd_instance
        delete_bd_objs [get_bd_cells arch/*]
        delete_bd_objs [get_bd_intf_ports ddr4_c1_sysclk]
        delete_bd_objs [get_bd_intf_pins arch/ddr4_c1_sysclk]
        delete_bd_objs [get_bd_intf_ports ddr4_sdram_c1]
        delete_bd_objs [get_bd_intf_pins arch/ddr4_sdram_c1]
    }

    proc configure_memory {} {
        delete_bd_objs [get_bd_intf_pins memory/M_ARCH]
        delete_bd_objs [get_bd_cells memory/arch_offset_0]
        set_property -dict [list \
            CONFIG.NUM_MI {2} \
            CONFIG.NUM_NMI {4} \
        ] [get_bd_cells memory/axi_noc_0]

        # PCIe access to tapasco, pe, hbm, and ddr
        # leave 4GB DDR unconnected, because NoC compiler can't find a valid configuration
        # MC_0 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}}
        set_property -dict [list CONFIG.CONNECTIONS { \
            M00_AXI {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}} \
            M01_AXI {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}} \
            M00_INI {read_bw {500} write_bw {500}} \
            M02_INI {read_bw {500} write_bw {500}} \
        }] [get_bd_intf_pins /memory/axi_noc_0/S06_AXI]
        # MC_1 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}}
        set_property -dict [list CONFIG.CONNECTIONS { \
            M00_AXI {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}} \
            M01_AXI {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}} \
            M01_INI {read_bw {500} write_bw {500}} \
            M03_INI {read_bw {500} write_bw {500}} \
        }] [get_bd_intf_pins /memory/axi_noc_0/S07_AXI]

        create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 arch/DDR00_INI
        create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 arch/DDR01_INI
        create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 arch/HBM00_INI
        create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 arch/HBM01_INI

        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M01_AXI] [get_bd_intf_pins arch/S_ARCH]
        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M00_INI] [get_bd_intf_pins arch/DDR00_INI]
        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M01_INI] [get_bd_intf_pins arch/DDR01_INI]
        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M02_INI] [get_bd_intf_pins arch/HBM00_INI]
        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M03_INI] [get_bd_intf_pins arch/HBM01_INI]
    }

    proc create_arch {} {
        variable clk
        variable rstn
        set prev_bd_instance [current_bd_instance .]
        current_bd_instance
        current_bd_instance "arch"
        set arch_group [current_bd_instance .]

        set clk [get_bd_pin design_clk]
        set rstn [get_bd_pin design_peripheral_aresetn]
        set MAXI [get_bd_intf_pins M_MEM_0]
        set SAXI [get_bd_intf_pins S_ARCH]

        # create pe
        set pe [create_pe]

        # create ddr and hbm
        set hbm_port_count 0
        set ddr_port_count 0
        while { [get_bd_intf_pins $pe/[format "maxi_ddr%02d" $ddr_port_count]] != "" } {
            incr ddr_port_count
        }
        while { [get_bd_intf_pins $pe/[format "maxi_hbm%02d" $hbm_port_count]] != "" } {
            incr hbm_port_count
        }
        puts "DDR ports: $ddr_port_count"
        puts "HBM ports: $hbm_port_count"
        set ddr [create_ddr_noc $ddr_port_count]
        set hbm [create_hbm_noc $hbm_port_count]

        # connect ddr and hbm
        for { set i 0 } { $i < $ddr_port_count } { incr i } {
            connect_bd_intf_net [get_bd_intf_pins $ddr/[format "S%02d_AXI" $i]] [get_bd_intf_pins $pe/[format "maxi_ddr%02d" $i]]
        }
        for { set i 0 } { $i < $hbm_port_count } { incr i } {
            connect_bd_intf_net [get_bd_intf_pins $hbm/[format "HBM%02d_AXI" $i]] [get_bd_intf_pins $pe/[format "maxi_hbm%02d" $i]]
        }

        regenerate_bd_layout -hierarchy $arch_group
        current_bd_instance $prev_bd_instance
        save_bd_design
        addressmap
        validate_bd_design
    }

    proc addressmap {} {
        current_bd_instance
        # pe
        assign_bd_address -target_address_space /host/versal_cips_0/CPM_PCIE_NOC_0 -offset 0x20102000000 -range 64K [get_bd_addr_segs arch/suspmv/saxil/reg0] -force
        assign_bd_address -target_address_space /host/versal_cips_0/CPM_PCIE_NOC_1 -offset 0x20102000000 -range 64K [get_bd_addr_segs arch/suspmv/saxil/reg0] -force

        # rest can be auto assigned
        assign_bd_address
    }

    proc create_pe { } {
        variable clk
        variable rstn

        puts "create PE"
        set pe [create_bd_cell -type ip -vlnv sus:suspvm:suspmv:1.0 suspmv]
        smartconnect sc_ctrl $clk [get_bd_intf_pins S_ARCH] "[get_bd_intf_pins $pe/saxil]"
        connect_bd_net $clk [get_bd_pins $pe/aclk]
        connect_bd_net $rstn [get_bd_pins $pe/aresetn]
        connect_bd_net [get_bd_pins $pe/intr] [get_bd_pins /arch/intr_PE_0_0]

        return $pe
    }

    proc smartconnect { name clk m s } {
        set sc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 $name]
        set_property -dict [list \
            CONFIG.HAS_ARESETN {0} \
            CONFIG.NUM_SI [llength $m] \
            CONFIG.NUM_MI [llength $s] \
        ] [get_bd_cells $sc]
        for { set i 0 } { $i < [llength $m] } { incr i } {
            set si [format "%02d" $i]
            connect_bd_intf_net [get_bd_intf_pins [lindex $m $i]] [get_bd_intf_pins $sc/S${si}_AXI]
        }
        for { set i 0 } { $i < [llength $s] } { incr i } {
            set mi [format "%02d" $i]
            connect_bd_intf_net [get_bd_intf_pins $sc/M${mi}_AXI] [get_bd_intf_pins [lindex $s $i]]
        }
        connect_bd_net $clk [get_bd_pins $sc/aclk]
    }

    proc create_hbm_noc { ports } {
        variable clk
        puts "create HBM NoC"
        set noc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 hbm_noc]
        connect_bd_net $clk [get_bd_pins $noc/aclk0]
        set_property -dict [list \
            CONFIG.HBM_GBL_REF_RST_EN {false} \
            CONFIG.HBM_NUM_CHNL {16} \
            CONFIG.NUM_HBM_BLI $ports \
            CONFIG.NUM_MI {0} \
            CONFIG.NUM_SI {0} \
            CONFIG.NUM_NSI {2} \
        ] [get_bd_cells $noc]
        connect_bd_intf_net [get_bd_intf_pins HBM00_INI] [get_bd_intf_pins $noc/S00_INI]
        connect_bd_intf_net [get_bd_intf_pins HBM01_INI] [get_bd_intf_pins $noc/S01_INI]

        set connections02 ""
        set connections13 ""
        for { set i 0 } { $i < 16 } { incr i } {
            dict set connections02 HBM${i}_PORT0 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}}
            dict set connections02 HBM${i}_PORT2 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}}
            dict set connections13 HBM${i}_PORT1 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}}
            dict set connections13 HBM${i}_PORT3 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}}
        }
        set_property -dict [list CONFIG.CONNECTIONS $connections02] [get_bd_intf_pins $noc/S00_INI]
        set_property -dict [list CONFIG.CONNECTIONS $connections13] [get_bd_intf_pins $noc/S01_INI]

        for { set i 0 } { $i < $ports } { incr i 1 } {
            set_property -dict [list CONFIG.CONNECTIONS "HBM[expr $i / 4]_PORT[expr $i % 4] {read_bw {13000} write_bw {13000} read_avg_burst {64} write_avg_burst {64}}"] [get_bd_intf_pins $noc/[format "HBM%02d_AXI" $i]]
        }
        return $noc
    }

    proc create_ddr_noc { ports } {
        variable clk
        puts "create DDR NoC"
        set noc [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 ddr_noc]
        connect_bd_net $clk [get_bd_pins $noc/aclk0]
        set_property -dict [list \
            CONFIG.NUM_MI {0} \
            CONFIG.NUM_SI $ports \
            CONFIG.NUM_NSI {2} \
        ] [get_bd_cells $noc]
        connect_bd_intf_net [get_bd_intf_pins DDR00_INI] [get_bd_intf_pins $noc/S00_INI]
        connect_bd_intf_net [get_bd_intf_pins DDR01_INI] [get_bd_intf_pins $noc/S01_INI]
        set_property -dict [list \
            CONFIG.CH1_DDR4_0_BOARD_INTERFACE {ddr4_sdram_c1} \
            CONFIG.MC0_CONFIG_NUM {config21} \
            CONFIG.MC_CHAN_REGION0 {DDR_LOW1} \
            CONFIG.MC_COMPONENT_WIDTH {x4} \
            CONFIG.MC_INPUTCLK0_PERIOD {5000} \
            CONFIG.MC_MEMORY_DEVICETYPE {RDIMMs} \
            CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
            CONFIG.MC_PARITY {true} \
            CONFIG.MC_ROWADDRESSWIDTH {18} \
            CONFIG.NUM_MCP {4} \
            CONFIG.sys_clk1_BOARD_INTERFACE {ddr4_c1_sysclk} \
        ] [get_bd_cells $noc]
        for { set i 0 } { $i < $ports } { incr i 1 } {
            set_property -dict [list CONFIG.CONNECTIONS "MC_${i} {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}"] [get_bd_intf_pins /arch/ddr_noc/S0${i}_AXI]
            set_property -dict [list CONFIG.CONNECTIONS "MC_${i} {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}"] [get_bd_intf_pins /arch/ddr_noc/S0${i}_AXI]
            set_property -dict [list CONFIG.CONNECTIONS "MC_${i} {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}"] [get_bd_intf_pins /arch/ddr_noc/S0${i}_AXI]
            set_property -dict [list CONFIG.CONNECTIONS "MC_${i} {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}"] [get_bd_intf_pins /arch/ddr_noc/S0${i}_AXI]
        }
        set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /arch/ddr_noc/S00_INI]
        set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /arch/ddr_noc/S01_INI]
        apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {ddr4_sdram_c1 ( DDR4 SDRAM C1 RDIMMS ) } Manual_Source {Auto}}  [get_bd_intf_pins $noc/CH0_DDR4_0]
        apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {ddr4_c1_sysclk ( ddr4_c1_sysclk ) } Manual_Source {Auto}}  [get_bd_intf_pins $noc/sys_clk0]
        return $noc
    }

    proc remove_ports { pe unused } {
        set group [current_bd_instance .]
        delete_bd_objs [get_bd_intf_pins -of_objects $group -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0}]
    }

}

if {[tapasco::is_feature_enabled "suspmv"]} {
    tapasco::register_plugin "platform::suspmv::generate" "pre-wrapper"
    tapasco::register_plugin "platform::suspmv::remove_ports" "post-pe-create"
}
