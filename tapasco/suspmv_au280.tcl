# This is a plugin for TaPaSCo, which effects the PE AXI4-Master connections.
# It will instantiate the AU280 HBM and connect the PE as desired.
# How to use:
#   1. Copy this plugin file to $TAPASCO_HOME_TOOLFLOW/vivado/platform/AU280/plugins/
#   2. Run `tapasco --jobsFile job_au280.json` using the job_au280.json file from this directory.

if {[tapasco::is_feature_enabled "suspmv"]} {
    proc create_custom_subsystem_hbm {{args {}}} {
        puts "suspmv::create_custom_subsystem_hbm"
        # create refclk
        current_bd_instance
        set hbm_ref_clk_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 hbm_ref_clk ]
        set_property CONFIG.FREQ_HZ 100000000 $hbm_ref_clk_0

        # create hbm core
        set pe [get_bd_cells /arch/target_ip_00_000/internal_target_ip_00_000]
        set ddrports [get_bd_intf_pins -of_objects $pe -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*ddr*"}]
        set hbmports [get_bd_intf_pins -of_objects $pe -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*hbm*"}]
        current_bd_instance /hbm
        suspmv::generate_hbm_core $ddrports $hbmports
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

    proc generate_hbm_core { ddrports hbmports } {
        puts "Generating HBM Core"

        # create and configure HBM IP
        set pe_ports [llength $hbmports]
        if { $pe_ports > 32 } {
            set pe_ports 32
        }
        set total_ports [expr $pe_ports + 1]
        if { $total_ports > 32 } {
            set total_ports 32
        }

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
		set hbmrst [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0]
        connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/HBM_REF_CLK_0]
        connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/APB_0_PCLK] [get_bd_pins $hbmrst/slowest_sync_clk]
        connect_bd_net [get_bd_pins /host/axi_pcie3_0/user_lnk_up] [get_bd_pins $hbmrst/ext_reset_in]
		connect_bd_net [get_bd_pins $hbmrst/peripheral_aresetn] [get_bd_pins $hbm/APB_0_PRESET_N]
        
        if {$bothStacks} {
            # clocking right stack
			set hbmrst [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1]
            connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/HBM_REF_CLK_1]
            connect_bd_net [get_bd_pins $ibuf/IBUF_OUT] [get_bd_pins $hbm/APB_1_PCLK] [get_bd_pins $hbmrst/slowest_sync_clk]
            connect_bd_net [get_bd_pins /host/axi_pcie3_0/user_lnk_up] [get_bd_pins $hbmrst/ext_reset_in]
			connect_bd_net [get_bd_pins $hbmrst/peripheral_aresetn] [get_bd_pins $hbm/APB_1_PRESET_N]
        }

        set aclk [get_bd_pins design_clk]
        set aresetn [get_bd_pins design_interconnect_aresetn]
        save_bd_design

        # connect PE hmb00-31
        set hbm_dma_index 20
        for {set i 0} {$i < 32} {incr i} {
            set master [lindex $hbmports $i]
            set hbm_index [format %02s $i]
            if { $i != $hbm_dma_index } {
                # connect PE and hmb
                connect_bd_net $aclk [get_bd_pins $hbm/AXI_${hbm_index}_ACLK]
                connect_bd_net $aresetn [get_bd_pins $hbm/AXI_${hbm_index}_ARESET_N]
                connect_bd_intf_net $master [get_bd_intf_pins $hbm/SAXI_${hbm_index}]
            } else {
                # connect PE, hmb and dma
                set converter [tapasco::ip::create_axi_ic converter_ic_dma 2 1]
                set dma_slave [get_bd_intf_pins $converter/S00_AXI]
                set dma_slave_clk [get_bd_pins $converter/S00_ACLK]
                set dma_slave_rst [get_bd_pins $converter/S00_ARESETN]
                connect_bd_net $aclk [get_bd_pins $converter/ACLK] [get_bd_pins $converter/M00_ACLK] [get_bd_pins $converter/S01_ACLK] [get_bd_pins $hbm/AXI_${hbm_index}_ACLK]
                connect_bd_net $aresetn [get_bd_pins $converter/ARESETN] [get_bd_pins $converter/M00_ARESETN] [get_bd_pins $converter/S01_ARESETN] [get_bd_pins $hbm/AXI_${hbm_index}_ARESET_N]
                connect_bd_intf_net [get_bd_intf_pins $converter/M00_AXI] [get_bd_intf_pins $hbm/SAXI_${hbm_index}]
                connect_bd_intf_net $master [get_bd_intf_pins $converter/S01_AXI]
            }
        }
        save_bd_design

        ####################
        # connect DMA engine

        # dma offset
        set dmaoffset [create_bd_cell -type ip -vlnv esa.informatik.tu-darmstadt.de:user:axi_generic_offset:0.1 dma_offset]
        set_property -dict [list \
            CONFIG.ADDRESS_WIDTH {35} \
            CONFIG.ID_WIDTH {1} \
            CONFIG.OVERWRITE_BITS {1} \
        ] $dmaoffset
        connect_bd_net [get_bd_pins mem_clk] [get_bd_pins $dmaoffset/aclk] $dma_slave_clk
        connect_bd_net [get_bd_pins mem_peripheral_aresetn] [get_bd_pins $dmaoffset/aresetn] $dma_slave_rst
        connect_bd_intf_net [get_bd_intf_pins $dmaoffset/M_AXI] $dma_slave

    	######
    	# DMA-HBM SLR Crossing
    	set slrreg [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 dma_hbm_slr_crossing]
	    set_property -dict [list \
		  CONFIG.REG_AR {10} \
		  CONFIG.REG_AW {10} \
		  CONFIG.REG_B {10} \
		  CONFIG.REG_R {10} \
		  CONFIG.REG_W {10} \
		] [get_bd_cells $slrreg]   
		connect_bd_intf_net [get_bd_intf_pins $slrreg/M_AXI] [get_bd_intf_pins $dmaoffset/S_AXI]
		connect_bd_net [get_bd_pins mem_clk] [get_bd_pins $slrreg/aclk]
		connect_bd_net [get_bd_pins mem_peripheral_aresetn] [get_bd_pins $slrreg/aresetn]
        save_bd_design

        # insert dma smartconnect
		set migic [get_bd_cells /memory/mig_ic]
        set_property -dict [list \
            CONFIG.NUM_SI {2} \
            CONFIG.NUM_MI {2} \
        ] $migic
        connect_bd_intf_net [get_bd_intf_pins $migic/M01_AXI] [get_bd_intf_pins $slrreg/S_AXI]
        save_bd_design

        ####################
        # address map
        assign_bd_address -target_address_space /memory/dma/m32_axi -offset 0x000000000 -range 16G [get_bd_addr_segs /memory/mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
        assign_bd_address -target_address_space /memory/dma/m32_axi -offset 0x400000000 -range 16G [get_bd_addr_segs /hbm/dma_offset/S_AXI/reg0] -force
        assign_bd_address -target_address_space /hbm/dma_offset/M_AXI [get_bd_addr_segs hbm/hbm_0/SAXI_31/] -force
        for {set i 0} {$i < $pe_ports} {incr i} {
            set hbm_index [format %02s $i]
            assign_bd_address -target_address_space /arch/target_ip_00_000/internal_target_ip_00_000/maxi_hbm${hbm_index} [get_bd_addr_segs hbm/hbm_0/SAXI_${hbm_index}/] -force
        }

        for {set k 0} {$k < [llength $ddrports]} {incr k} {
            set kk [format %02s $k]
            assign_bd_address -target_address_space /arch/target_ip_00_000/internal_target_ip_00_000/maxi_ddr${kk} [get_bd_addr_segs memory/mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
        }
        save_bd_design

        ####################
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
        puts "suspmv::addressmap"
        save_bd_design

        set pe [get_bd_cells /arch/target_ip_00_000/internal_target_ip_00_000]
        set ddrports [get_bd_intf_pins -of_objects $pe -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*ddr*"}]
        set hbmports [get_bd_intf_pins -of_objects $pe -filter {MODE == Master && VLNV == xilinx.com:interface:aximm_rtl:1.0 && NAME =~ "*hbm*"}]

        for {set i 0} {$i < [llength $ddrports] && $i < 4} {incr i} {
            set ddr_index [format %02s $i]
            set args [lappend args maxi_ddr${ddr_index} [list "skip" 0 -1 ""]]
        }
        for {set i 0} {$i < [llength $hbmports] && $i < 32} {incr i} {
            set hbm_index [format %02s $i]
            set args [lappend args maxi_hbm${hbm_index} [list "skip" 0 -1 ""]]
        }
        set args [lappend args M01_AXI [list "skip" 0 -1 ""]]

        puts $args
        return $args
    }

    proc aftermath {} {
	    current_bd_instance
        ########
        # slow clock for PE saxi ctrl
        create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 arch/axi_clock_converter_0
		delete_bd_objs [get_bd_intf_nets arch/S_ARCH_1]
		connect_bd_intf_net -boundary_type upper [get_bd_intf_pins arch/target_ip_00_000/s_axi_control] [get_bd_intf_pins arch/axi_clock_converter_0/M_AXI]
		connect_bd_intf_net [get_bd_intf_pins arch/S_ARCH] [get_bd_intf_pins arch/axi_clock_converter_0/S_AXI]
		connect_bd_net [get_bd_pins arch/host_clk] [get_bd_pins arch/axi_clock_converter_0/s_axi_aclk]
		connect_bd_net [get_bd_pins arch/host_interconnect_aresetn] [get_bd_pins arch/axi_clock_converter_0/s_axi_aresetn]
		connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins arch/axi_clock_converter_0/m_axi_aclk]
		connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins arch/axi_clock_converter_0/m_axi_aresetn]
		disconnect_bd_net /clocks_and_resets_design_clk [get_bd_pins regslice_host_arch/aclk]
		disconnect_bd_net /clocks_and_resets_design_interconnect_aresetn [get_bd_pins regslice_host_arch/aresetn]
		connect_bd_net [get_bd_pins regslice_host_arch/aclk] [get_bd_pins clocks_and_resets/host_clk]
		connect_bd_net [get_bd_pins regslice_host_arch/aresetn] [get_bd_pins clocks_and_resets/host_interconnect_aresetn]
        save_bd_design
        
    	######
    	# PE-DDR SLR Crossing
    	delete_bd_objs [get_bd_cells arch/out_0]
    	set slrreg [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 arch/ddr_slr_crossing]
	    set_property -dict [list \
		  CONFIG.REG_AR {10} \
		  CONFIG.REG_AW {10} \
		  CONFIG.REG_B {10} \
		  CONFIG.REG_R {10} \
		  CONFIG.REG_W {10} \
		] [get_bd_cells $slrreg]   
		connect_bd_intf_net -boundary_type upper [get_bd_intf_pins arch/target_ip_00_000/maxi_ddr00] [get_bd_intf_pins $slrreg/S_AXI]
		connect_bd_intf_net [get_bd_intf_pins arch/M_MEM_0] [get_bd_intf_pins $slrreg/M_AXI]
		connect_bd_net [get_bd_pins arch/design_clk] [get_bd_pins $slrreg/aclk]
		connect_bd_net [get_bd_pins arch/design_peripheral_aresetn] [get_bd_pins $slrreg/aresetn] 
        save_bd_design

        ##################
        # additional pblock constraints  
        set constraints "$::env(TAPASCO_HOME_TCL)/platform/AU280/plugins/suspmv.xdc"
        read_xdc $constraints
        set_property PROCESSING_ORDER EARLY [get_files $constraints]
        save_bd_design
		
		
        set config [tapasco::get_feature "suspmv"]
        if {[dict exists $config clocking]} {
	        dynamic_clock
        }
        
        assign_bd_address
    }

    proc parse_constraints_file {} {
        set config [tapasco::get_feature "suspmv"]
        if {[dict exists $config path]} {
            set path [dict get $config path]
            set file [file normalize $path]
            if {![file exists $file]} {
                puts "CustomConstraints: file $file does not exist"
                return
            }
            set constraints_file "[get_property DIRECTORY [current_project]]/[file tail $file]"
            file copy -force $file $constraints_file
            read_xdc $constraints_file
            set_property PROCESSING_ORDER LATE [get_files $constraints_file]
        }
    }
    
    proc dynamic_clock {} {
		set_property -dict [list \
		  CONFIG.AXI_DRP {false} \
		  CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {false} \
		  CONFIG.PHASE_DUTY_CONFIG {false} \
		  CONFIG.RESET_PORT {reset} \
		  CONFIG.RESET_TYPE {ACTIVE_HIGH} \
		  CONFIG.USE_DYN_RECONFIG {true} \
		] [get_bd_cells memory/design_clk_wiz]
		set_property CONFIG.NUM_MI {6} [get_bd_cells host/out_ic]
		delete_bd_objs [get_bd_nets memory/mig_c0_init_calib_complete]
		connect_bd_intf_net [get_bd_intf_pins host/out_ic/M05_AXI] [get_bd_intf_pins memory/design_clk_wiz/s_axi_lite]
		
		connect_bd_net [get_bd_pins memory/mig/c0_init_calib_complete] [get_bd_pins memory/design_clk_wiz/s_axi_aresetn]
		connect_bd_net [get_bd_pins memory/mig/c0_ddr4_ui_clk] [get_bd_pins memory/design_clk_wiz/s_axi_aclk]
		
		#connect_bd_net [get_bd_pins memory/design_clk_wiz/s_axi_aclk] [get_bd_pins clocks_and_resets/host_clk]
		#connect_bd_net [get_bd_pins memory/design_clk_wiz/s_axi_aresetn] [get_bd_pins clocks_and_resets/host_peripheral_aresetn]
        assign_bd_address -target_address_space /host/axi_pcie3_0/M_AXI_B -offset 0x1000000 -range 64K [get_bd_addr_segs {host/axi_pcie3_0/M_AXI_B/SEG_design_clk_wiz_Reg}] -force
        save_bd_design
    }


    proc add_debug_ilas {} {
        puts "suspmv::add_debug_ilas"

        create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_cvt_axi4
        set_property CONFIG.C_DATA_DEPTH {1024} [get_bd_cells ila_cvt_axi4]
        set_property CONFIG.C_INPUT_PIPE_STAGES {4} [get_bd_cells ila_cvt_axi4]
        create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_cvt_axi3
        set_property CONFIG.C_DATA_DEPTH {1024} [get_bd_cells ila_cvt_axi3]
        set_property CONFIG.C_INPUT_PIPE_STAGES {4} [get_bd_cells ila_cvt_axi3]
        connect_bd_intf_net [get_bd_intf_pins ila_cvt_axi3/SLOT_0_AXI] [get_bd_intf_pins hbm/hbm_0/SAXI_10]
        connect_bd_intf_net [get_bd_intf_pins ila_cvt_axi4/SLOT_0_AXI] [get_bd_intf_pins hbm/converter_10/S_AXI]
        connect_bd_net [get_bd_pins clocks_and_resets/design_clk] [get_bd_pins ila_cvt_axi3/clk]
        connect_bd_net [get_bd_pins clocks_and_resets/design_clk] [get_bd_pins ila_cvt_axi4/clk]
    }

    proc produce_ila_ltx {} {
        write_debug_probes ila_info.ltx
    }
}

if {[tapasco::is_feature_enabled "suspmv"]} {

    namespace eval ::platform {
        proc get_ignored_segments { } {
            puts "suspmv::get_ignored_segments"
            save_bd_design

            set ignored [list]
            for {set i 0} {$i < 32} {incr i} {
                for {set j 0} {$j < 32} {incr j} {
                    set axi_index [format %02s $i]
                    set mem_index [format %02s $j]
                    lappend ignored "/hbm/hbm_0/SAXI_${axi_index}/HBM_MEM${mem_index}"
                }
            }

            lappend ignored "/hbm/dma_offset/S_AXI/reg0"
            lappend ignored "/memory/mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK"

            return $ignored
        }
    }

    tapasco::register_plugin "platform::suspmv::remove_ports" "post-pe-create"
    tapasco::register_plugin "platform::suspmv::addressmap" "post-address-map"
    tapasco::register_plugin "platform::suspmv::aftermath" "pre-wrapper"
    tapasco::register_plugin "platform::suspmv::add_debug_ilas" "pre-wrapper"
    tapasco::register_plugin "platform::suspmv::parse_constraints_file" "pre-arch"
    tapasco::register_plugin "platform::suspmv::produce_ila_ltx" "post-bitstream"
}
