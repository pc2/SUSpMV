# This is a plugin for TaPaSCo, which effects the PE AXI4-Master connections.
# It will instantiate the V80 HBM-NoC and DDR-NoC and connect the PE as desired.
# How to use:
#   1. Copy this plugin file to $TAPASCO_HOME_TOOLFLOW/vivado/platform/v80/plugins/
#   2. Run `tapasco --jobsFile job.json` using the job.json file from this directory.

namespace eval suspmv {

    variable clk
    variable rstn

    proc generate {} {
        configure_memory
        create_arch
    }

    proc configure_memory {} {
        delete_bd_objs [get_bd_intf_pins memory/M_ARCH]
        set_property -dict [list \
            CONFIG.NUM_MI {2} \
            CONFIG.NUM_NMI {2} \
        ] [get_bd_cells memory/axi_noc_0]

        # PCIe access to tapasco, pe, hbm, and ddr
        set_property -dict [list CONFIG.CONNECTIONS { \
            MC_0 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}} \
            M00_AXI {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}} \
            M01_AXI {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}} \
            M00_INI {read_bw {1} write_bw {1}} \
        }] [get_bd_intf_pins /memory/axi_noc_0/S06_AXI]
        set_property -dict [list CONFIG.CONNECTIONS { \
            MC_1 {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}} \
            M00_AXI {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}} \
            M01_AXI {read_bw {1} write_bw {1} read_avg_burst {4} write_avg_burst {4}} \
            M01_INI {read_bw {1} write_bw {1}} \
        }] [get_bd_intf_pins /memory/axi_noc_0/S07_AXI]

        create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 arch/HBM00_INI
        create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 arch/HBM01_INI


        set clk [get_bd_pin memory/design_clk]
        smartconnect sc_ctrl $clk [get_bd_intf_pins memory/axi_noc_0/M01_AXI] [get_bd_intf_pins arch/S_ARCH]
        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M00_INI] [get_bd_intf_pins arch/HBM00_INI]
        connect_bd_intf_net [get_bd_intf_pins memory/axi_noc_0/M01_INI] [get_bd_intf_pins arch/HBM01_INI]
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
        set pe [get_bd_cells /arch/target_ip_00_000/internal_target_ip_00_000]

        # create hbm
        set hbm_port_count 0
        while { [get_bd_intf_pins $pe/[format "maxi_hbm%02d" $hbm_port_count]] != "" } {
            incr hbm_port_count
        }
        puts "HBM ports: $hbm_port_count"
        set hbm [create_hbm_noc $hbm_port_count]

        # connect hbm
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
        # rest can be auto assigned
        assign_bd_address
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

    proc remove_ports { pe unused } {
        puts "suspmv::remove_ports"
        set pe [get_bd_cells $pe]
        set group [current_bd_instance .]

        # prevent hbm ports from being connected to ddr
        delete_bd_objs [get_bd_intf_pins $group/maxi_ddr01]
        delete_bd_objs [get_bd_intf_pins $group/maxi_ddr02]
        delete_bd_objs [get_bd_intf_pins $group/maxi_ddr03]
        set hbmports [get_bd_intf_pins -of_objects $group -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*hbm*"}]
        delete_bd_objs $hbmports
        save_bd_design
    }

}

if {[tapasco::is_feature_enabled "suspmv"]} {
    tapasco::register_plugin "platform::suspmv::generate" "pre-wrapper"
    tapasco::register_plugin "platform::suspmv::remove_ports" "post-pe-create"
}
