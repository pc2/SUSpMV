`include "matrix_params.vh"

`define X_VEC_START_ADDR 64'h00000000_00000000
`define Y_VEC_START_ADDR 64'h00000000_01000000

// Testbench for module SUSpMV_Full #()
module SUSpMV_Full_tb;
	// Clocks
	logic aclk = 0;
	initial #0 forever #5 aclk = !aclk;

	// Ports
	// {aclk} input bool #() aresetn'1000
	logic aresetn;
	// {aclk} input int #(FROM: 0, TO: 4096) s_axi_control_awaddr'2000
	logic[11:0] s_axi_control_awaddr;
	// {aclk} input bool #() s_axi_control_awvalid'2000
	logic s_axi_control_awvalid;
	// {aclk} output bool #() s_axi_control_awready'2000
	wire s_axi_control_awready;
	// {aclk} input bool #()[3] s_axi_control_awprot'2000
	logic[2:0] s_axi_control_awprot;
	// {aclk} input bool #()[64] s_axi_control_wdata'2000
	logic[63:0] s_axi_control_wdata;
	// {aclk} input bool #()[8] s_axi_control_wstrb'2000
	logic[7:0] s_axi_control_wstrb;
	// {aclk} input bool #() s_axi_control_wvalid'2000
	logic s_axi_control_wvalid;
	// {aclk} output bool #() s_axi_control_wready'2000
	wire s_axi_control_wready;
	// {aclk} output bool #()[2] s_axi_control_bresp'2000
	wire[1:0] s_axi_control_bresp;
	// {aclk} output bool #() s_axi_control_bvalid'2000
	wire s_axi_control_bvalid;
	// {aclk} input bool #() s_axi_control_bready'2000
	logic s_axi_control_bready;
	// {aclk} input int #(FROM: 0, TO: 4096) s_axi_control_araddr'2000
	logic[11:0] s_axi_control_araddr;
	// {aclk} input bool #() s_axi_control_arvalid'2000
	logic s_axi_control_arvalid;
	// {aclk} output bool #() s_axi_control_arready'2000
	wire s_axi_control_arready;
	// {aclk} input bool #()[3] s_axi_control_arprot'2000
	logic[2:0] s_axi_control_arprot;
	// {aclk} output bool #()[64] s_axi_control_rdata'2000
	wire[63:0] s_axi_control_rdata;
	// {aclk} output bool #()[2] s_axi_control_rresp'2000
	wire[1:0] s_axi_control_rresp;
	// {aclk} output bool #() s_axi_control_rvalid'2000
	wire s_axi_control_rvalid;
	// {aclk} input bool #() s_axi_control_rready'2000
	logic s_axi_control_rready;
	// {aclk} output bool #() intr'2000
	wire intr;
	// {aclk} output bool #() maxi_ddr00_awvalid'3000
	wire maxi_ddr00_awvalid;
	// {aclk} input bool #() maxi_ddr00_awready'3000
	logic maxi_ddr00_awready;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_ddr00_awaddr'3000
	wire[63:0] maxi_ddr00_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_ddr00_awlen'3000
	wire[7:0] maxi_ddr00_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_ddr00_awsize'3000
	wire[2:0] maxi_ddr00_awsize;
	// {aclk} output bool #()[2] maxi_ddr00_awburst'3000
	wire[1:0] maxi_ddr00_awburst;
	// {aclk} output bool #()[3] maxi_ddr00_awprot'3000
	wire[2:0] maxi_ddr00_awprot;
	// {aclk} output bool #()[4] maxi_ddr00_awcache'3000
	wire[3:0] maxi_ddr00_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_ddr00_awqos'3000
	wire[3:0] maxi_ddr00_awqos;
	// {aclk} output bool #() maxi_ddr00_awlock'3000
	wire maxi_ddr00_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_ddr00_awregion'3000
	wire[3:0] maxi_ddr00_awregion;
	// {aclk} output bool #() maxi_ddr00_wvalid'3000
	wire maxi_ddr00_wvalid;
	// {aclk} input bool #() maxi_ddr00_wready'3000
	logic maxi_ddr00_wready;
	// {aclk} output bool #()[512] maxi_ddr00_wdata'3000
	wire[511:0] maxi_ddr00_wdata;
	// {aclk} output bool #()[64] maxi_ddr00_wstrb'3000
	wire[63:0] maxi_ddr00_wstrb;
	// {aclk} output bool #() maxi_ddr00_wlast'3000
	wire maxi_ddr00_wlast;
	// {aclk} input bool #() maxi_ddr00_bvalid'3000
	logic maxi_ddr00_bvalid;
	// {aclk} output bool #() maxi_ddr00_bready'3000
	wire maxi_ddr00_bready;
	// {aclk} input bool #()[2] maxi_ddr00_bresp'3000
	logic[1:0] maxi_ddr00_bresp;
	// {aclk} output bool #() maxi_ddr00_arvalid'0
	wire maxi_ddr00_arvalid;
	// {aclk} input bool #() maxi_ddr00_arready'0
	logic maxi_ddr00_arready;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_ddr00_araddr'0
	wire[63:0] maxi_ddr00_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_ddr00_arlen'0
	wire[7:0] maxi_ddr00_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_ddr00_arsize'0
	wire[2:0] maxi_ddr00_arsize;
	// {aclk} output bool #()[2] maxi_ddr00_arburst'0
	wire[1:0] maxi_ddr00_arburst;
	// {aclk} output bool #()[3] maxi_ddr00_arprot'0
	wire[2:0] maxi_ddr00_arprot;
	// {aclk} output bool #()[4] maxi_ddr00_arcache'0
	wire[3:0] maxi_ddr00_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_ddr00_arqos'0
	wire[3:0] maxi_ddr00_arqos;
	// {aclk} output bool #() maxi_ddr00_arlock'0
	wire maxi_ddr00_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_ddr00_arregion'0
	wire[3:0] maxi_ddr00_arregion;
	// {aclk} input bool #() maxi_ddr00_rvalid'0
	logic maxi_ddr00_rvalid;
	// {aclk} output bool #() maxi_ddr00_rready'0
	wire maxi_ddr00_rready;
	// {aclk} input bool #()[512] maxi_ddr00_rdata'0
	logic[511:0] maxi_ddr00_rdata;
	// {aclk} input bool #()[2] maxi_ddr00_rresp'0
	logic[1:0] maxi_ddr00_rresp;
	// {aclk} input bool #() maxi_ddr00_rlast'0
	logic maxi_ddr00_rlast;

		// HBM00
	// {aclk} output bool #() maxi_hbm00_awvalid'0
	wire maxi_hbm00_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm00_awaddr'0
	wire[63:0] maxi_hbm00_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm00_awlen'0
	wire[7:0] maxi_hbm00_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm00_awsize'0
	wire[2:0] maxi_hbm00_awsize;
	// {aclk} output bool #()[2] maxi_hbm00_awburst'0
	wire[1:0] maxi_hbm00_awburst;
	// {aclk} output bool #()[3] maxi_hbm00_awprot'0
	wire[2:0] maxi_hbm00_awprot;
	// {aclk} output bool #()[4] maxi_hbm00_awcache'0
	wire[3:0] maxi_hbm00_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm00_awqos'0
	wire[3:0] maxi_hbm00_awqos;
	// {aclk} output bool #() maxi_hbm00_awlock'0
	wire maxi_hbm00_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm00_awregion'0
	wire[3:0] maxi_hbm00_awregion;
	// {aclk} output bool #() maxi_hbm00_wvalid'0
	wire maxi_hbm00_wvalid;
	// {aclk} output bool #()[256] maxi_hbm00_wdata'0
	wire[255:0] maxi_hbm00_wdata;
	// {aclk} output bool #()[32] maxi_hbm00_wstrb'0
	wire[31:0] maxi_hbm00_wstrb;
	// {aclk} output bool #() maxi_hbm00_wlast'0
	wire maxi_hbm00_wlast;
	// {aclk} output bool #() maxi_hbm00_bready'0
	wire maxi_hbm00_bready;
	// {aclk} input bool #() maxi_hbm00_wready'0
	logic maxi_hbm00_wready;
	// {aclk} input bool #() maxi_hbm00_bvalid'0
	logic maxi_hbm00_bvalid;
	// {aclk} input bool #()[2] maxi_hbm00_bresp'0
	logic[1:0] maxi_hbm00_bresp;
	// {aclk} input bool #() maxi_hbm00_awready'0
	logic maxi_hbm00_awready;
	// {aclk} output bool #() maxi_hbm00_arvalid'0
	wire maxi_hbm00_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm00_araddr'0
	wire[63:0] maxi_hbm00_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm00_arlen'0
	wire[7:0] maxi_hbm00_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm00_arsize'0
	wire[2:0] maxi_hbm00_arsize;
	// {aclk} output bool #()[2] maxi_hbm00_arburst'0
	wire[1:0] maxi_hbm00_arburst;
	// {aclk} output bool #()[3] maxi_hbm00_arprot'0
	wire[2:0] maxi_hbm00_arprot;
	// {aclk} output bool #()[4] maxi_hbm00_arcache'0
	wire[3:0] maxi_hbm00_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm00_arqos'0
	wire[3:0] maxi_hbm00_arqos;
	// {aclk} output bool #() maxi_hbm00_arlock'0
	wire maxi_hbm00_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm00_arregion'0
	wire[3:0] maxi_hbm00_arregion;
	// {aclk} output bool #() maxi_hbm00_rready'0
	wire maxi_hbm00_rready;
	// {aclk} input bool #() maxi_hbm00_arready'0
	logic maxi_hbm00_arready;
	// {aclk} input bool #() maxi_hbm00_rvalid'0
	logic maxi_hbm00_rvalid;
	// {aclk} input bool #()[256] maxi_hbm00_rdata'0
	logic[255:0] maxi_hbm00_rdata;
	// {aclk} input bool #()[2] maxi_hbm00_rresp'0
	logic[1:0] maxi_hbm00_rresp;
	// {aclk} input bool #() maxi_hbm00_rlast'0
	logic maxi_hbm00_rlast;
	// HBM01
	// {aclk} output bool #() maxi_hbm01_awvalid'0
	wire maxi_hbm01_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm01_awaddr'0
	wire[63:0] maxi_hbm01_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm01_awlen'0
	wire[7:0] maxi_hbm01_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm01_awsize'0
	wire[2:0] maxi_hbm01_awsize;
	// {aclk} output bool #()[2] maxi_hbm01_awburst'0
	wire[1:0] maxi_hbm01_awburst;
	// {aclk} output bool #()[3] maxi_hbm01_awprot'0
	wire[2:0] maxi_hbm01_awprot;
	// {aclk} output bool #()[4] maxi_hbm01_awcache'0
	wire[3:0] maxi_hbm01_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm01_awqos'0
	wire[3:0] maxi_hbm01_awqos;
	// {aclk} output bool #() maxi_hbm01_awlock'0
	wire maxi_hbm01_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm01_awregion'0
	wire[3:0] maxi_hbm01_awregion;
	// {aclk} output bool #() maxi_hbm01_wvalid'0
	wire maxi_hbm01_wvalid;
	// {aclk} output bool #()[256] maxi_hbm01_wdata'0
	wire[255:0] maxi_hbm01_wdata;
	// {aclk} output bool #()[32] maxi_hbm01_wstrb'0
	wire[31:0] maxi_hbm01_wstrb;
	// {aclk} output bool #() maxi_hbm01_wlast'0
	wire maxi_hbm01_wlast;
	// {aclk} output bool #() maxi_hbm01_bready'0
	wire maxi_hbm01_bready;
	// {aclk} input bool #() maxi_hbm01_wready'0
	logic maxi_hbm01_wready;
	// {aclk} input bool #() maxi_hbm01_bvalid'0
	logic maxi_hbm01_bvalid;
	// {aclk} input bool #()[2] maxi_hbm01_bresp'0
	logic[1:0] maxi_hbm01_bresp;
	// {aclk} input bool #() maxi_hbm01_awready'0
	logic maxi_hbm01_awready;
	// {aclk} output bool #() maxi_hbm01_arvalid'0
	wire maxi_hbm01_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm01_araddr'0
	wire[63:0] maxi_hbm01_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm01_arlen'0
	wire[7:0] maxi_hbm01_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm01_arsize'0
	wire[2:0] maxi_hbm01_arsize;
	// {aclk} output bool #()[2] maxi_hbm01_arburst'0
	wire[1:0] maxi_hbm01_arburst;
	// {aclk} output bool #()[3] maxi_hbm01_arprot'0
	wire[2:0] maxi_hbm01_arprot;
	// {aclk} output bool #()[4] maxi_hbm01_arcache'0
	wire[3:0] maxi_hbm01_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm01_arqos'0
	wire[3:0] maxi_hbm01_arqos;
	// {aclk} output bool #() maxi_hbm01_arlock'0
	wire maxi_hbm01_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm01_arregion'0
	wire[3:0] maxi_hbm01_arregion;
	// {aclk} output bool #() maxi_hbm01_rready'0
	wire maxi_hbm01_rready;
	// {aclk} input bool #() maxi_hbm01_arready'0
	logic maxi_hbm01_arready;
	// {aclk} input bool #() maxi_hbm01_rvalid'0
	logic maxi_hbm01_rvalid;
	// {aclk} input bool #()[256] maxi_hbm01_rdata'0
	logic[255:0] maxi_hbm01_rdata;
	// {aclk} input bool #()[2] maxi_hbm01_rresp'0
	logic[1:0] maxi_hbm01_rresp;
	// {aclk} input bool #() maxi_hbm01_rlast'0
	logic maxi_hbm01_rlast;
	// HBM02
	// {aclk} output bool #() maxi_hbm02_awvalid'0
	wire maxi_hbm02_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm02_awaddr'0
	wire[63:0] maxi_hbm02_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm02_awlen'0
	wire[7:0] maxi_hbm02_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm02_awsize'0
	wire[2:0] maxi_hbm02_awsize;
	// {aclk} output bool #()[2] maxi_hbm02_awburst'0
	wire[1:0] maxi_hbm02_awburst;
	// {aclk} output bool #()[3] maxi_hbm02_awprot'0
	wire[2:0] maxi_hbm02_awprot;
	// {aclk} output bool #()[4] maxi_hbm02_awcache'0
	wire[3:0] maxi_hbm02_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm02_awqos'0
	wire[3:0] maxi_hbm02_awqos;
	// {aclk} output bool #() maxi_hbm02_awlock'0
	wire maxi_hbm02_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm02_awregion'0
	wire[3:0] maxi_hbm02_awregion;
	// {aclk} output bool #() maxi_hbm02_wvalid'0
	wire maxi_hbm02_wvalid;
	// {aclk} output bool #()[256] maxi_hbm02_wdata'0
	wire[255:0] maxi_hbm02_wdata;
	// {aclk} output bool #()[32] maxi_hbm02_wstrb'0
	wire[31:0] maxi_hbm02_wstrb;
	// {aclk} output bool #() maxi_hbm02_wlast'0
	wire maxi_hbm02_wlast;
	// {aclk} output bool #() maxi_hbm02_bready'0
	wire maxi_hbm02_bready;
	// {aclk} input bool #() maxi_hbm02_wready'0
	logic maxi_hbm02_wready;
	// {aclk} input bool #() maxi_hbm02_bvalid'0
	logic maxi_hbm02_bvalid;
	// {aclk} input bool #()[2] maxi_hbm02_bresp'0
	logic[1:0] maxi_hbm02_bresp;
	// {aclk} input bool #() maxi_hbm02_awready'0
	logic maxi_hbm02_awready;
	// {aclk} output bool #() maxi_hbm02_arvalid'0
	wire maxi_hbm02_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm02_araddr'0
	wire[63:0] maxi_hbm02_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm02_arlen'0
	wire[7:0] maxi_hbm02_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm02_arsize'0
	wire[2:0] maxi_hbm02_arsize;
	// {aclk} output bool #()[2] maxi_hbm02_arburst'0
	wire[1:0] maxi_hbm02_arburst;
	// {aclk} output bool #()[3] maxi_hbm02_arprot'0
	wire[2:0] maxi_hbm02_arprot;
	// {aclk} output bool #()[4] maxi_hbm02_arcache'0
	wire[3:0] maxi_hbm02_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm02_arqos'0
	wire[3:0] maxi_hbm02_arqos;
	// {aclk} output bool #() maxi_hbm02_arlock'0
	wire maxi_hbm02_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm02_arregion'0
	wire[3:0] maxi_hbm02_arregion;
	// {aclk} output bool #() maxi_hbm02_rready'0
	wire maxi_hbm02_rready;
	// {aclk} input bool #() maxi_hbm02_arready'0
	logic maxi_hbm02_arready;
	// {aclk} input bool #() maxi_hbm02_rvalid'0
	logic maxi_hbm02_rvalid;
	// {aclk} input bool #()[256] maxi_hbm02_rdata'0
	logic[255:0] maxi_hbm02_rdata;
	// {aclk} input bool #()[2] maxi_hbm02_rresp'0
	logic[1:0] maxi_hbm02_rresp;
	// {aclk} input bool #() maxi_hbm02_rlast'0
	logic maxi_hbm02_rlast;
	// HBM03
	// {aclk} output bool #() maxi_hbm03_awvalid'0
	wire maxi_hbm03_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm03_awaddr'0
	wire[63:0] maxi_hbm03_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm03_awlen'0
	wire[7:0] maxi_hbm03_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm03_awsize'0
	wire[2:0] maxi_hbm03_awsize;
	// {aclk} output bool #()[2] maxi_hbm03_awburst'0
	wire[1:0] maxi_hbm03_awburst;
	// {aclk} output bool #()[3] maxi_hbm03_awprot'0
	wire[2:0] maxi_hbm03_awprot;
	// {aclk} output bool #()[4] maxi_hbm03_awcache'0
	wire[3:0] maxi_hbm03_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm03_awqos'0
	wire[3:0] maxi_hbm03_awqos;
	// {aclk} output bool #() maxi_hbm03_awlock'0
	wire maxi_hbm03_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm03_awregion'0
	wire[3:0] maxi_hbm03_awregion;
	// {aclk} output bool #() maxi_hbm03_wvalid'0
	wire maxi_hbm03_wvalid;
	// {aclk} output bool #()[256] maxi_hbm03_wdata'0
	wire[255:0] maxi_hbm03_wdata;
	// {aclk} output bool #()[32] maxi_hbm03_wstrb'0
	wire[31:0] maxi_hbm03_wstrb;
	// {aclk} output bool #() maxi_hbm03_wlast'0
	wire maxi_hbm03_wlast;
	// {aclk} output bool #() maxi_hbm03_bready'0
	wire maxi_hbm03_bready;
	// {aclk} input bool #() maxi_hbm03_wready'0
	logic maxi_hbm03_wready;
	// {aclk} input bool #() maxi_hbm03_bvalid'0
	logic maxi_hbm03_bvalid;
	// {aclk} input bool #()[2] maxi_hbm03_bresp'0
	logic[1:0] maxi_hbm03_bresp;
	// {aclk} input bool #() maxi_hbm03_awready'0
	logic maxi_hbm03_awready;
	// {aclk} output bool #() maxi_hbm03_arvalid'0
	wire maxi_hbm03_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm03_araddr'0
	wire[63:0] maxi_hbm03_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm03_arlen'0
	wire[7:0] maxi_hbm03_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm03_arsize'0
	wire[2:0] maxi_hbm03_arsize;
	// {aclk} output bool #()[2] maxi_hbm03_arburst'0
	wire[1:0] maxi_hbm03_arburst;
	// {aclk} output bool #()[3] maxi_hbm03_arprot'0
	wire[2:0] maxi_hbm03_arprot;
	// {aclk} output bool #()[4] maxi_hbm03_arcache'0
	wire[3:0] maxi_hbm03_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm03_arqos'0
	wire[3:0] maxi_hbm03_arqos;
	// {aclk} output bool #() maxi_hbm03_arlock'0
	wire maxi_hbm03_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm03_arregion'0
	wire[3:0] maxi_hbm03_arregion;
	// {aclk} output bool #() maxi_hbm03_rready'0
	wire maxi_hbm03_rready;
	// {aclk} input bool #() maxi_hbm03_arready'0
	logic maxi_hbm03_arready;
	// {aclk} input bool #() maxi_hbm03_rvalid'0
	logic maxi_hbm03_rvalid;
	// {aclk} input bool #()[256] maxi_hbm03_rdata'0
	logic[255:0] maxi_hbm03_rdata;
	// {aclk} input bool #()[2] maxi_hbm03_rresp'0
	logic[1:0] maxi_hbm03_rresp;
	// {aclk} input bool #() maxi_hbm03_rlast'0
	logic maxi_hbm03_rlast;
	// HBM04
	// {aclk} output bool #() maxi_hbm04_awvalid'0
	wire maxi_hbm04_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm04_awaddr'0
	wire[63:0] maxi_hbm04_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm04_awlen'0
	wire[7:0] maxi_hbm04_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm04_awsize'0
	wire[2:0] maxi_hbm04_awsize;
	// {aclk} output bool #()[2] maxi_hbm04_awburst'0
	wire[1:0] maxi_hbm04_awburst;
	// {aclk} output bool #()[3] maxi_hbm04_awprot'0
	wire[2:0] maxi_hbm04_awprot;
	// {aclk} output bool #()[4] maxi_hbm04_awcache'0
	wire[3:0] maxi_hbm04_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm04_awqos'0
	wire[3:0] maxi_hbm04_awqos;
	// {aclk} output bool #() maxi_hbm04_awlock'0
	wire maxi_hbm04_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm04_awregion'0
	wire[3:0] maxi_hbm04_awregion;
	// {aclk} output bool #() maxi_hbm04_wvalid'0
	wire maxi_hbm04_wvalid;
	// {aclk} output bool #()[256] maxi_hbm04_wdata'0
	wire[255:0] maxi_hbm04_wdata;
	// {aclk} output bool #()[32] maxi_hbm04_wstrb'0
	wire[31:0] maxi_hbm04_wstrb;
	// {aclk} output bool #() maxi_hbm04_wlast'0
	wire maxi_hbm04_wlast;
	// {aclk} output bool #() maxi_hbm04_bready'0
	wire maxi_hbm04_bready;
	// {aclk} input bool #() maxi_hbm04_wready'0
	logic maxi_hbm04_wready;
	// {aclk} input bool #() maxi_hbm04_bvalid'0
	logic maxi_hbm04_bvalid;
	// {aclk} input bool #()[2] maxi_hbm04_bresp'0
	logic[1:0] maxi_hbm04_bresp;
	// {aclk} input bool #() maxi_hbm04_awready'0
	logic maxi_hbm04_awready;
	// {aclk} output bool #() maxi_hbm04_arvalid'0
	wire maxi_hbm04_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm04_araddr'0
	wire[63:0] maxi_hbm04_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm04_arlen'0
	wire[7:0] maxi_hbm04_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm04_arsize'0
	wire[2:0] maxi_hbm04_arsize;
	// {aclk} output bool #()[2] maxi_hbm04_arburst'0
	wire[1:0] maxi_hbm04_arburst;
	// {aclk} output bool #()[3] maxi_hbm04_arprot'0
	wire[2:0] maxi_hbm04_arprot;
	// {aclk} output bool #()[4] maxi_hbm04_arcache'0
	wire[3:0] maxi_hbm04_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm04_arqos'0
	wire[3:0] maxi_hbm04_arqos;
	// {aclk} output bool #() maxi_hbm04_arlock'0
	wire maxi_hbm04_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm04_arregion'0
	wire[3:0] maxi_hbm04_arregion;
	// {aclk} output bool #() maxi_hbm04_rready'0
	wire maxi_hbm04_rready;
	// {aclk} input bool #() maxi_hbm04_arready'0
	logic maxi_hbm04_arready;
	// {aclk} input bool #() maxi_hbm04_rvalid'0
	logic maxi_hbm04_rvalid;
	// {aclk} input bool #()[256] maxi_hbm04_rdata'0
	logic[255:0] maxi_hbm04_rdata;
	// {aclk} input bool #()[2] maxi_hbm04_rresp'0
	logic[1:0] maxi_hbm04_rresp;
	// {aclk} input bool #() maxi_hbm04_rlast'0
	logic maxi_hbm04_rlast;
	// HBM05
	// {aclk} output bool #() maxi_hbm05_awvalid'0
	wire maxi_hbm05_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm05_awaddr'0
	wire[63:0] maxi_hbm05_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm05_awlen'0
	wire[7:0] maxi_hbm05_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm05_awsize'0
	wire[2:0] maxi_hbm05_awsize;
	// {aclk} output bool #()[2] maxi_hbm05_awburst'0
	wire[1:0] maxi_hbm05_awburst;
	// {aclk} output bool #()[3] maxi_hbm05_awprot'0
	wire[2:0] maxi_hbm05_awprot;
	// {aclk} output bool #()[4] maxi_hbm05_awcache'0
	wire[3:0] maxi_hbm05_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm05_awqos'0
	wire[3:0] maxi_hbm05_awqos;
	// {aclk} output bool #() maxi_hbm05_awlock'0
	wire maxi_hbm05_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm05_awregion'0
	wire[3:0] maxi_hbm05_awregion;
	// {aclk} output bool #() maxi_hbm05_wvalid'0
	wire maxi_hbm05_wvalid;
	// {aclk} output bool #()[256] maxi_hbm05_wdata'0
	wire[255:0] maxi_hbm05_wdata;
	// {aclk} output bool #()[32] maxi_hbm05_wstrb'0
	wire[31:0] maxi_hbm05_wstrb;
	// {aclk} output bool #() maxi_hbm05_wlast'0
	wire maxi_hbm05_wlast;
	// {aclk} output bool #() maxi_hbm05_bready'0
	wire maxi_hbm05_bready;
	// {aclk} input bool #() maxi_hbm05_wready'0
	logic maxi_hbm05_wready;
	// {aclk} input bool #() maxi_hbm05_bvalid'0
	logic maxi_hbm05_bvalid;
	// {aclk} input bool #()[2] maxi_hbm05_bresp'0
	logic[1:0] maxi_hbm05_bresp;
	// {aclk} input bool #() maxi_hbm05_awready'0
	logic maxi_hbm05_awready;
	// {aclk} output bool #() maxi_hbm05_arvalid'0
	wire maxi_hbm05_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm05_araddr'0
	wire[63:0] maxi_hbm05_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm05_arlen'0
	wire[7:0] maxi_hbm05_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm05_arsize'0
	wire[2:0] maxi_hbm05_arsize;
	// {aclk} output bool #()[2] maxi_hbm05_arburst'0
	wire[1:0] maxi_hbm05_arburst;
	// {aclk} output bool #()[3] maxi_hbm05_arprot'0
	wire[2:0] maxi_hbm05_arprot;
	// {aclk} output bool #()[4] maxi_hbm05_arcache'0
	wire[3:0] maxi_hbm05_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm05_arqos'0
	wire[3:0] maxi_hbm05_arqos;
	// {aclk} output bool #() maxi_hbm05_arlock'0
	wire maxi_hbm05_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm05_arregion'0
	wire[3:0] maxi_hbm05_arregion;
	// {aclk} output bool #() maxi_hbm05_rready'0
	wire maxi_hbm05_rready;
	// {aclk} input bool #() maxi_hbm05_arready'0
	logic maxi_hbm05_arready;
	// {aclk} input bool #() maxi_hbm05_rvalid'0
	logic maxi_hbm05_rvalid;
	// {aclk} input bool #()[256] maxi_hbm05_rdata'0
	logic[255:0] maxi_hbm05_rdata;
	// {aclk} input bool #()[2] maxi_hbm05_rresp'0
	logic[1:0] maxi_hbm05_rresp;
	// {aclk} input bool #() maxi_hbm05_rlast'0
	logic maxi_hbm05_rlast;
	// HBM06
	// {aclk} output bool #() maxi_hbm06_awvalid'0
	wire maxi_hbm06_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm06_awaddr'0
	wire[63:0] maxi_hbm06_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm06_awlen'0
	wire[7:0] maxi_hbm06_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm06_awsize'0
	wire[2:0] maxi_hbm06_awsize;
	// {aclk} output bool #()[2] maxi_hbm06_awburst'0
	wire[1:0] maxi_hbm06_awburst;
	// {aclk} output bool #()[3] maxi_hbm06_awprot'0
	wire[2:0] maxi_hbm06_awprot;
	// {aclk} output bool #()[4] maxi_hbm06_awcache'0
	wire[3:0] maxi_hbm06_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm06_awqos'0
	wire[3:0] maxi_hbm06_awqos;
	// {aclk} output bool #() maxi_hbm06_awlock'0
	wire maxi_hbm06_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm06_awregion'0
	wire[3:0] maxi_hbm06_awregion;
	// {aclk} output bool #() maxi_hbm06_wvalid'0
	wire maxi_hbm06_wvalid;
	// {aclk} output bool #()[256] maxi_hbm06_wdata'0
	wire[255:0] maxi_hbm06_wdata;
	// {aclk} output bool #()[32] maxi_hbm06_wstrb'0
	wire[31:0] maxi_hbm06_wstrb;
	// {aclk} output bool #() maxi_hbm06_wlast'0
	wire maxi_hbm06_wlast;
	// {aclk} output bool #() maxi_hbm06_bready'0
	wire maxi_hbm06_bready;
	// {aclk} input bool #() maxi_hbm06_wready'0
	logic maxi_hbm06_wready;
	// {aclk} input bool #() maxi_hbm06_bvalid'0
	logic maxi_hbm06_bvalid;
	// {aclk} input bool #()[2] maxi_hbm06_bresp'0
	logic[1:0] maxi_hbm06_bresp;
	// {aclk} input bool #() maxi_hbm06_awready'0
	logic maxi_hbm06_awready;
	// {aclk} output bool #() maxi_hbm06_arvalid'0
	wire maxi_hbm06_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm06_araddr'0
	wire[63:0] maxi_hbm06_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm06_arlen'0
	wire[7:0] maxi_hbm06_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm06_arsize'0
	wire[2:0] maxi_hbm06_arsize;
	// {aclk} output bool #()[2] maxi_hbm06_arburst'0
	wire[1:0] maxi_hbm06_arburst;
	// {aclk} output bool #()[3] maxi_hbm06_arprot'0
	wire[2:0] maxi_hbm06_arprot;
	// {aclk} output bool #()[4] maxi_hbm06_arcache'0
	wire[3:0] maxi_hbm06_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm06_arqos'0
	wire[3:0] maxi_hbm06_arqos;
	// {aclk} output bool #() maxi_hbm06_arlock'0
	wire maxi_hbm06_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm06_arregion'0
	wire[3:0] maxi_hbm06_arregion;
	// {aclk} output bool #() maxi_hbm06_rready'0
	wire maxi_hbm06_rready;
	// {aclk} input bool #() maxi_hbm06_arready'0
	logic maxi_hbm06_arready;
	// {aclk} input bool #() maxi_hbm06_rvalid'0
	logic maxi_hbm06_rvalid;
	// {aclk} input bool #()[256] maxi_hbm06_rdata'0
	logic[255:0] maxi_hbm06_rdata;
	// {aclk} input bool #()[2] maxi_hbm06_rresp'0
	logic[1:0] maxi_hbm06_rresp;
	// {aclk} input bool #() maxi_hbm06_rlast'0
	logic maxi_hbm06_rlast;
	// HBM07
	// {aclk} output bool #() maxi_hbm07_awvalid'0
	wire maxi_hbm07_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm07_awaddr'0
	wire[63:0] maxi_hbm07_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm07_awlen'0
	wire[7:0] maxi_hbm07_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm07_awsize'0
	wire[2:0] maxi_hbm07_awsize;
	// {aclk} output bool #()[2] maxi_hbm07_awburst'0
	wire[1:0] maxi_hbm07_awburst;
	// {aclk} output bool #()[3] maxi_hbm07_awprot'0
	wire[2:0] maxi_hbm07_awprot;
	// {aclk} output bool #()[4] maxi_hbm07_awcache'0
	wire[3:0] maxi_hbm07_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm07_awqos'0
	wire[3:0] maxi_hbm07_awqos;
	// {aclk} output bool #() maxi_hbm07_awlock'0
	wire maxi_hbm07_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm07_awregion'0
	wire[3:0] maxi_hbm07_awregion;
	// {aclk} output bool #() maxi_hbm07_wvalid'0
	wire maxi_hbm07_wvalid;
	// {aclk} output bool #()[256] maxi_hbm07_wdata'0
	wire[255:0] maxi_hbm07_wdata;
	// {aclk} output bool #()[32] maxi_hbm07_wstrb'0
	wire[31:0] maxi_hbm07_wstrb;
	// {aclk} output bool #() maxi_hbm07_wlast'0
	wire maxi_hbm07_wlast;
	// {aclk} output bool #() maxi_hbm07_bready'0
	wire maxi_hbm07_bready;
	// {aclk} input bool #() maxi_hbm07_wready'0
	logic maxi_hbm07_wready;
	// {aclk} input bool #() maxi_hbm07_bvalid'0
	logic maxi_hbm07_bvalid;
	// {aclk} input bool #()[2] maxi_hbm07_bresp'0
	logic[1:0] maxi_hbm07_bresp;
	// {aclk} input bool #() maxi_hbm07_awready'0
	logic maxi_hbm07_awready;
	// {aclk} output bool #() maxi_hbm07_arvalid'0
	wire maxi_hbm07_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm07_araddr'0
	wire[63:0] maxi_hbm07_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm07_arlen'0
	wire[7:0] maxi_hbm07_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm07_arsize'0
	wire[2:0] maxi_hbm07_arsize;
	// {aclk} output bool #()[2] maxi_hbm07_arburst'0
	wire[1:0] maxi_hbm07_arburst;
	// {aclk} output bool #()[3] maxi_hbm07_arprot'0
	wire[2:0] maxi_hbm07_arprot;
	// {aclk} output bool #()[4] maxi_hbm07_arcache'0
	wire[3:0] maxi_hbm07_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm07_arqos'0
	wire[3:0] maxi_hbm07_arqos;
	// {aclk} output bool #() maxi_hbm07_arlock'0
	wire maxi_hbm07_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm07_arregion'0
	wire[3:0] maxi_hbm07_arregion;
	// {aclk} output bool #() maxi_hbm07_rready'0
	wire maxi_hbm07_rready;
	// {aclk} input bool #() maxi_hbm07_arready'0
	logic maxi_hbm07_arready;
	// {aclk} input bool #() maxi_hbm07_rvalid'0
	logic maxi_hbm07_rvalid;
	// {aclk} input bool #()[256] maxi_hbm07_rdata'0
	logic[255:0] maxi_hbm07_rdata;
	// {aclk} input bool #()[2] maxi_hbm07_rresp'0
	logic[1:0] maxi_hbm07_rresp;
	// {aclk} input bool #() maxi_hbm07_rlast'0
	logic maxi_hbm07_rlast;
	// HBM08
	// {aclk} output bool #() maxi_hbm08_awvalid'0
	wire maxi_hbm08_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm08_awaddr'0
	wire[63:0] maxi_hbm08_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm08_awlen'0
	wire[7:0] maxi_hbm08_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm08_awsize'0
	wire[2:0] maxi_hbm08_awsize;
	// {aclk} output bool #()[2] maxi_hbm08_awburst'0
	wire[1:0] maxi_hbm08_awburst;
	// {aclk} output bool #()[3] maxi_hbm08_awprot'0
	wire[2:0] maxi_hbm08_awprot;
	// {aclk} output bool #()[4] maxi_hbm08_awcache'0
	wire[3:0] maxi_hbm08_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm08_awqos'0
	wire[3:0] maxi_hbm08_awqos;
	// {aclk} output bool #() maxi_hbm08_awlock'0
	wire maxi_hbm08_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm08_awregion'0
	wire[3:0] maxi_hbm08_awregion;
	// {aclk} output bool #() maxi_hbm08_wvalid'0
	wire maxi_hbm08_wvalid;
	// {aclk} output bool #()[256] maxi_hbm08_wdata'0
	wire[255:0] maxi_hbm08_wdata;
	// {aclk} output bool #()[32] maxi_hbm08_wstrb'0
	wire[31:0] maxi_hbm08_wstrb;
	// {aclk} output bool #() maxi_hbm08_wlast'0
	wire maxi_hbm08_wlast;
	// {aclk} output bool #() maxi_hbm08_bready'0
	wire maxi_hbm08_bready;
	// {aclk} input bool #() maxi_hbm08_wready'0
	logic maxi_hbm08_wready;
	// {aclk} input bool #() maxi_hbm08_bvalid'0
	logic maxi_hbm08_bvalid;
	// {aclk} input bool #()[2] maxi_hbm08_bresp'0
	logic[1:0] maxi_hbm08_bresp;
	// {aclk} input bool #() maxi_hbm08_awready'0
	logic maxi_hbm08_awready;
	// {aclk} output bool #() maxi_hbm08_arvalid'0
	wire maxi_hbm08_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm08_araddr'0
	wire[63:0] maxi_hbm08_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm08_arlen'0
	wire[7:0] maxi_hbm08_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm08_arsize'0
	wire[2:0] maxi_hbm08_arsize;
	// {aclk} output bool #()[2] maxi_hbm08_arburst'0
	wire[1:0] maxi_hbm08_arburst;
	// {aclk} output bool #()[3] maxi_hbm08_arprot'0
	wire[2:0] maxi_hbm08_arprot;
	// {aclk} output bool #()[4] maxi_hbm08_arcache'0
	wire[3:0] maxi_hbm08_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm08_arqos'0
	wire[3:0] maxi_hbm08_arqos;
	// {aclk} output bool #() maxi_hbm08_arlock'0
	wire maxi_hbm08_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm08_arregion'0
	wire[3:0] maxi_hbm08_arregion;
	// {aclk} output bool #() maxi_hbm08_rready'0
	wire maxi_hbm08_rready;
	// {aclk} input bool #() maxi_hbm08_arready'0
	logic maxi_hbm08_arready;
	// {aclk} input bool #() maxi_hbm08_rvalid'0
	logic maxi_hbm08_rvalid;
	// {aclk} input bool #()[256] maxi_hbm08_rdata'0
	logic[255:0] maxi_hbm08_rdata;
	// {aclk} input bool #()[2] maxi_hbm08_rresp'0
	logic[1:0] maxi_hbm08_rresp;
	// {aclk} input bool #() maxi_hbm08_rlast'0
	logic maxi_hbm08_rlast;
	// HBM09
	// {aclk} output bool #() maxi_hbm09_awvalid'0
	wire maxi_hbm09_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm09_awaddr'0
	wire[63:0] maxi_hbm09_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm09_awlen'0
	wire[7:0] maxi_hbm09_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm09_awsize'0
	wire[2:0] maxi_hbm09_awsize;
	// {aclk} output bool #()[2] maxi_hbm09_awburst'0
	wire[1:0] maxi_hbm09_awburst;
	// {aclk} output bool #()[3] maxi_hbm09_awprot'0
	wire[2:0] maxi_hbm09_awprot;
	// {aclk} output bool #()[4] maxi_hbm09_awcache'0
	wire[3:0] maxi_hbm09_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm09_awqos'0
	wire[3:0] maxi_hbm09_awqos;
	// {aclk} output bool #() maxi_hbm09_awlock'0
	wire maxi_hbm09_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm09_awregion'0
	wire[3:0] maxi_hbm09_awregion;
	// {aclk} output bool #() maxi_hbm09_wvalid'0
	wire maxi_hbm09_wvalid;
	// {aclk} output bool #()[256] maxi_hbm09_wdata'0
	wire[255:0] maxi_hbm09_wdata;
	// {aclk} output bool #()[32] maxi_hbm09_wstrb'0
	wire[31:0] maxi_hbm09_wstrb;
	// {aclk} output bool #() maxi_hbm09_wlast'0
	wire maxi_hbm09_wlast;
	// {aclk} output bool #() maxi_hbm09_bready'0
	wire maxi_hbm09_bready;
	// {aclk} input bool #() maxi_hbm09_wready'0
	logic maxi_hbm09_wready;
	// {aclk} input bool #() maxi_hbm09_bvalid'0
	logic maxi_hbm09_bvalid;
	// {aclk} input bool #()[2] maxi_hbm09_bresp'0
	logic[1:0] maxi_hbm09_bresp;
	// {aclk} input bool #() maxi_hbm09_awready'0
	logic maxi_hbm09_awready;
	// {aclk} output bool #() maxi_hbm09_arvalid'0
	wire maxi_hbm09_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm09_araddr'0
	wire[63:0] maxi_hbm09_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm09_arlen'0
	wire[7:0] maxi_hbm09_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm09_arsize'0
	wire[2:0] maxi_hbm09_arsize;
	// {aclk} output bool #()[2] maxi_hbm09_arburst'0
	wire[1:0] maxi_hbm09_arburst;
	// {aclk} output bool #()[3] maxi_hbm09_arprot'0
	wire[2:0] maxi_hbm09_arprot;
	// {aclk} output bool #()[4] maxi_hbm09_arcache'0
	wire[3:0] maxi_hbm09_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm09_arqos'0
	wire[3:0] maxi_hbm09_arqos;
	// {aclk} output bool #() maxi_hbm09_arlock'0
	wire maxi_hbm09_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm09_arregion'0
	wire[3:0] maxi_hbm09_arregion;
	// {aclk} output bool #() maxi_hbm09_rready'0
	wire maxi_hbm09_rready;
	// {aclk} input bool #() maxi_hbm09_arready'0
	logic maxi_hbm09_arready;
	// {aclk} input bool #() maxi_hbm09_rvalid'0
	logic maxi_hbm09_rvalid;
	// {aclk} input bool #()[256] maxi_hbm09_rdata'0
	logic[255:0] maxi_hbm09_rdata;
	// {aclk} input bool #()[2] maxi_hbm09_rresp'0
	logic[1:0] maxi_hbm09_rresp;
	// {aclk} input bool #() maxi_hbm09_rlast'0
	logic maxi_hbm09_rlast;
	// HBM10
	// {aclk} output bool #() maxi_hbm10_awvalid'0
	wire maxi_hbm10_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm10_awaddr'0
	wire[63:0] maxi_hbm10_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm10_awlen'0
	wire[7:0] maxi_hbm10_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm10_awsize'0
	wire[2:0] maxi_hbm10_awsize;
	// {aclk} output bool #()[2] maxi_hbm10_awburst'0
	wire[1:0] maxi_hbm10_awburst;
	// {aclk} output bool #()[3] maxi_hbm10_awprot'0
	wire[2:0] maxi_hbm10_awprot;
	// {aclk} output bool #()[4] maxi_hbm10_awcache'0
	wire[3:0] maxi_hbm10_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm10_awqos'0
	wire[3:0] maxi_hbm10_awqos;
	// {aclk} output bool #() maxi_hbm10_awlock'0
	wire maxi_hbm10_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm10_awregion'0
	wire[3:0] maxi_hbm10_awregion;
	// {aclk} output bool #() maxi_hbm10_wvalid'0
	wire maxi_hbm10_wvalid;
	// {aclk} output bool #()[256] maxi_hbm10_wdata'0
	wire[255:0] maxi_hbm10_wdata;
	// {aclk} output bool #()[32] maxi_hbm10_wstrb'0
	wire[31:0] maxi_hbm10_wstrb;
	// {aclk} output bool #() maxi_hbm10_wlast'0
	wire maxi_hbm10_wlast;
	// {aclk} output bool #() maxi_hbm10_bready'0
	wire maxi_hbm10_bready;
	// {aclk} input bool #() maxi_hbm10_wready'0
	logic maxi_hbm10_wready;
	// {aclk} input bool #() maxi_hbm10_bvalid'0
	logic maxi_hbm10_bvalid;
	// {aclk} input bool #()[2] maxi_hbm10_bresp'0
	logic[1:0] maxi_hbm10_bresp;
	// {aclk} input bool #() maxi_hbm10_awready'0
	logic maxi_hbm10_awready;
	// {aclk} output bool #() maxi_hbm10_arvalid'0
	wire maxi_hbm10_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm10_araddr'0
	wire[63:0] maxi_hbm10_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm10_arlen'0
	wire[7:0] maxi_hbm10_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm10_arsize'0
	wire[2:0] maxi_hbm10_arsize;
	// {aclk} output bool #()[2] maxi_hbm10_arburst'0
	wire[1:0] maxi_hbm10_arburst;
	// {aclk} output bool #()[3] maxi_hbm10_arprot'0
	wire[2:0] maxi_hbm10_arprot;
	// {aclk} output bool #()[4] maxi_hbm10_arcache'0
	wire[3:0] maxi_hbm10_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm10_arqos'0
	wire[3:0] maxi_hbm10_arqos;
	// {aclk} output bool #() maxi_hbm10_arlock'0
	wire maxi_hbm10_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm10_arregion'0
	wire[3:0] maxi_hbm10_arregion;
	// {aclk} output bool #() maxi_hbm10_rready'0
	wire maxi_hbm10_rready;
	// {aclk} input bool #() maxi_hbm10_arready'0
	logic maxi_hbm10_arready;
	// {aclk} input bool #() maxi_hbm10_rvalid'0
	logic maxi_hbm10_rvalid;
	// {aclk} input bool #()[256] maxi_hbm10_rdata'0
	logic[255:0] maxi_hbm10_rdata;
	// {aclk} input bool #()[2] maxi_hbm10_rresp'0
	logic[1:0] maxi_hbm10_rresp;
	// {aclk} input bool #() maxi_hbm10_rlast'0
	logic maxi_hbm10_rlast;
	// HBM11
	// {aclk} output bool #() maxi_hbm11_awvalid'0
	wire maxi_hbm11_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm11_awaddr'0
	wire[63:0] maxi_hbm11_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm11_awlen'0
	wire[7:0] maxi_hbm11_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm11_awsize'0
	wire[2:0] maxi_hbm11_awsize;
	// {aclk} output bool #()[2] maxi_hbm11_awburst'0
	wire[1:0] maxi_hbm11_awburst;
	// {aclk} output bool #()[3] maxi_hbm11_awprot'0
	wire[2:0] maxi_hbm11_awprot;
	// {aclk} output bool #()[4] maxi_hbm11_awcache'0
	wire[3:0] maxi_hbm11_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm11_awqos'0
	wire[3:0] maxi_hbm11_awqos;
	// {aclk} output bool #() maxi_hbm11_awlock'0
	wire maxi_hbm11_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm11_awregion'0
	wire[3:0] maxi_hbm11_awregion;
	// {aclk} output bool #() maxi_hbm11_wvalid'0
	wire maxi_hbm11_wvalid;
	// {aclk} output bool #()[256] maxi_hbm11_wdata'0
	wire[255:0] maxi_hbm11_wdata;
	// {aclk} output bool #()[32] maxi_hbm11_wstrb'0
	wire[31:0] maxi_hbm11_wstrb;
	// {aclk} output bool #() maxi_hbm11_wlast'0
	wire maxi_hbm11_wlast;
	// {aclk} output bool #() maxi_hbm11_bready'0
	wire maxi_hbm11_bready;
	// {aclk} input bool #() maxi_hbm11_wready'0
	logic maxi_hbm11_wready;
	// {aclk} input bool #() maxi_hbm11_bvalid'0
	logic maxi_hbm11_bvalid;
	// {aclk} input bool #()[2] maxi_hbm11_bresp'0
	logic[1:0] maxi_hbm11_bresp;
	// {aclk} input bool #() maxi_hbm11_awready'0
	logic maxi_hbm11_awready;
	// {aclk} output bool #() maxi_hbm11_arvalid'0
	wire maxi_hbm11_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm11_araddr'0
	wire[63:0] maxi_hbm11_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm11_arlen'0
	wire[7:0] maxi_hbm11_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm11_arsize'0
	wire[2:0] maxi_hbm11_arsize;
	// {aclk} output bool #()[2] maxi_hbm11_arburst'0
	wire[1:0] maxi_hbm11_arburst;
	// {aclk} output bool #()[3] maxi_hbm11_arprot'0
	wire[2:0] maxi_hbm11_arprot;
	// {aclk} output bool #()[4] maxi_hbm11_arcache'0
	wire[3:0] maxi_hbm11_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm11_arqos'0
	wire[3:0] maxi_hbm11_arqos;
	// {aclk} output bool #() maxi_hbm11_arlock'0
	wire maxi_hbm11_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm11_arregion'0
	wire[3:0] maxi_hbm11_arregion;
	// {aclk} output bool #() maxi_hbm11_rready'0
	wire maxi_hbm11_rready;
	// {aclk} input bool #() maxi_hbm11_arready'0
	logic maxi_hbm11_arready;
	// {aclk} input bool #() maxi_hbm11_rvalid'0
	logic maxi_hbm11_rvalid;
	// {aclk} input bool #()[256] maxi_hbm11_rdata'0
	logic[255:0] maxi_hbm11_rdata;
	// {aclk} input bool #()[2] maxi_hbm11_rresp'0
	logic[1:0] maxi_hbm11_rresp;
	// {aclk} input bool #() maxi_hbm11_rlast'0
	logic maxi_hbm11_rlast;
	// HBM12
	// {aclk} output bool #() maxi_hbm12_awvalid'0
	wire maxi_hbm12_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm12_awaddr'0
	wire[63:0] maxi_hbm12_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm12_awlen'0
	wire[7:0] maxi_hbm12_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm12_awsize'0
	wire[2:0] maxi_hbm12_awsize;
	// {aclk} output bool #()[2] maxi_hbm12_awburst'0
	wire[1:0] maxi_hbm12_awburst;
	// {aclk} output bool #()[3] maxi_hbm12_awprot'0
	wire[2:0] maxi_hbm12_awprot;
	// {aclk} output bool #()[4] maxi_hbm12_awcache'0
	wire[3:0] maxi_hbm12_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm12_awqos'0
	wire[3:0] maxi_hbm12_awqos;
	// {aclk} output bool #() maxi_hbm12_awlock'0
	wire maxi_hbm12_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm12_awregion'0
	wire[3:0] maxi_hbm12_awregion;
	// {aclk} output bool #() maxi_hbm12_wvalid'0
	wire maxi_hbm12_wvalid;
	// {aclk} output bool #()[256] maxi_hbm12_wdata'0
	wire[255:0] maxi_hbm12_wdata;
	// {aclk} output bool #()[32] maxi_hbm12_wstrb'0
	wire[31:0] maxi_hbm12_wstrb;
	// {aclk} output bool #() maxi_hbm12_wlast'0
	wire maxi_hbm12_wlast;
	// {aclk} output bool #() maxi_hbm12_bready'0
	wire maxi_hbm12_bready;
	// {aclk} input bool #() maxi_hbm12_wready'0
	logic maxi_hbm12_wready;
	// {aclk} input bool #() maxi_hbm12_bvalid'0
	logic maxi_hbm12_bvalid;
	// {aclk} input bool #()[2] maxi_hbm12_bresp'0
	logic[1:0] maxi_hbm12_bresp;
	// {aclk} input bool #() maxi_hbm12_awready'0
	logic maxi_hbm12_awready;
	// {aclk} output bool #() maxi_hbm12_arvalid'0
	wire maxi_hbm12_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm12_araddr'0
	wire[63:0] maxi_hbm12_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm12_arlen'0
	wire[7:0] maxi_hbm12_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm12_arsize'0
	wire[2:0] maxi_hbm12_arsize;
	// {aclk} output bool #()[2] maxi_hbm12_arburst'0
	wire[1:0] maxi_hbm12_arburst;
	// {aclk} output bool #()[3] maxi_hbm12_arprot'0
	wire[2:0] maxi_hbm12_arprot;
	// {aclk} output bool #()[4] maxi_hbm12_arcache'0
	wire[3:0] maxi_hbm12_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm12_arqos'0
	wire[3:0] maxi_hbm12_arqos;
	// {aclk} output bool #() maxi_hbm12_arlock'0
	wire maxi_hbm12_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm12_arregion'0
	wire[3:0] maxi_hbm12_arregion;
	// {aclk} output bool #() maxi_hbm12_rready'0
	wire maxi_hbm12_rready;
	// {aclk} input bool #() maxi_hbm12_arready'0
	logic maxi_hbm12_arready;
	// {aclk} input bool #() maxi_hbm12_rvalid'0
	logic maxi_hbm12_rvalid;
	// {aclk} input bool #()[256] maxi_hbm12_rdata'0
	logic[255:0] maxi_hbm12_rdata;
	// {aclk} input bool #()[2] maxi_hbm12_rresp'0
	logic[1:0] maxi_hbm12_rresp;
	// {aclk} input bool #() maxi_hbm12_rlast'0
	logic maxi_hbm12_rlast;
	// HBM13
	// {aclk} output bool #() maxi_hbm13_awvalid'0
	wire maxi_hbm13_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm13_awaddr'0
	wire[63:0] maxi_hbm13_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm13_awlen'0
	wire[7:0] maxi_hbm13_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm13_awsize'0
	wire[2:0] maxi_hbm13_awsize;
	// {aclk} output bool #()[2] maxi_hbm13_awburst'0
	wire[1:0] maxi_hbm13_awburst;
	// {aclk} output bool #()[3] maxi_hbm13_awprot'0
	wire[2:0] maxi_hbm13_awprot;
	// {aclk} output bool #()[4] maxi_hbm13_awcache'0
	wire[3:0] maxi_hbm13_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm13_awqos'0
	wire[3:0] maxi_hbm13_awqos;
	// {aclk} output bool #() maxi_hbm13_awlock'0
	wire maxi_hbm13_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm13_awregion'0
	wire[3:0] maxi_hbm13_awregion;
	// {aclk} output bool #() maxi_hbm13_wvalid'0
	wire maxi_hbm13_wvalid;
	// {aclk} output bool #()[256] maxi_hbm13_wdata'0
	wire[255:0] maxi_hbm13_wdata;
	// {aclk} output bool #()[32] maxi_hbm13_wstrb'0
	wire[31:0] maxi_hbm13_wstrb;
	// {aclk} output bool #() maxi_hbm13_wlast'0
	wire maxi_hbm13_wlast;
	// {aclk} output bool #() maxi_hbm13_bready'0
	wire maxi_hbm13_bready;
	// {aclk} input bool #() maxi_hbm13_wready'0
	logic maxi_hbm13_wready;
	// {aclk} input bool #() maxi_hbm13_bvalid'0
	logic maxi_hbm13_bvalid;
	// {aclk} input bool #()[2] maxi_hbm13_bresp'0
	logic[1:0] maxi_hbm13_bresp;
	// {aclk} input bool #() maxi_hbm13_awready'0
	logic maxi_hbm13_awready;
	// {aclk} output bool #() maxi_hbm13_arvalid'0
	wire maxi_hbm13_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm13_araddr'0
	wire[63:0] maxi_hbm13_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm13_arlen'0
	wire[7:0] maxi_hbm13_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm13_arsize'0
	wire[2:0] maxi_hbm13_arsize;
	// {aclk} output bool #()[2] maxi_hbm13_arburst'0
	wire[1:0] maxi_hbm13_arburst;
	// {aclk} output bool #()[3] maxi_hbm13_arprot'0
	wire[2:0] maxi_hbm13_arprot;
	// {aclk} output bool #()[4] maxi_hbm13_arcache'0
	wire[3:0] maxi_hbm13_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm13_arqos'0
	wire[3:0] maxi_hbm13_arqos;
	// {aclk} output bool #() maxi_hbm13_arlock'0
	wire maxi_hbm13_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm13_arregion'0
	wire[3:0] maxi_hbm13_arregion;
	// {aclk} output bool #() maxi_hbm13_rready'0
	wire maxi_hbm13_rready;
	// {aclk} input bool #() maxi_hbm13_arready'0
	logic maxi_hbm13_arready;
	// {aclk} input bool #() maxi_hbm13_rvalid'0
	logic maxi_hbm13_rvalid;
	// {aclk} input bool #()[256] maxi_hbm13_rdata'0
	logic[255:0] maxi_hbm13_rdata;
	// {aclk} input bool #()[2] maxi_hbm13_rresp'0
	logic[1:0] maxi_hbm13_rresp;
	// {aclk} input bool #() maxi_hbm13_rlast'0
	logic maxi_hbm13_rlast;
	// HBM14
	// {aclk} output bool #() maxi_hbm14_awvalid'0
	wire maxi_hbm14_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm14_awaddr'0
	wire[63:0] maxi_hbm14_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm14_awlen'0
	wire[7:0] maxi_hbm14_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm14_awsize'0
	wire[2:0] maxi_hbm14_awsize;
	// {aclk} output bool #()[2] maxi_hbm14_awburst'0
	wire[1:0] maxi_hbm14_awburst;
	// {aclk} output bool #()[3] maxi_hbm14_awprot'0
	wire[2:0] maxi_hbm14_awprot;
	// {aclk} output bool #()[4] maxi_hbm14_awcache'0
	wire[3:0] maxi_hbm14_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm14_awqos'0
	wire[3:0] maxi_hbm14_awqos;
	// {aclk} output bool #() maxi_hbm14_awlock'0
	wire maxi_hbm14_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm14_awregion'0
	wire[3:0] maxi_hbm14_awregion;
	// {aclk} output bool #() maxi_hbm14_wvalid'0
	wire maxi_hbm14_wvalid;
	// {aclk} output bool #()[256] maxi_hbm14_wdata'0
	wire[255:0] maxi_hbm14_wdata;
	// {aclk} output bool #()[32] maxi_hbm14_wstrb'0
	wire[31:0] maxi_hbm14_wstrb;
	// {aclk} output bool #() maxi_hbm14_wlast'0
	wire maxi_hbm14_wlast;
	// {aclk} output bool #() maxi_hbm14_bready'0
	wire maxi_hbm14_bready;
	// {aclk} input bool #() maxi_hbm14_wready'0
	logic maxi_hbm14_wready;
	// {aclk} input bool #() maxi_hbm14_bvalid'0
	logic maxi_hbm14_bvalid;
	// {aclk} input bool #()[2] maxi_hbm14_bresp'0
	logic[1:0] maxi_hbm14_bresp;
	// {aclk} input bool #() maxi_hbm14_awready'0
	logic maxi_hbm14_awready;
	// {aclk} output bool #() maxi_hbm14_arvalid'0
	wire maxi_hbm14_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm14_araddr'0
	wire[63:0] maxi_hbm14_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm14_arlen'0
	wire[7:0] maxi_hbm14_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm14_arsize'0
	wire[2:0] maxi_hbm14_arsize;
	// {aclk} output bool #()[2] maxi_hbm14_arburst'0
	wire[1:0] maxi_hbm14_arburst;
	// {aclk} output bool #()[3] maxi_hbm14_arprot'0
	wire[2:0] maxi_hbm14_arprot;
	// {aclk} output bool #()[4] maxi_hbm14_arcache'0
	wire[3:0] maxi_hbm14_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm14_arqos'0
	wire[3:0] maxi_hbm14_arqos;
	// {aclk} output bool #() maxi_hbm14_arlock'0
	wire maxi_hbm14_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm14_arregion'0
	wire[3:0] maxi_hbm14_arregion;
	// {aclk} output bool #() maxi_hbm14_rready'0
	wire maxi_hbm14_rready;
	// {aclk} input bool #() maxi_hbm14_arready'0
	logic maxi_hbm14_arready;
	// {aclk} input bool #() maxi_hbm14_rvalid'0
	logic maxi_hbm14_rvalid;
	// {aclk} input bool #()[256] maxi_hbm14_rdata'0
	logic[255:0] maxi_hbm14_rdata;
	// {aclk} input bool #()[2] maxi_hbm14_rresp'0
	logic[1:0] maxi_hbm14_rresp;
	// {aclk} input bool #() maxi_hbm14_rlast'0
	logic maxi_hbm14_rlast;
	// HBM15
	// {aclk} output bool #() maxi_hbm15_awvalid'0
	wire maxi_hbm15_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm15_awaddr'0
	wire[63:0] maxi_hbm15_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm15_awlen'0
	wire[7:0] maxi_hbm15_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm15_awsize'0
	wire[2:0] maxi_hbm15_awsize;
	// {aclk} output bool #()[2] maxi_hbm15_awburst'0
	wire[1:0] maxi_hbm15_awburst;
	// {aclk} output bool #()[3] maxi_hbm15_awprot'0
	wire[2:0] maxi_hbm15_awprot;
	// {aclk} output bool #()[4] maxi_hbm15_awcache'0
	wire[3:0] maxi_hbm15_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm15_awqos'0
	wire[3:0] maxi_hbm15_awqos;
	// {aclk} output bool #() maxi_hbm15_awlock'0
	wire maxi_hbm15_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm15_awregion'0
	wire[3:0] maxi_hbm15_awregion;
	// {aclk} output bool #() maxi_hbm15_wvalid'0
	wire maxi_hbm15_wvalid;
	// {aclk} output bool #()[256] maxi_hbm15_wdata'0
	wire[255:0] maxi_hbm15_wdata;
	// {aclk} output bool #()[32] maxi_hbm15_wstrb'0
	wire[31:0] maxi_hbm15_wstrb;
	// {aclk} output bool #() maxi_hbm15_wlast'0
	wire maxi_hbm15_wlast;
	// {aclk} output bool #() maxi_hbm15_bready'0
	wire maxi_hbm15_bready;
	// {aclk} input bool #() maxi_hbm15_wready'0
	logic maxi_hbm15_wready;
	// {aclk} input bool #() maxi_hbm15_bvalid'0
	logic maxi_hbm15_bvalid;
	// {aclk} input bool #()[2] maxi_hbm15_bresp'0
	logic[1:0] maxi_hbm15_bresp;
	// {aclk} input bool #() maxi_hbm15_awready'0
	logic maxi_hbm15_awready;
	// {aclk} output bool #() maxi_hbm15_arvalid'0
	wire maxi_hbm15_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm15_araddr'0
	wire[63:0] maxi_hbm15_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm15_arlen'0
	wire[7:0] maxi_hbm15_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm15_arsize'0
	wire[2:0] maxi_hbm15_arsize;
	// {aclk} output bool #()[2] maxi_hbm15_arburst'0
	wire[1:0] maxi_hbm15_arburst;
	// {aclk} output bool #()[3] maxi_hbm15_arprot'0
	wire[2:0] maxi_hbm15_arprot;
	// {aclk} output bool #()[4] maxi_hbm15_arcache'0
	wire[3:0] maxi_hbm15_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm15_arqos'0
	wire[3:0] maxi_hbm15_arqos;
	// {aclk} output bool #() maxi_hbm15_arlock'0
	wire maxi_hbm15_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm15_arregion'0
	wire[3:0] maxi_hbm15_arregion;
	// {aclk} output bool #() maxi_hbm15_rready'0
	wire maxi_hbm15_rready;
	// {aclk} input bool #() maxi_hbm15_arready'0
	logic maxi_hbm15_arready;
	// {aclk} input bool #() maxi_hbm15_rvalid'0
	logic maxi_hbm15_rvalid;
	// {aclk} input bool #()[256] maxi_hbm15_rdata'0
	logic[255:0] maxi_hbm15_rdata;
	// {aclk} input bool #()[2] maxi_hbm15_rresp'0
	logic[1:0] maxi_hbm15_rresp;
	// {aclk} input bool #() maxi_hbm15_rlast'0
	logic maxi_hbm15_rlast;
	// HBM16
	// {aclk} output bool #() maxi_hbm16_awvalid'0
	wire maxi_hbm16_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm16_awaddr'0
	wire[63:0] maxi_hbm16_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm16_awlen'0
	wire[7:0] maxi_hbm16_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm16_awsize'0
	wire[2:0] maxi_hbm16_awsize;
	// {aclk} output bool #()[2] maxi_hbm16_awburst'0
	wire[1:0] maxi_hbm16_awburst;
	// {aclk} output bool #()[3] maxi_hbm16_awprot'0
	wire[2:0] maxi_hbm16_awprot;
	// {aclk} output bool #()[4] maxi_hbm16_awcache'0
	wire[3:0] maxi_hbm16_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm16_awqos'0
	wire[3:0] maxi_hbm16_awqos;
	// {aclk} output bool #() maxi_hbm16_awlock'0
	wire maxi_hbm16_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm16_awregion'0
	wire[3:0] maxi_hbm16_awregion;
	// {aclk} output bool #() maxi_hbm16_wvalid'0
	wire maxi_hbm16_wvalid;
	// {aclk} output bool #()[256] maxi_hbm16_wdata'0
	wire[255:0] maxi_hbm16_wdata;
	// {aclk} output bool #()[32] maxi_hbm16_wstrb'0
	wire[31:0] maxi_hbm16_wstrb;
	// {aclk} output bool #() maxi_hbm16_wlast'0
	wire maxi_hbm16_wlast;
	// {aclk} output bool #() maxi_hbm16_bready'0
	wire maxi_hbm16_bready;
	// {aclk} input bool #() maxi_hbm16_wready'0
	logic maxi_hbm16_wready;
	// {aclk} input bool #() maxi_hbm16_bvalid'0
	logic maxi_hbm16_bvalid;
	// {aclk} input bool #()[2] maxi_hbm16_bresp'0
	logic[1:0] maxi_hbm16_bresp;
	// {aclk} input bool #() maxi_hbm16_awready'0
	logic maxi_hbm16_awready;
	// {aclk} output bool #() maxi_hbm16_arvalid'0
	wire maxi_hbm16_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm16_araddr'0
	wire[63:0] maxi_hbm16_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm16_arlen'0
	wire[7:0] maxi_hbm16_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm16_arsize'0
	wire[2:0] maxi_hbm16_arsize;
	// {aclk} output bool #()[2] maxi_hbm16_arburst'0
	wire[1:0] maxi_hbm16_arburst;
	// {aclk} output bool #()[3] maxi_hbm16_arprot'0
	wire[2:0] maxi_hbm16_arprot;
	// {aclk} output bool #()[4] maxi_hbm16_arcache'0
	wire[3:0] maxi_hbm16_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm16_arqos'0
	wire[3:0] maxi_hbm16_arqos;
	// {aclk} output bool #() maxi_hbm16_arlock'0
	wire maxi_hbm16_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm16_arregion'0
	wire[3:0] maxi_hbm16_arregion;
	// {aclk} output bool #() maxi_hbm16_rready'0
	wire maxi_hbm16_rready;
	// {aclk} input bool #() maxi_hbm16_arready'0
	logic maxi_hbm16_arready;
	// {aclk} input bool #() maxi_hbm16_rvalid'0
	logic maxi_hbm16_rvalid;
	// {aclk} input bool #()[256] maxi_hbm16_rdata'0
	logic[255:0] maxi_hbm16_rdata;
	// {aclk} input bool #()[2] maxi_hbm16_rresp'0
	logic[1:0] maxi_hbm16_rresp;
	// {aclk} input bool #() maxi_hbm16_rlast'0
	logic maxi_hbm16_rlast;
	// HBM17
	// {aclk} output bool #() maxi_hbm17_awvalid'0
	wire maxi_hbm17_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm17_awaddr'0
	wire[63:0] maxi_hbm17_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm17_awlen'0
	wire[7:0] maxi_hbm17_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm17_awsize'0
	wire[2:0] maxi_hbm17_awsize;
	// {aclk} output bool #()[2] maxi_hbm17_awburst'0
	wire[1:0] maxi_hbm17_awburst;
	// {aclk} output bool #()[3] maxi_hbm17_awprot'0
	wire[2:0] maxi_hbm17_awprot;
	// {aclk} output bool #()[4] maxi_hbm17_awcache'0
	wire[3:0] maxi_hbm17_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm17_awqos'0
	wire[3:0] maxi_hbm17_awqos;
	// {aclk} output bool #() maxi_hbm17_awlock'0
	wire maxi_hbm17_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm17_awregion'0
	wire[3:0] maxi_hbm17_awregion;
	// {aclk} output bool #() maxi_hbm17_wvalid'0
	wire maxi_hbm17_wvalid;
	// {aclk} output bool #()[256] maxi_hbm17_wdata'0
	wire[255:0] maxi_hbm17_wdata;
	// {aclk} output bool #()[32] maxi_hbm17_wstrb'0
	wire[31:0] maxi_hbm17_wstrb;
	// {aclk} output bool #() maxi_hbm17_wlast'0
	wire maxi_hbm17_wlast;
	// {aclk} output bool #() maxi_hbm17_bready'0
	wire maxi_hbm17_bready;
	// {aclk} input bool #() maxi_hbm17_wready'0
	logic maxi_hbm17_wready;
	// {aclk} input bool #() maxi_hbm17_bvalid'0
	logic maxi_hbm17_bvalid;
	// {aclk} input bool #()[2] maxi_hbm17_bresp'0
	logic[1:0] maxi_hbm17_bresp;
	// {aclk} input bool #() maxi_hbm17_awready'0
	logic maxi_hbm17_awready;
	// {aclk} output bool #() maxi_hbm17_arvalid'0
	wire maxi_hbm17_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm17_araddr'0
	wire[63:0] maxi_hbm17_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm17_arlen'0
	wire[7:0] maxi_hbm17_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm17_arsize'0
	wire[2:0] maxi_hbm17_arsize;
	// {aclk} output bool #()[2] maxi_hbm17_arburst'0
	wire[1:0] maxi_hbm17_arburst;
	// {aclk} output bool #()[3] maxi_hbm17_arprot'0
	wire[2:0] maxi_hbm17_arprot;
	// {aclk} output bool #()[4] maxi_hbm17_arcache'0
	wire[3:0] maxi_hbm17_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm17_arqos'0
	wire[3:0] maxi_hbm17_arqos;
	// {aclk} output bool #() maxi_hbm17_arlock'0
	wire maxi_hbm17_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm17_arregion'0
	wire[3:0] maxi_hbm17_arregion;
	// {aclk} output bool #() maxi_hbm17_rready'0
	wire maxi_hbm17_rready;
	// {aclk} input bool #() maxi_hbm17_arready'0
	logic maxi_hbm17_arready;
	// {aclk} input bool #() maxi_hbm17_rvalid'0
	logic maxi_hbm17_rvalid;
	// {aclk} input bool #()[256] maxi_hbm17_rdata'0
	logic[255:0] maxi_hbm17_rdata;
	// {aclk} input bool #()[2] maxi_hbm17_rresp'0
	logic[1:0] maxi_hbm17_rresp;
	// {aclk} input bool #() maxi_hbm17_rlast'0
	logic maxi_hbm17_rlast;
	// HBM18
	// {aclk} output bool #() maxi_hbm18_awvalid'0
	wire maxi_hbm18_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm18_awaddr'0
	wire[63:0] maxi_hbm18_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm18_awlen'0
	wire[7:0] maxi_hbm18_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm18_awsize'0
	wire[2:0] maxi_hbm18_awsize;
	// {aclk} output bool #()[2] maxi_hbm18_awburst'0
	wire[1:0] maxi_hbm18_awburst;
	// {aclk} output bool #()[3] maxi_hbm18_awprot'0
	wire[2:0] maxi_hbm18_awprot;
	// {aclk} output bool #()[4] maxi_hbm18_awcache'0
	wire[3:0] maxi_hbm18_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm18_awqos'0
	wire[3:0] maxi_hbm18_awqos;
	// {aclk} output bool #() maxi_hbm18_awlock'0
	wire maxi_hbm18_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm18_awregion'0
	wire[3:0] maxi_hbm18_awregion;
	// {aclk} output bool #() maxi_hbm18_wvalid'0
	wire maxi_hbm18_wvalid;
	// {aclk} output bool #()[256] maxi_hbm18_wdata'0
	wire[255:0] maxi_hbm18_wdata;
	// {aclk} output bool #()[32] maxi_hbm18_wstrb'0
	wire[31:0] maxi_hbm18_wstrb;
	// {aclk} output bool #() maxi_hbm18_wlast'0
	wire maxi_hbm18_wlast;
	// {aclk} output bool #() maxi_hbm18_bready'0
	wire maxi_hbm18_bready;
	// {aclk} input bool #() maxi_hbm18_wready'0
	logic maxi_hbm18_wready;
	// {aclk} input bool #() maxi_hbm18_bvalid'0
	logic maxi_hbm18_bvalid;
	// {aclk} input bool #()[2] maxi_hbm18_bresp'0
	logic[1:0] maxi_hbm18_bresp;
	// {aclk} input bool #() maxi_hbm18_awready'0
	logic maxi_hbm18_awready;
	// {aclk} output bool #() maxi_hbm18_arvalid'0
	wire maxi_hbm18_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm18_araddr'0
	wire[63:0] maxi_hbm18_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm18_arlen'0
	wire[7:0] maxi_hbm18_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm18_arsize'0
	wire[2:0] maxi_hbm18_arsize;
	// {aclk} output bool #()[2] maxi_hbm18_arburst'0
	wire[1:0] maxi_hbm18_arburst;
	// {aclk} output bool #()[3] maxi_hbm18_arprot'0
	wire[2:0] maxi_hbm18_arprot;
	// {aclk} output bool #()[4] maxi_hbm18_arcache'0
	wire[3:0] maxi_hbm18_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm18_arqos'0
	wire[3:0] maxi_hbm18_arqos;
	// {aclk} output bool #() maxi_hbm18_arlock'0
	wire maxi_hbm18_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm18_arregion'0
	wire[3:0] maxi_hbm18_arregion;
	// {aclk} output bool #() maxi_hbm18_rready'0
	wire maxi_hbm18_rready;
	// {aclk} input bool #() maxi_hbm18_arready'0
	logic maxi_hbm18_arready;
	// {aclk} input bool #() maxi_hbm18_rvalid'0
	logic maxi_hbm18_rvalid;
	// {aclk} input bool #()[256] maxi_hbm18_rdata'0
	logic[255:0] maxi_hbm18_rdata;
	// {aclk} input bool #()[2] maxi_hbm18_rresp'0
	logic[1:0] maxi_hbm18_rresp;
	// {aclk} input bool #() maxi_hbm18_rlast'0
	logic maxi_hbm18_rlast;
	// HBM19
	// {aclk} output bool #() maxi_hbm19_awvalid'0
	wire maxi_hbm19_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm19_awaddr'0
	wire[63:0] maxi_hbm19_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm19_awlen'0
	wire[7:0] maxi_hbm19_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm19_awsize'0
	wire[2:0] maxi_hbm19_awsize;
	// {aclk} output bool #()[2] maxi_hbm19_awburst'0
	wire[1:0] maxi_hbm19_awburst;
	// {aclk} output bool #()[3] maxi_hbm19_awprot'0
	wire[2:0] maxi_hbm19_awprot;
	// {aclk} output bool #()[4] maxi_hbm19_awcache'0
	wire[3:0] maxi_hbm19_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm19_awqos'0
	wire[3:0] maxi_hbm19_awqos;
	// {aclk} output bool #() maxi_hbm19_awlock'0
	wire maxi_hbm19_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm19_awregion'0
	wire[3:0] maxi_hbm19_awregion;
	// {aclk} output bool #() maxi_hbm19_wvalid'0
	wire maxi_hbm19_wvalid;
	// {aclk} output bool #()[256] maxi_hbm19_wdata'0
	wire[255:0] maxi_hbm19_wdata;
	// {aclk} output bool #()[32] maxi_hbm19_wstrb'0
	wire[31:0] maxi_hbm19_wstrb;
	// {aclk} output bool #() maxi_hbm19_wlast'0
	wire maxi_hbm19_wlast;
	// {aclk} output bool #() maxi_hbm19_bready'0
	wire maxi_hbm19_bready;
	// {aclk} input bool #() maxi_hbm19_wready'0
	logic maxi_hbm19_wready;
	// {aclk} input bool #() maxi_hbm19_bvalid'0
	logic maxi_hbm19_bvalid;
	// {aclk} input bool #()[2] maxi_hbm19_bresp'0
	logic[1:0] maxi_hbm19_bresp;
	// {aclk} input bool #() maxi_hbm19_awready'0
	logic maxi_hbm19_awready;
	// {aclk} output bool #() maxi_hbm19_arvalid'0
	wire maxi_hbm19_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm19_araddr'0
	wire[63:0] maxi_hbm19_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm19_arlen'0
	wire[7:0] maxi_hbm19_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm19_arsize'0
	wire[2:0] maxi_hbm19_arsize;
	// {aclk} output bool #()[2] maxi_hbm19_arburst'0
	wire[1:0] maxi_hbm19_arburst;
	// {aclk} output bool #()[3] maxi_hbm19_arprot'0
	wire[2:0] maxi_hbm19_arprot;
	// {aclk} output bool #()[4] maxi_hbm19_arcache'0
	wire[3:0] maxi_hbm19_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm19_arqos'0
	wire[3:0] maxi_hbm19_arqos;
	// {aclk} output bool #() maxi_hbm19_arlock'0
	wire maxi_hbm19_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm19_arregion'0
	wire[3:0] maxi_hbm19_arregion;
	// {aclk} output bool #() maxi_hbm19_rready'0
	wire maxi_hbm19_rready;
	// {aclk} input bool #() maxi_hbm19_arready'0
	logic maxi_hbm19_arready;
	// {aclk} input bool #() maxi_hbm19_rvalid'0
	logic maxi_hbm19_rvalid;
	// {aclk} input bool #()[256] maxi_hbm19_rdata'0
	logic[255:0] maxi_hbm19_rdata;
	// {aclk} input bool #()[2] maxi_hbm19_rresp'0
	logic[1:0] maxi_hbm19_rresp;
	// {aclk} input bool #() maxi_hbm19_rlast'0
	logic maxi_hbm19_rlast;
	// HBM20
	// {aclk} output bool #() maxi_hbm20_awvalid'0
	wire maxi_hbm20_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm20_awaddr'0
	wire[63:0] maxi_hbm20_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm20_awlen'0
	wire[7:0] maxi_hbm20_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm20_awsize'0
	wire[2:0] maxi_hbm20_awsize;
	// {aclk} output bool #()[2] maxi_hbm20_awburst'0
	wire[1:0] maxi_hbm20_awburst;
	// {aclk} output bool #()[3] maxi_hbm20_awprot'0
	wire[2:0] maxi_hbm20_awprot;
	// {aclk} output bool #()[4] maxi_hbm20_awcache'0
	wire[3:0] maxi_hbm20_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm20_awqos'0
	wire[3:0] maxi_hbm20_awqos;
	// {aclk} output bool #() maxi_hbm20_awlock'0
	wire maxi_hbm20_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm20_awregion'0
	wire[3:0] maxi_hbm20_awregion;
	// {aclk} output bool #() maxi_hbm20_wvalid'0
	wire maxi_hbm20_wvalid;
	// {aclk} output bool #()[256] maxi_hbm20_wdata'0
	wire[255:0] maxi_hbm20_wdata;
	// {aclk} output bool #()[32] maxi_hbm20_wstrb'0
	wire[31:0] maxi_hbm20_wstrb;
	// {aclk} output bool #() maxi_hbm20_wlast'0
	wire maxi_hbm20_wlast;
	// {aclk} output bool #() maxi_hbm20_bready'0
	wire maxi_hbm20_bready;
	// {aclk} input bool #() maxi_hbm20_wready'0
	logic maxi_hbm20_wready;
	// {aclk} input bool #() maxi_hbm20_bvalid'0
	logic maxi_hbm20_bvalid;
	// {aclk} input bool #()[2] maxi_hbm20_bresp'0
	logic[1:0] maxi_hbm20_bresp;
	// {aclk} input bool #() maxi_hbm20_awready'0
	logic maxi_hbm20_awready;
	// {aclk} output bool #() maxi_hbm20_arvalid'0
	wire maxi_hbm20_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm20_araddr'0
	wire[63:0] maxi_hbm20_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm20_arlen'0
	wire[7:0] maxi_hbm20_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm20_arsize'0
	wire[2:0] maxi_hbm20_arsize;
	// {aclk} output bool #()[2] maxi_hbm20_arburst'0
	wire[1:0] maxi_hbm20_arburst;
	// {aclk} output bool #()[3] maxi_hbm20_arprot'0
	wire[2:0] maxi_hbm20_arprot;
	// {aclk} output bool #()[4] maxi_hbm20_arcache'0
	wire[3:0] maxi_hbm20_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm20_arqos'0
	wire[3:0] maxi_hbm20_arqos;
	// {aclk} output bool #() maxi_hbm20_arlock'0
	wire maxi_hbm20_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm20_arregion'0
	wire[3:0] maxi_hbm20_arregion;
	// {aclk} output bool #() maxi_hbm20_rready'0
	wire maxi_hbm20_rready;
	// {aclk} input bool #() maxi_hbm20_arready'0
	logic maxi_hbm20_arready;
	// {aclk} input bool #() maxi_hbm20_rvalid'0
	logic maxi_hbm20_rvalid;
	// {aclk} input bool #()[256] maxi_hbm20_rdata'0
	logic[255:0] maxi_hbm20_rdata;
	// {aclk} input bool #()[2] maxi_hbm20_rresp'0
	logic[1:0] maxi_hbm20_rresp;
	// {aclk} input bool #() maxi_hbm20_rlast'0
	logic maxi_hbm20_rlast;
	// HBM21
	// {aclk} output bool #() maxi_hbm21_awvalid'0
	wire maxi_hbm21_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm21_awaddr'0
	wire[63:0] maxi_hbm21_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm21_awlen'0
	wire[7:0] maxi_hbm21_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm21_awsize'0
	wire[2:0] maxi_hbm21_awsize;
	// {aclk} output bool #()[2] maxi_hbm21_awburst'0
	wire[1:0] maxi_hbm21_awburst;
	// {aclk} output bool #()[3] maxi_hbm21_awprot'0
	wire[2:0] maxi_hbm21_awprot;
	// {aclk} output bool #()[4] maxi_hbm21_awcache'0
	wire[3:0] maxi_hbm21_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm21_awqos'0
	wire[3:0] maxi_hbm21_awqos;
	// {aclk} output bool #() maxi_hbm21_awlock'0
	wire maxi_hbm21_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm21_awregion'0
	wire[3:0] maxi_hbm21_awregion;
	// {aclk} output bool #() maxi_hbm21_wvalid'0
	wire maxi_hbm21_wvalid;
	// {aclk} output bool #()[256] maxi_hbm21_wdata'0
	wire[255:0] maxi_hbm21_wdata;
	// {aclk} output bool #()[32] maxi_hbm21_wstrb'0
	wire[31:0] maxi_hbm21_wstrb;
	// {aclk} output bool #() maxi_hbm21_wlast'0
	wire maxi_hbm21_wlast;
	// {aclk} output bool #() maxi_hbm21_bready'0
	wire maxi_hbm21_bready;
	// {aclk} input bool #() maxi_hbm21_wready'0
	logic maxi_hbm21_wready;
	// {aclk} input bool #() maxi_hbm21_bvalid'0
	logic maxi_hbm21_bvalid;
	// {aclk} input bool #()[2] maxi_hbm21_bresp'0
	logic[1:0] maxi_hbm21_bresp;
	// {aclk} input bool #() maxi_hbm21_awready'0
	logic maxi_hbm21_awready;
	// {aclk} output bool #() maxi_hbm21_arvalid'0
	wire maxi_hbm21_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm21_araddr'0
	wire[63:0] maxi_hbm21_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm21_arlen'0
	wire[7:0] maxi_hbm21_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm21_arsize'0
	wire[2:0] maxi_hbm21_arsize;
	// {aclk} output bool #()[2] maxi_hbm21_arburst'0
	wire[1:0] maxi_hbm21_arburst;
	// {aclk} output bool #()[3] maxi_hbm21_arprot'0
	wire[2:0] maxi_hbm21_arprot;
	// {aclk} output bool #()[4] maxi_hbm21_arcache'0
	wire[3:0] maxi_hbm21_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm21_arqos'0
	wire[3:0] maxi_hbm21_arqos;
	// {aclk} output bool #() maxi_hbm21_arlock'0
	wire maxi_hbm21_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm21_arregion'0
	wire[3:0] maxi_hbm21_arregion;
	// {aclk} output bool #() maxi_hbm21_rready'0
	wire maxi_hbm21_rready;
	// {aclk} input bool #() maxi_hbm21_arready'0
	logic maxi_hbm21_arready;
	// {aclk} input bool #() maxi_hbm21_rvalid'0
	logic maxi_hbm21_rvalid;
	// {aclk} input bool #()[256] maxi_hbm21_rdata'0
	logic[255:0] maxi_hbm21_rdata;
	// {aclk} input bool #()[2] maxi_hbm21_rresp'0
	logic[1:0] maxi_hbm21_rresp;
	// {aclk} input bool #() maxi_hbm21_rlast'0
	logic maxi_hbm21_rlast;
	// HBM22
	// {aclk} output bool #() maxi_hbm22_awvalid'0
	wire maxi_hbm22_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm22_awaddr'0
	wire[63:0] maxi_hbm22_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm22_awlen'0
	wire[7:0] maxi_hbm22_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm22_awsize'0
	wire[2:0] maxi_hbm22_awsize;
	// {aclk} output bool #()[2] maxi_hbm22_awburst'0
	wire[1:0] maxi_hbm22_awburst;
	// {aclk} output bool #()[3] maxi_hbm22_awprot'0
	wire[2:0] maxi_hbm22_awprot;
	// {aclk} output bool #()[4] maxi_hbm22_awcache'0
	wire[3:0] maxi_hbm22_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm22_awqos'0
	wire[3:0] maxi_hbm22_awqos;
	// {aclk} output bool #() maxi_hbm22_awlock'0
	wire maxi_hbm22_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm22_awregion'0
	wire[3:0] maxi_hbm22_awregion;
	// {aclk} output bool #() maxi_hbm22_wvalid'0
	wire maxi_hbm22_wvalid;
	// {aclk} output bool #()[256] maxi_hbm22_wdata'0
	wire[255:0] maxi_hbm22_wdata;
	// {aclk} output bool #()[32] maxi_hbm22_wstrb'0
	wire[31:0] maxi_hbm22_wstrb;
	// {aclk} output bool #() maxi_hbm22_wlast'0
	wire maxi_hbm22_wlast;
	// {aclk} output bool #() maxi_hbm22_bready'0
	wire maxi_hbm22_bready;
	// {aclk} input bool #() maxi_hbm22_wready'0
	logic maxi_hbm22_wready;
	// {aclk} input bool #() maxi_hbm22_bvalid'0
	logic maxi_hbm22_bvalid;
	// {aclk} input bool #()[2] maxi_hbm22_bresp'0
	logic[1:0] maxi_hbm22_bresp;
	// {aclk} input bool #() maxi_hbm22_awready'0
	logic maxi_hbm22_awready;
	// {aclk} output bool #() maxi_hbm22_arvalid'0
	wire maxi_hbm22_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm22_araddr'0
	wire[63:0] maxi_hbm22_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm22_arlen'0
	wire[7:0] maxi_hbm22_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm22_arsize'0
	wire[2:0] maxi_hbm22_arsize;
	// {aclk} output bool #()[2] maxi_hbm22_arburst'0
	wire[1:0] maxi_hbm22_arburst;
	// {aclk} output bool #()[3] maxi_hbm22_arprot'0
	wire[2:0] maxi_hbm22_arprot;
	// {aclk} output bool #()[4] maxi_hbm22_arcache'0
	wire[3:0] maxi_hbm22_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm22_arqos'0
	wire[3:0] maxi_hbm22_arqos;
	// {aclk} output bool #() maxi_hbm22_arlock'0
	wire maxi_hbm22_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm22_arregion'0
	wire[3:0] maxi_hbm22_arregion;
	// {aclk} output bool #() maxi_hbm22_rready'0
	wire maxi_hbm22_rready;
	// {aclk} input bool #() maxi_hbm22_arready'0
	logic maxi_hbm22_arready;
	// {aclk} input bool #() maxi_hbm22_rvalid'0
	logic maxi_hbm22_rvalid;
	// {aclk} input bool #()[256] maxi_hbm22_rdata'0
	logic[255:0] maxi_hbm22_rdata;
	// {aclk} input bool #()[2] maxi_hbm22_rresp'0
	logic[1:0] maxi_hbm22_rresp;
	// {aclk} input bool #() maxi_hbm22_rlast'0
	logic maxi_hbm22_rlast;
	// HBM23
	// {aclk} output bool #() maxi_hbm23_awvalid'0
	wire maxi_hbm23_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm23_awaddr'0
	wire[63:0] maxi_hbm23_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm23_awlen'0
	wire[7:0] maxi_hbm23_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm23_awsize'0
	wire[2:0] maxi_hbm23_awsize;
	// {aclk} output bool #()[2] maxi_hbm23_awburst'0
	wire[1:0] maxi_hbm23_awburst;
	// {aclk} output bool #()[3] maxi_hbm23_awprot'0
	wire[2:0] maxi_hbm23_awprot;
	// {aclk} output bool #()[4] maxi_hbm23_awcache'0
	wire[3:0] maxi_hbm23_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm23_awqos'0
	wire[3:0] maxi_hbm23_awqos;
	// {aclk} output bool #() maxi_hbm23_awlock'0
	wire maxi_hbm23_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm23_awregion'0
	wire[3:0] maxi_hbm23_awregion;
	// {aclk} output bool #() maxi_hbm23_wvalid'0
	wire maxi_hbm23_wvalid;
	// {aclk} output bool #()[256] maxi_hbm23_wdata'0
	wire[255:0] maxi_hbm23_wdata;
	// {aclk} output bool #()[32] maxi_hbm23_wstrb'0
	wire[31:0] maxi_hbm23_wstrb;
	// {aclk} output bool #() maxi_hbm23_wlast'0
	wire maxi_hbm23_wlast;
	// {aclk} output bool #() maxi_hbm23_bready'0
	wire maxi_hbm23_bready;
	// {aclk} input bool #() maxi_hbm23_wready'0
	logic maxi_hbm23_wready;
	// {aclk} input bool #() maxi_hbm23_bvalid'0
	logic maxi_hbm23_bvalid;
	// {aclk} input bool #()[2] maxi_hbm23_bresp'0
	logic[1:0] maxi_hbm23_bresp;
	// {aclk} input bool #() maxi_hbm23_awready'0
	logic maxi_hbm23_awready;
	// {aclk} output bool #() maxi_hbm23_arvalid'0
	wire maxi_hbm23_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm23_araddr'0
	wire[63:0] maxi_hbm23_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm23_arlen'0
	wire[7:0] maxi_hbm23_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm23_arsize'0
	wire[2:0] maxi_hbm23_arsize;
	// {aclk} output bool #()[2] maxi_hbm23_arburst'0
	wire[1:0] maxi_hbm23_arburst;
	// {aclk} output bool #()[3] maxi_hbm23_arprot'0
	wire[2:0] maxi_hbm23_arprot;
	// {aclk} output bool #()[4] maxi_hbm23_arcache'0
	wire[3:0] maxi_hbm23_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm23_arqos'0
	wire[3:0] maxi_hbm23_arqos;
	// {aclk} output bool #() maxi_hbm23_arlock'0
	wire maxi_hbm23_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm23_arregion'0
	wire[3:0] maxi_hbm23_arregion;
	// {aclk} output bool #() maxi_hbm23_rready'0
	wire maxi_hbm23_rready;
	// {aclk} input bool #() maxi_hbm23_arready'0
	logic maxi_hbm23_arready;
	// {aclk} input bool #() maxi_hbm23_rvalid'0
	logic maxi_hbm23_rvalid;
	// {aclk} input bool #()[256] maxi_hbm23_rdata'0
	logic[255:0] maxi_hbm23_rdata;
	// {aclk} input bool #()[2] maxi_hbm23_rresp'0
	logic[1:0] maxi_hbm23_rresp;
	// {aclk} input bool #() maxi_hbm23_rlast'0
	logic maxi_hbm23_rlast;
	// HBM24
	// {aclk} output bool #() maxi_hbm24_awvalid'0
	wire maxi_hbm24_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm24_awaddr'0
	wire[63:0] maxi_hbm24_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm24_awlen'0
	wire[7:0] maxi_hbm24_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm24_awsize'0
	wire[2:0] maxi_hbm24_awsize;
	// {aclk} output bool #()[2] maxi_hbm24_awburst'0
	wire[1:0] maxi_hbm24_awburst;
	// {aclk} output bool #()[3] maxi_hbm24_awprot'0
	wire[2:0] maxi_hbm24_awprot;
	// {aclk} output bool #()[4] maxi_hbm24_awcache'0
	wire[3:0] maxi_hbm24_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm24_awqos'0
	wire[3:0] maxi_hbm24_awqos;
	// {aclk} output bool #() maxi_hbm24_awlock'0
	wire maxi_hbm24_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm24_awregion'0
	wire[3:0] maxi_hbm24_awregion;
	// {aclk} output bool #() maxi_hbm24_wvalid'0
	wire maxi_hbm24_wvalid;
	// {aclk} output bool #()[256] maxi_hbm24_wdata'0
	wire[255:0] maxi_hbm24_wdata;
	// {aclk} output bool #()[32] maxi_hbm24_wstrb'0
	wire[31:0] maxi_hbm24_wstrb;
	// {aclk} output bool #() maxi_hbm24_wlast'0
	wire maxi_hbm24_wlast;
	// {aclk} output bool #() maxi_hbm24_bready'0
	wire maxi_hbm24_bready;
	// {aclk} input bool #() maxi_hbm24_wready'0
	logic maxi_hbm24_wready;
	// {aclk} input bool #() maxi_hbm24_bvalid'0
	logic maxi_hbm24_bvalid;
	// {aclk} input bool #()[2] maxi_hbm24_bresp'0
	logic[1:0] maxi_hbm24_bresp;
	// {aclk} input bool #() maxi_hbm24_awready'0
	logic maxi_hbm24_awready;
	// {aclk} output bool #() maxi_hbm24_arvalid'0
	wire maxi_hbm24_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm24_araddr'0
	wire[63:0] maxi_hbm24_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm24_arlen'0
	wire[7:0] maxi_hbm24_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm24_arsize'0
	wire[2:0] maxi_hbm24_arsize;
	// {aclk} output bool #()[2] maxi_hbm24_arburst'0
	wire[1:0] maxi_hbm24_arburst;
	// {aclk} output bool #()[3] maxi_hbm24_arprot'0
	wire[2:0] maxi_hbm24_arprot;
	// {aclk} output bool #()[4] maxi_hbm24_arcache'0
	wire[3:0] maxi_hbm24_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm24_arqos'0
	wire[3:0] maxi_hbm24_arqos;
	// {aclk} output bool #() maxi_hbm24_arlock'0
	wire maxi_hbm24_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm24_arregion'0
	wire[3:0] maxi_hbm24_arregion;
	// {aclk} output bool #() maxi_hbm24_rready'0
	wire maxi_hbm24_rready;
	// {aclk} input bool #() maxi_hbm24_arready'0
	logic maxi_hbm24_arready;
	// {aclk} input bool #() maxi_hbm24_rvalid'0
	logic maxi_hbm24_rvalid;
	// {aclk} input bool #()[256] maxi_hbm24_rdata'0
	logic[255:0] maxi_hbm24_rdata;
	// {aclk} input bool #()[2] maxi_hbm24_rresp'0
	logic[1:0] maxi_hbm24_rresp;
	// {aclk} input bool #() maxi_hbm24_rlast'0
	logic maxi_hbm24_rlast;
	// HBM25
	// {aclk} output bool #() maxi_hbm25_awvalid'0
	wire maxi_hbm25_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm25_awaddr'0
	wire[63:0] maxi_hbm25_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm25_awlen'0
	wire[7:0] maxi_hbm25_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm25_awsize'0
	wire[2:0] maxi_hbm25_awsize;
	// {aclk} output bool #()[2] maxi_hbm25_awburst'0
	wire[1:0] maxi_hbm25_awburst;
	// {aclk} output bool #()[3] maxi_hbm25_awprot'0
	wire[2:0] maxi_hbm25_awprot;
	// {aclk} output bool #()[4] maxi_hbm25_awcache'0
	wire[3:0] maxi_hbm25_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm25_awqos'0
	wire[3:0] maxi_hbm25_awqos;
	// {aclk} output bool #() maxi_hbm25_awlock'0
	wire maxi_hbm25_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm25_awregion'0
	wire[3:0] maxi_hbm25_awregion;
	// {aclk} output bool #() maxi_hbm25_wvalid'0
	wire maxi_hbm25_wvalid;
	// {aclk} output bool #()[256] maxi_hbm25_wdata'0
	wire[255:0] maxi_hbm25_wdata;
	// {aclk} output bool #()[32] maxi_hbm25_wstrb'0
	wire[31:0] maxi_hbm25_wstrb;
	// {aclk} output bool #() maxi_hbm25_wlast'0
	wire maxi_hbm25_wlast;
	// {aclk} output bool #() maxi_hbm25_bready'0
	wire maxi_hbm25_bready;
	// {aclk} input bool #() maxi_hbm25_wready'0
	logic maxi_hbm25_wready;
	// {aclk} input bool #() maxi_hbm25_bvalid'0
	logic maxi_hbm25_bvalid;
	// {aclk} input bool #()[2] maxi_hbm25_bresp'0
	logic[1:0] maxi_hbm25_bresp;
	// {aclk} input bool #() maxi_hbm25_awready'0
	logic maxi_hbm25_awready;
	// {aclk} output bool #() maxi_hbm25_arvalid'0
	wire maxi_hbm25_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm25_araddr'0
	wire[63:0] maxi_hbm25_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm25_arlen'0
	wire[7:0] maxi_hbm25_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm25_arsize'0
	wire[2:0] maxi_hbm25_arsize;
	// {aclk} output bool #()[2] maxi_hbm25_arburst'0
	wire[1:0] maxi_hbm25_arburst;
	// {aclk} output bool #()[3] maxi_hbm25_arprot'0
	wire[2:0] maxi_hbm25_arprot;
	// {aclk} output bool #()[4] maxi_hbm25_arcache'0
	wire[3:0] maxi_hbm25_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm25_arqos'0
	wire[3:0] maxi_hbm25_arqos;
	// {aclk} output bool #() maxi_hbm25_arlock'0
	wire maxi_hbm25_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm25_arregion'0
	wire[3:0] maxi_hbm25_arregion;
	// {aclk} output bool #() maxi_hbm25_rready'0
	wire maxi_hbm25_rready;
	// {aclk} input bool #() maxi_hbm25_arready'0
	logic maxi_hbm25_arready;
	// {aclk} input bool #() maxi_hbm25_rvalid'0
	logic maxi_hbm25_rvalid;
	// {aclk} input bool #()[256] maxi_hbm25_rdata'0
	logic[255:0] maxi_hbm25_rdata;
	// {aclk} input bool #()[2] maxi_hbm25_rresp'0
	logic[1:0] maxi_hbm25_rresp;
	// {aclk} input bool #() maxi_hbm25_rlast'0
	logic maxi_hbm25_rlast;
	// HBM26
	// {aclk} output bool #() maxi_hbm26_awvalid'0
	wire maxi_hbm26_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm26_awaddr'0
	wire[63:0] maxi_hbm26_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm26_awlen'0
	wire[7:0] maxi_hbm26_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm26_awsize'0
	wire[2:0] maxi_hbm26_awsize;
	// {aclk} output bool #()[2] maxi_hbm26_awburst'0
	wire[1:0] maxi_hbm26_awburst;
	// {aclk} output bool #()[3] maxi_hbm26_awprot'0
	wire[2:0] maxi_hbm26_awprot;
	// {aclk} output bool #()[4] maxi_hbm26_awcache'0
	wire[3:0] maxi_hbm26_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm26_awqos'0
	wire[3:0] maxi_hbm26_awqos;
	// {aclk} output bool #() maxi_hbm26_awlock'0
	wire maxi_hbm26_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm26_awregion'0
	wire[3:0] maxi_hbm26_awregion;
	// {aclk} output bool #() maxi_hbm26_wvalid'0
	wire maxi_hbm26_wvalid;
	// {aclk} output bool #()[256] maxi_hbm26_wdata'0
	wire[255:0] maxi_hbm26_wdata;
	// {aclk} output bool #()[32] maxi_hbm26_wstrb'0
	wire[31:0] maxi_hbm26_wstrb;
	// {aclk} output bool #() maxi_hbm26_wlast'0
	wire maxi_hbm26_wlast;
	// {aclk} output bool #() maxi_hbm26_bready'0
	wire maxi_hbm26_bready;
	// {aclk} input bool #() maxi_hbm26_wready'0
	logic maxi_hbm26_wready;
	// {aclk} input bool #() maxi_hbm26_bvalid'0
	logic maxi_hbm26_bvalid;
	// {aclk} input bool #()[2] maxi_hbm26_bresp'0
	logic[1:0] maxi_hbm26_bresp;
	// {aclk} input bool #() maxi_hbm26_awready'0
	logic maxi_hbm26_awready;
	// {aclk} output bool #() maxi_hbm26_arvalid'0
	wire maxi_hbm26_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm26_araddr'0
	wire[63:0] maxi_hbm26_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm26_arlen'0
	wire[7:0] maxi_hbm26_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm26_arsize'0
	wire[2:0] maxi_hbm26_arsize;
	// {aclk} output bool #()[2] maxi_hbm26_arburst'0
	wire[1:0] maxi_hbm26_arburst;
	// {aclk} output bool #()[3] maxi_hbm26_arprot'0
	wire[2:0] maxi_hbm26_arprot;
	// {aclk} output bool #()[4] maxi_hbm26_arcache'0
	wire[3:0] maxi_hbm26_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm26_arqos'0
	wire[3:0] maxi_hbm26_arqos;
	// {aclk} output bool #() maxi_hbm26_arlock'0
	wire maxi_hbm26_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm26_arregion'0
	wire[3:0] maxi_hbm26_arregion;
	// {aclk} output bool #() maxi_hbm26_rready'0
	wire maxi_hbm26_rready;
	// {aclk} input bool #() maxi_hbm26_arready'0
	logic maxi_hbm26_arready;
	// {aclk} input bool #() maxi_hbm26_rvalid'0
	logic maxi_hbm26_rvalid;
	// {aclk} input bool #()[256] maxi_hbm26_rdata'0
	logic[255:0] maxi_hbm26_rdata;
	// {aclk} input bool #()[2] maxi_hbm26_rresp'0
	logic[1:0] maxi_hbm26_rresp;
	// {aclk} input bool #() maxi_hbm26_rlast'0
	logic maxi_hbm26_rlast;
	// HBM27
	// {aclk} output bool #() maxi_hbm27_awvalid'0
	wire maxi_hbm27_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm27_awaddr'0
	wire[63:0] maxi_hbm27_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm27_awlen'0
	wire[7:0] maxi_hbm27_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm27_awsize'0
	wire[2:0] maxi_hbm27_awsize;
	// {aclk} output bool #()[2] maxi_hbm27_awburst'0
	wire[1:0] maxi_hbm27_awburst;
	// {aclk} output bool #()[3] maxi_hbm27_awprot'0
	wire[2:0] maxi_hbm27_awprot;
	// {aclk} output bool #()[4] maxi_hbm27_awcache'0
	wire[3:0] maxi_hbm27_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm27_awqos'0
	wire[3:0] maxi_hbm27_awqos;
	// {aclk} output bool #() maxi_hbm27_awlock'0
	wire maxi_hbm27_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm27_awregion'0
	wire[3:0] maxi_hbm27_awregion;
	// {aclk} output bool #() maxi_hbm27_wvalid'0
	wire maxi_hbm27_wvalid;
	// {aclk} output bool #()[256] maxi_hbm27_wdata'0
	wire[255:0] maxi_hbm27_wdata;
	// {aclk} output bool #()[32] maxi_hbm27_wstrb'0
	wire[31:0] maxi_hbm27_wstrb;
	// {aclk} output bool #() maxi_hbm27_wlast'0
	wire maxi_hbm27_wlast;
	// {aclk} output bool #() maxi_hbm27_bready'0
	wire maxi_hbm27_bready;
	// {aclk} input bool #() maxi_hbm27_wready'0
	logic maxi_hbm27_wready;
	// {aclk} input bool #() maxi_hbm27_bvalid'0
	logic maxi_hbm27_bvalid;
	// {aclk} input bool #()[2] maxi_hbm27_bresp'0
	logic[1:0] maxi_hbm27_bresp;
	// {aclk} input bool #() maxi_hbm27_awready'0
	logic maxi_hbm27_awready;
	// {aclk} output bool #() maxi_hbm27_arvalid'0
	wire maxi_hbm27_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm27_araddr'0
	wire[63:0] maxi_hbm27_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm27_arlen'0
	wire[7:0] maxi_hbm27_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm27_arsize'0
	wire[2:0] maxi_hbm27_arsize;
	// {aclk} output bool #()[2] maxi_hbm27_arburst'0
	wire[1:0] maxi_hbm27_arburst;
	// {aclk} output bool #()[3] maxi_hbm27_arprot'0
	wire[2:0] maxi_hbm27_arprot;
	// {aclk} output bool #()[4] maxi_hbm27_arcache'0
	wire[3:0] maxi_hbm27_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm27_arqos'0
	wire[3:0] maxi_hbm27_arqos;
	// {aclk} output bool #() maxi_hbm27_arlock'0
	wire maxi_hbm27_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm27_arregion'0
	wire[3:0] maxi_hbm27_arregion;
	// {aclk} output bool #() maxi_hbm27_rready'0
	wire maxi_hbm27_rready;
	// {aclk} input bool #() maxi_hbm27_arready'0
	logic maxi_hbm27_arready;
	// {aclk} input bool #() maxi_hbm27_rvalid'0
	logic maxi_hbm27_rvalid;
	// {aclk} input bool #()[256] maxi_hbm27_rdata'0
	logic[255:0] maxi_hbm27_rdata;
	// {aclk} input bool #()[2] maxi_hbm27_rresp'0
	logic[1:0] maxi_hbm27_rresp;
	// {aclk} input bool #() maxi_hbm27_rlast'0
	logic maxi_hbm27_rlast;
	// HBM28
	// {aclk} output bool #() maxi_hbm28_awvalid'0
	wire maxi_hbm28_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm28_awaddr'0
	wire[63:0] maxi_hbm28_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm28_awlen'0
	wire[7:0] maxi_hbm28_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm28_awsize'0
	wire[2:0] maxi_hbm28_awsize;
	// {aclk} output bool #()[2] maxi_hbm28_awburst'0
	wire[1:0] maxi_hbm28_awburst;
	// {aclk} output bool #()[3] maxi_hbm28_awprot'0
	wire[2:0] maxi_hbm28_awprot;
	// {aclk} output bool #()[4] maxi_hbm28_awcache'0
	wire[3:0] maxi_hbm28_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm28_awqos'0
	wire[3:0] maxi_hbm28_awqos;
	// {aclk} output bool #() maxi_hbm28_awlock'0
	wire maxi_hbm28_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm28_awregion'0
	wire[3:0] maxi_hbm28_awregion;
	// {aclk} output bool #() maxi_hbm28_wvalid'0
	wire maxi_hbm28_wvalid;
	// {aclk} output bool #()[256] maxi_hbm28_wdata'0
	wire[255:0] maxi_hbm28_wdata;
	// {aclk} output bool #()[32] maxi_hbm28_wstrb'0
	wire[31:0] maxi_hbm28_wstrb;
	// {aclk} output bool #() maxi_hbm28_wlast'0
	wire maxi_hbm28_wlast;
	// {aclk} output bool #() maxi_hbm28_bready'0
	wire maxi_hbm28_bready;
	// {aclk} input bool #() maxi_hbm28_wready'0
	logic maxi_hbm28_wready;
	// {aclk} input bool #() maxi_hbm28_bvalid'0
	logic maxi_hbm28_bvalid;
	// {aclk} input bool #()[2] maxi_hbm28_bresp'0
	logic[1:0] maxi_hbm28_bresp;
	// {aclk} input bool #() maxi_hbm28_awready'0
	logic maxi_hbm28_awready;
	// {aclk} output bool #() maxi_hbm28_arvalid'0
	wire maxi_hbm28_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm28_araddr'0
	wire[63:0] maxi_hbm28_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm28_arlen'0
	wire[7:0] maxi_hbm28_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm28_arsize'0
	wire[2:0] maxi_hbm28_arsize;
	// {aclk} output bool #()[2] maxi_hbm28_arburst'0
	wire[1:0] maxi_hbm28_arburst;
	// {aclk} output bool #()[3] maxi_hbm28_arprot'0
	wire[2:0] maxi_hbm28_arprot;
	// {aclk} output bool #()[4] maxi_hbm28_arcache'0
	wire[3:0] maxi_hbm28_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm28_arqos'0
	wire[3:0] maxi_hbm28_arqos;
	// {aclk} output bool #() maxi_hbm28_arlock'0
	wire maxi_hbm28_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm28_arregion'0
	wire[3:0] maxi_hbm28_arregion;
	// {aclk} output bool #() maxi_hbm28_rready'0
	wire maxi_hbm28_rready;
	// {aclk} input bool #() maxi_hbm28_arready'0
	logic maxi_hbm28_arready;
	// {aclk} input bool #() maxi_hbm28_rvalid'0
	logic maxi_hbm28_rvalid;
	// {aclk} input bool #()[256] maxi_hbm28_rdata'0
	logic[255:0] maxi_hbm28_rdata;
	// {aclk} input bool #()[2] maxi_hbm28_rresp'0
	logic[1:0] maxi_hbm28_rresp;
	// {aclk} input bool #() maxi_hbm28_rlast'0
	logic maxi_hbm28_rlast;
	// HBM29
	// {aclk} output bool #() maxi_hbm29_awvalid'0
	wire maxi_hbm29_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm29_awaddr'0
	wire[63:0] maxi_hbm29_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm29_awlen'0
	wire[7:0] maxi_hbm29_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm29_awsize'0
	wire[2:0] maxi_hbm29_awsize;
	// {aclk} output bool #()[2] maxi_hbm29_awburst'0
	wire[1:0] maxi_hbm29_awburst;
	// {aclk} output bool #()[3] maxi_hbm29_awprot'0
	wire[2:0] maxi_hbm29_awprot;
	// {aclk} output bool #()[4] maxi_hbm29_awcache'0
	wire[3:0] maxi_hbm29_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm29_awqos'0
	wire[3:0] maxi_hbm29_awqos;
	// {aclk} output bool #() maxi_hbm29_awlock'0
	wire maxi_hbm29_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm29_awregion'0
	wire[3:0] maxi_hbm29_awregion;
	// {aclk} output bool #() maxi_hbm29_wvalid'0
	wire maxi_hbm29_wvalid;
	// {aclk} output bool #()[256] maxi_hbm29_wdata'0
	wire[255:0] maxi_hbm29_wdata;
	// {aclk} output bool #()[32] maxi_hbm29_wstrb'0
	wire[31:0] maxi_hbm29_wstrb;
	// {aclk} output bool #() maxi_hbm29_wlast'0
	wire maxi_hbm29_wlast;
	// {aclk} output bool #() maxi_hbm29_bready'0
	wire maxi_hbm29_bready;
	// {aclk} input bool #() maxi_hbm29_wready'0
	logic maxi_hbm29_wready;
	// {aclk} input bool #() maxi_hbm29_bvalid'0
	logic maxi_hbm29_bvalid;
	// {aclk} input bool #()[2] maxi_hbm29_bresp'0
	logic[1:0] maxi_hbm29_bresp;
	// {aclk} input bool #() maxi_hbm29_awready'0
	logic maxi_hbm29_awready;
	// {aclk} output bool #() maxi_hbm29_arvalid'0
	wire maxi_hbm29_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm29_araddr'0
	wire[63:0] maxi_hbm29_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm29_arlen'0
	wire[7:0] maxi_hbm29_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm29_arsize'0
	wire[2:0] maxi_hbm29_arsize;
	// {aclk} output bool #()[2] maxi_hbm29_arburst'0
	wire[1:0] maxi_hbm29_arburst;
	// {aclk} output bool #()[3] maxi_hbm29_arprot'0
	wire[2:0] maxi_hbm29_arprot;
	// {aclk} output bool #()[4] maxi_hbm29_arcache'0
	wire[3:0] maxi_hbm29_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm29_arqos'0
	wire[3:0] maxi_hbm29_arqos;
	// {aclk} output bool #() maxi_hbm29_arlock'0
	wire maxi_hbm29_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm29_arregion'0
	wire[3:0] maxi_hbm29_arregion;
	// {aclk} output bool #() maxi_hbm29_rready'0
	wire maxi_hbm29_rready;
	// {aclk} input bool #() maxi_hbm29_arready'0
	logic maxi_hbm29_arready;
	// {aclk} input bool #() maxi_hbm29_rvalid'0
	logic maxi_hbm29_rvalid;
	// {aclk} input bool #()[256] maxi_hbm29_rdata'0
	logic[255:0] maxi_hbm29_rdata;
	// {aclk} input bool #()[2] maxi_hbm29_rresp'0
	logic[1:0] maxi_hbm29_rresp;
	// {aclk} input bool #() maxi_hbm29_rlast'0
	logic maxi_hbm29_rlast;
	// HBM30
	// {aclk} output bool #() maxi_hbm30_awvalid'0
	wire maxi_hbm30_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm30_awaddr'0
	wire[63:0] maxi_hbm30_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm30_awlen'0
	wire[7:0] maxi_hbm30_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm30_awsize'0
	wire[2:0] maxi_hbm30_awsize;
	// {aclk} output bool #()[2] maxi_hbm30_awburst'0
	wire[1:0] maxi_hbm30_awburst;
	// {aclk} output bool #()[3] maxi_hbm30_awprot'0
	wire[2:0] maxi_hbm30_awprot;
	// {aclk} output bool #()[4] maxi_hbm30_awcache'0
	wire[3:0] maxi_hbm30_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm30_awqos'0
	wire[3:0] maxi_hbm30_awqos;
	// {aclk} output bool #() maxi_hbm30_awlock'0
	wire maxi_hbm30_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm30_awregion'0
	wire[3:0] maxi_hbm30_awregion;
	// {aclk} output bool #() maxi_hbm30_wvalid'0
	wire maxi_hbm30_wvalid;
	// {aclk} output bool #()[256] maxi_hbm30_wdata'0
	wire[255:0] maxi_hbm30_wdata;
	// {aclk} output bool #()[32] maxi_hbm30_wstrb'0
	wire[31:0] maxi_hbm30_wstrb;
	// {aclk} output bool #() maxi_hbm30_wlast'0
	wire maxi_hbm30_wlast;
	// {aclk} output bool #() maxi_hbm30_bready'0
	wire maxi_hbm30_bready;
	// {aclk} input bool #() maxi_hbm30_wready'0
	logic maxi_hbm30_wready;
	// {aclk} input bool #() maxi_hbm30_bvalid'0
	logic maxi_hbm30_bvalid;
	// {aclk} input bool #()[2] maxi_hbm30_bresp'0
	logic[1:0] maxi_hbm30_bresp;
	// {aclk} input bool #() maxi_hbm30_awready'0
	logic maxi_hbm30_awready;
	// {aclk} output bool #() maxi_hbm30_arvalid'0
	wire maxi_hbm30_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm30_araddr'0
	wire[63:0] maxi_hbm30_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm30_arlen'0
	wire[7:0] maxi_hbm30_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm30_arsize'0
	wire[2:0] maxi_hbm30_arsize;
	// {aclk} output bool #()[2] maxi_hbm30_arburst'0
	wire[1:0] maxi_hbm30_arburst;
	// {aclk} output bool #()[3] maxi_hbm30_arprot'0
	wire[2:0] maxi_hbm30_arprot;
	// {aclk} output bool #()[4] maxi_hbm30_arcache'0
	wire[3:0] maxi_hbm30_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm30_arqos'0
	wire[3:0] maxi_hbm30_arqos;
	// {aclk} output bool #() maxi_hbm30_arlock'0
	wire maxi_hbm30_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm30_arregion'0
	wire[3:0] maxi_hbm30_arregion;
	// {aclk} output bool #() maxi_hbm30_rready'0
	wire maxi_hbm30_rready;
	// {aclk} input bool #() maxi_hbm30_arready'0
	logic maxi_hbm30_arready;
	// {aclk} input bool #() maxi_hbm30_rvalid'0
	logic maxi_hbm30_rvalid;
	// {aclk} input bool #()[256] maxi_hbm30_rdata'0
	logic[255:0] maxi_hbm30_rdata;
	// {aclk} input bool #()[2] maxi_hbm30_rresp'0
	logic[1:0] maxi_hbm30_rresp;
	// {aclk} input bool #() maxi_hbm30_rlast'0
	logic maxi_hbm30_rlast;
	// HBM31
	// {aclk} output bool #() maxi_hbm31_awvalid'0
	wire maxi_hbm31_awvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm31_awaddr'0
	wire[63:0] maxi_hbm31_awaddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm31_awlen'0
	wire[7:0] maxi_hbm31_awlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm31_awsize'0
	wire[2:0] maxi_hbm31_awsize;
	// {aclk} output bool #()[2] maxi_hbm31_awburst'0
	wire[1:0] maxi_hbm31_awburst;
	// {aclk} output bool #()[3] maxi_hbm31_awprot'0
	wire[2:0] maxi_hbm31_awprot;
	// {aclk} output bool #()[4] maxi_hbm31_awcache'0
	wire[3:0] maxi_hbm31_awcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm31_awqos'0
	wire[3:0] maxi_hbm31_awqos;
	// {aclk} output bool #() maxi_hbm31_awlock'0
	wire maxi_hbm31_awlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm31_awregion'0
	wire[3:0] maxi_hbm31_awregion;
	// {aclk} output bool #() maxi_hbm31_wvalid'0
	wire maxi_hbm31_wvalid;
	// {aclk} output bool #()[256] maxi_hbm31_wdata'0
	wire[255:0] maxi_hbm31_wdata;
	// {aclk} output bool #()[32] maxi_hbm31_wstrb'0
	wire[31:0] maxi_hbm31_wstrb;
	// {aclk} output bool #() maxi_hbm31_wlast'0
	wire maxi_hbm31_wlast;
	// {aclk} output bool #() maxi_hbm31_bready'0
	wire maxi_hbm31_bready;
	// {aclk} input bool #() maxi_hbm31_wready'0
	logic maxi_hbm31_wready;
	// {aclk} input bool #() maxi_hbm31_bvalid'0
	logic maxi_hbm31_bvalid;
	// {aclk} input bool #()[2] maxi_hbm31_bresp'0
	logic[1:0] maxi_hbm31_bresp;
	// {aclk} input bool #() maxi_hbm31_awready'0
	logic maxi_hbm31_awready;
	// {aclk} output bool #() maxi_hbm31_arvalid'0
	wire maxi_hbm31_arvalid;
	// {aclk} output int #(FROM: 0, TO: 18446744073709551616) maxi_hbm31_araddr'0
	wire[63:0] maxi_hbm31_araddr;
	// {aclk} output int #(FROM: 0, TO: 256) maxi_hbm31_arlen'0
	wire[7:0] maxi_hbm31_arlen;
	// {aclk} output int #(FROM: 0, TO: 8) maxi_hbm31_arsize'0
	wire[2:0] maxi_hbm31_arsize;
	// {aclk} output bool #()[2] maxi_hbm31_arburst'0
	wire[1:0] maxi_hbm31_arburst;
	// {aclk} output bool #()[3] maxi_hbm31_arprot'0
	wire[2:0] maxi_hbm31_arprot;
	// {aclk} output bool #()[4] maxi_hbm31_arcache'0
	wire[3:0] maxi_hbm31_arcache;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm31_arqos'0
	wire[3:0] maxi_hbm31_arqos;
	// {aclk} output bool #() maxi_hbm31_arlock'0
	wire maxi_hbm31_arlock;
	// {aclk} output int #(FROM: 0, TO: 16) maxi_hbm31_arregion'0
	wire[3:0] maxi_hbm31_arregion;
	// {aclk} output bool #() maxi_hbm31_rready'0
	wire maxi_hbm31_rready;
	// {aclk} input bool #() maxi_hbm31_arready'0
	logic maxi_hbm31_arready;
	// {aclk} input bool #() maxi_hbm31_rvalid'0
	logic maxi_hbm31_rvalid;
	// {aclk} input bool #()[256] maxi_hbm31_rdata'0
	logic[255:0] maxi_hbm31_rdata;
	// {aclk} input bool #()[2] maxi_hbm31_rresp'0
	logic[1:0] maxi_hbm31_rresp;
	// {aclk} input bool #() maxi_hbm31_rlast'0
	logic maxi_hbm31_rlast;

	// DUT
	SUSpMV_Full dut(
		.aclk(aclk),
		.aresetn(aresetn),
		.s_axi_control_awaddr(s_axi_control_awaddr),
		.s_axi_control_awvalid(s_axi_control_awvalid),
		.s_axi_control_awready(s_axi_control_awready),
		.s_axi_control_awprot(s_axi_control_awprot),
		.s_axi_control_wdata(s_axi_control_wdata),
		.s_axi_control_wstrb(s_axi_control_wstrb),
		.s_axi_control_wvalid(s_axi_control_wvalid),
		.s_axi_control_wready(s_axi_control_wready),
		.s_axi_control_bresp(s_axi_control_bresp),
		.s_axi_control_bvalid(s_axi_control_bvalid),
		.s_axi_control_bready(s_axi_control_bready),
		.s_axi_control_araddr(s_axi_control_araddr),
		.s_axi_control_arvalid(s_axi_control_arvalid),
		.s_axi_control_arready(s_axi_control_arready),
		.s_axi_control_arprot(s_axi_control_arprot),
		.s_axi_control_rdata(s_axi_control_rdata),
		.s_axi_control_rresp(s_axi_control_rresp),
		.s_axi_control_rvalid(s_axi_control_rvalid),
		.s_axi_control_rready(s_axi_control_rready),
		.intr(intr),
		.maxi_ddr00_awvalid(maxi_ddr00_awvalid),
		.maxi_ddr00_awready(maxi_ddr00_awready),
		.maxi_ddr00_awaddr(maxi_ddr00_awaddr),
		.maxi_ddr00_awlen(maxi_ddr00_awlen),
		.maxi_ddr00_awsize(maxi_ddr00_awsize),
		.maxi_ddr00_awburst(maxi_ddr00_awburst),
		.maxi_ddr00_awprot(maxi_ddr00_awprot),
		.maxi_ddr00_awcache(maxi_ddr00_awcache),
		.maxi_ddr00_awqos(maxi_ddr00_awqos),
		.maxi_ddr00_awlock(maxi_ddr00_awlock),
		.maxi_ddr00_awregion(maxi_ddr00_awregion),
		.maxi_ddr00_wvalid(maxi_ddr00_wvalid),
		.maxi_ddr00_wready(maxi_ddr00_wready),
		.maxi_ddr00_wdata(maxi_ddr00_wdata),
		.maxi_ddr00_wstrb(maxi_ddr00_wstrb),
		.maxi_ddr00_wlast(maxi_ddr00_wlast),
		.maxi_ddr00_bvalid(maxi_ddr00_bvalid),
		.maxi_ddr00_bready(maxi_ddr00_bready),
		.maxi_ddr00_bresp(maxi_ddr00_bresp),
		.maxi_ddr00_arvalid(maxi_ddr00_arvalid),
		.maxi_ddr00_arready(maxi_ddr00_arready),
		.maxi_ddr00_araddr(maxi_ddr00_araddr),
		.maxi_ddr00_arlen(maxi_ddr00_arlen),
		.maxi_ddr00_arsize(maxi_ddr00_arsize),
		.maxi_ddr00_arburst(maxi_ddr00_arburst),
		.maxi_ddr00_arprot(maxi_ddr00_arprot),
		.maxi_ddr00_arcache(maxi_ddr00_arcache),
		.maxi_ddr00_arqos(maxi_ddr00_arqos),
		.maxi_ddr00_arlock(maxi_ddr00_arlock),
		.maxi_ddr00_arregion(maxi_ddr00_arregion),
		.maxi_ddr00_rvalid(maxi_ddr00_rvalid),
		.maxi_ddr00_rready(maxi_ddr00_rready),
		.maxi_ddr00_rdata(maxi_ddr00_rdata),
		.maxi_ddr00_rresp(maxi_ddr00_rresp),
		.maxi_ddr00_rlast(maxi_ddr00_rlast),
		// HBMs
		.maxi_hbm00_awvalid (maxi_hbm00_awvalid),
		.maxi_hbm00_awaddr  (maxi_hbm00_awaddr),
		.maxi_hbm00_awlen   (maxi_hbm00_awlen),
		.maxi_hbm00_awsize  (maxi_hbm00_awsize),
		.maxi_hbm00_awburst (maxi_hbm00_awburst),
		.maxi_hbm00_awprot  (maxi_hbm00_awprot),
		.maxi_hbm00_awcache (maxi_hbm00_awcache),
		.maxi_hbm00_awqos   (maxi_hbm00_awqos),
		.maxi_hbm00_awlock  (maxi_hbm00_awlock),
		.maxi_hbm00_awregion(maxi_hbm00_awregion),
		.maxi_hbm00_wvalid  (maxi_hbm00_wvalid),
		.maxi_hbm00_wdata   (maxi_hbm00_wdata),
		.maxi_hbm00_wstrb   (maxi_hbm00_wstrb),
		.maxi_hbm00_wlast   (maxi_hbm00_wlast),
		.maxi_hbm00_bready  (maxi_hbm00_bready),
		.maxi_hbm00_wready  (maxi_hbm00_wready),
		.maxi_hbm00_bvalid  (maxi_hbm00_bvalid),
		.maxi_hbm00_bresp   (maxi_hbm00_bresp),
		.maxi_hbm00_awready (maxi_hbm00_awready),
		.maxi_hbm00_arvalid (maxi_hbm00_arvalid),
		.maxi_hbm00_araddr  (maxi_hbm00_araddr),
		.maxi_hbm00_arlen   (maxi_hbm00_arlen),
		.maxi_hbm00_arsize  (maxi_hbm00_arsize),
		.maxi_hbm00_arburst (maxi_hbm00_arburst),
		.maxi_hbm00_arprot  (maxi_hbm00_arprot),
		.maxi_hbm00_arcache (maxi_hbm00_arcache),
		.maxi_hbm00_arqos   (maxi_hbm00_arqos),
		.maxi_hbm00_arlock  (maxi_hbm00_arlock),
		.maxi_hbm00_arregion(maxi_hbm00_arregion),
		.maxi_hbm00_rready  (maxi_hbm00_rready),
		.maxi_hbm00_arready (maxi_hbm00_arready),
		.maxi_hbm00_rvalid  (maxi_hbm00_rvalid),
		.maxi_hbm00_rdata   (maxi_hbm00_rdata),
		.maxi_hbm00_rresp   (maxi_hbm00_rresp),
		.maxi_hbm00_rlast   (maxi_hbm00_rlast),

		.maxi_hbm01_awvalid (maxi_hbm01_awvalid),
		.maxi_hbm01_awaddr  (maxi_hbm01_awaddr),
		.maxi_hbm01_awlen   (maxi_hbm01_awlen),
		.maxi_hbm01_awsize  (maxi_hbm01_awsize),
		.maxi_hbm01_awburst (maxi_hbm01_awburst),
		.maxi_hbm01_awprot  (maxi_hbm01_awprot),
		.maxi_hbm01_awcache (maxi_hbm01_awcache),
		.maxi_hbm01_awqos   (maxi_hbm01_awqos),
		.maxi_hbm01_awlock  (maxi_hbm01_awlock),
		.maxi_hbm01_awregion(maxi_hbm01_awregion),
		.maxi_hbm01_wvalid  (maxi_hbm01_wvalid),
		.maxi_hbm01_wdata   (maxi_hbm01_wdata),
		.maxi_hbm01_wstrb   (maxi_hbm01_wstrb),
		.maxi_hbm01_wlast   (maxi_hbm01_wlast),
		.maxi_hbm01_bready  (maxi_hbm01_bready),
		.maxi_hbm01_wready  (maxi_hbm01_wready),
		.maxi_hbm01_bvalid  (maxi_hbm01_bvalid),
		.maxi_hbm01_bresp   (maxi_hbm01_bresp),
		.maxi_hbm01_awready (maxi_hbm01_awready),
		.maxi_hbm01_arvalid (maxi_hbm01_arvalid),
		.maxi_hbm01_araddr  (maxi_hbm01_araddr),
		.maxi_hbm01_arlen   (maxi_hbm01_arlen),
		.maxi_hbm01_arsize  (maxi_hbm01_arsize),
		.maxi_hbm01_arburst (maxi_hbm01_arburst),
		.maxi_hbm01_arprot  (maxi_hbm01_arprot),
		.maxi_hbm01_arcache (maxi_hbm01_arcache),
		.maxi_hbm01_arqos   (maxi_hbm01_arqos),
		.maxi_hbm01_arlock  (maxi_hbm01_arlock),
		.maxi_hbm01_arregion(maxi_hbm01_arregion),
		.maxi_hbm01_rready  (maxi_hbm01_rready),
		.maxi_hbm01_arready (maxi_hbm01_arready),
		.maxi_hbm01_rvalid  (maxi_hbm01_rvalid),
		.maxi_hbm01_rdata   (maxi_hbm01_rdata),
		.maxi_hbm01_rresp   (maxi_hbm01_rresp),
		.maxi_hbm01_rlast   (maxi_hbm01_rlast),

		.maxi_hbm02_awvalid (maxi_hbm02_awvalid),
		.maxi_hbm02_awaddr  (maxi_hbm02_awaddr),
		.maxi_hbm02_awlen   (maxi_hbm02_awlen),
		.maxi_hbm02_awsize  (maxi_hbm02_awsize),
		.maxi_hbm02_awburst (maxi_hbm02_awburst),
		.maxi_hbm02_awprot  (maxi_hbm02_awprot),
		.maxi_hbm02_awcache (maxi_hbm02_awcache),
		.maxi_hbm02_awqos   (maxi_hbm02_awqos),
		.maxi_hbm02_awlock  (maxi_hbm02_awlock),
		.maxi_hbm02_awregion(maxi_hbm02_awregion),
		.maxi_hbm02_wvalid  (maxi_hbm02_wvalid),
		.maxi_hbm02_wdata   (maxi_hbm02_wdata),
		.maxi_hbm02_wstrb   (maxi_hbm02_wstrb),
		.maxi_hbm02_wlast   (maxi_hbm02_wlast),
		.maxi_hbm02_bready  (maxi_hbm02_bready),
		.maxi_hbm02_wready  (maxi_hbm02_wready),
		.maxi_hbm02_bvalid  (maxi_hbm02_bvalid),
		.maxi_hbm02_bresp   (maxi_hbm02_bresp),
		.maxi_hbm02_awready (maxi_hbm02_awready),
		.maxi_hbm02_arvalid (maxi_hbm02_arvalid),
		.maxi_hbm02_araddr  (maxi_hbm02_araddr),
		.maxi_hbm02_arlen   (maxi_hbm02_arlen),
		.maxi_hbm02_arsize  (maxi_hbm02_arsize),
		.maxi_hbm02_arburst (maxi_hbm02_arburst),
		.maxi_hbm02_arprot  (maxi_hbm02_arprot),
		.maxi_hbm02_arcache (maxi_hbm02_arcache),
		.maxi_hbm02_arqos   (maxi_hbm02_arqos),
		.maxi_hbm02_arlock  (maxi_hbm02_arlock),
		.maxi_hbm02_arregion(maxi_hbm02_arregion),
		.maxi_hbm02_rready  (maxi_hbm02_rready),
		.maxi_hbm02_arready (maxi_hbm02_arready),
		.maxi_hbm02_rvalid  (maxi_hbm02_rvalid),
		.maxi_hbm02_rdata   (maxi_hbm02_rdata),
		.maxi_hbm02_rresp   (maxi_hbm02_rresp),
		.maxi_hbm02_rlast   (maxi_hbm02_rlast),

		.maxi_hbm03_awvalid (maxi_hbm03_awvalid),
		.maxi_hbm03_awaddr  (maxi_hbm03_awaddr),
		.maxi_hbm03_awlen   (maxi_hbm03_awlen),
		.maxi_hbm03_awsize  (maxi_hbm03_awsize),
		.maxi_hbm03_awburst (maxi_hbm03_awburst),
		.maxi_hbm03_awprot  (maxi_hbm03_awprot),
		.maxi_hbm03_awcache (maxi_hbm03_awcache),
		.maxi_hbm03_awqos   (maxi_hbm03_awqos),
		.maxi_hbm03_awlock  (maxi_hbm03_awlock),
		.maxi_hbm03_awregion(maxi_hbm03_awregion),
		.maxi_hbm03_wvalid  (maxi_hbm03_wvalid),
		.maxi_hbm03_wdata   (maxi_hbm03_wdata),
		.maxi_hbm03_wstrb   (maxi_hbm03_wstrb),
		.maxi_hbm03_wlast   (maxi_hbm03_wlast),
		.maxi_hbm03_bready  (maxi_hbm03_bready),
		.maxi_hbm03_wready  (maxi_hbm03_wready),
		.maxi_hbm03_bvalid  (maxi_hbm03_bvalid),
		.maxi_hbm03_bresp   (maxi_hbm03_bresp),
		.maxi_hbm03_awready (maxi_hbm03_awready),
		.maxi_hbm03_arvalid (maxi_hbm03_arvalid),
		.maxi_hbm03_araddr  (maxi_hbm03_araddr),
		.maxi_hbm03_arlen   (maxi_hbm03_arlen),
		.maxi_hbm03_arsize  (maxi_hbm03_arsize),
		.maxi_hbm03_arburst (maxi_hbm03_arburst),
		.maxi_hbm03_arprot  (maxi_hbm03_arprot),
		.maxi_hbm03_arcache (maxi_hbm03_arcache),
		.maxi_hbm03_arqos   (maxi_hbm03_arqos),
		.maxi_hbm03_arlock  (maxi_hbm03_arlock),
		.maxi_hbm03_arregion(maxi_hbm03_arregion),
		.maxi_hbm03_rready  (maxi_hbm03_rready),
		.maxi_hbm03_arready (maxi_hbm03_arready),
		.maxi_hbm03_rvalid  (maxi_hbm03_rvalid),
		.maxi_hbm03_rdata   (maxi_hbm03_rdata),
		.maxi_hbm03_rresp   (maxi_hbm03_rresp),
		.maxi_hbm03_rlast   (maxi_hbm03_rlast),

		.maxi_hbm04_awvalid (maxi_hbm04_awvalid),
		.maxi_hbm04_awaddr  (maxi_hbm04_awaddr),
		.maxi_hbm04_awlen   (maxi_hbm04_awlen),
		.maxi_hbm04_awsize  (maxi_hbm04_awsize),
		.maxi_hbm04_awburst (maxi_hbm04_awburst),
		.maxi_hbm04_awprot  (maxi_hbm04_awprot),
		.maxi_hbm04_awcache (maxi_hbm04_awcache),
		.maxi_hbm04_awqos   (maxi_hbm04_awqos),
		.maxi_hbm04_awlock  (maxi_hbm04_awlock),
		.maxi_hbm04_awregion(maxi_hbm04_awregion),
		.maxi_hbm04_wvalid  (maxi_hbm04_wvalid),
		.maxi_hbm04_wdata   (maxi_hbm04_wdata),
		.maxi_hbm04_wstrb   (maxi_hbm04_wstrb),
		.maxi_hbm04_wlast   (maxi_hbm04_wlast),
		.maxi_hbm04_bready  (maxi_hbm04_bready),
		.maxi_hbm04_wready  (maxi_hbm04_wready),
		.maxi_hbm04_bvalid  (maxi_hbm04_bvalid),
		.maxi_hbm04_bresp   (maxi_hbm04_bresp),
		.maxi_hbm04_awready (maxi_hbm04_awready),
		.maxi_hbm04_arvalid (maxi_hbm04_arvalid),
		.maxi_hbm04_araddr  (maxi_hbm04_araddr),
		.maxi_hbm04_arlen   (maxi_hbm04_arlen),
		.maxi_hbm04_arsize  (maxi_hbm04_arsize),
		.maxi_hbm04_arburst (maxi_hbm04_arburst),
		.maxi_hbm04_arprot  (maxi_hbm04_arprot),
		.maxi_hbm04_arcache (maxi_hbm04_arcache),
		.maxi_hbm04_arqos   (maxi_hbm04_arqos),
		.maxi_hbm04_arlock  (maxi_hbm04_arlock),
		.maxi_hbm04_arregion(maxi_hbm04_arregion),
		.maxi_hbm04_rready  (maxi_hbm04_rready),
		.maxi_hbm04_arready (maxi_hbm04_arready),
		.maxi_hbm04_rvalid  (maxi_hbm04_rvalid),
		.maxi_hbm04_rdata   (maxi_hbm04_rdata),
		.maxi_hbm04_rresp   (maxi_hbm04_rresp),
		.maxi_hbm04_rlast   (maxi_hbm04_rlast),

		.maxi_hbm05_awvalid (maxi_hbm05_awvalid),
		.maxi_hbm05_awaddr  (maxi_hbm05_awaddr),
		.maxi_hbm05_awlen   (maxi_hbm05_awlen),
		.maxi_hbm05_awsize  (maxi_hbm05_awsize),
		.maxi_hbm05_awburst (maxi_hbm05_awburst),
		.maxi_hbm05_awprot  (maxi_hbm05_awprot),
		.maxi_hbm05_awcache (maxi_hbm05_awcache),
		.maxi_hbm05_awqos   (maxi_hbm05_awqos),
		.maxi_hbm05_awlock  (maxi_hbm05_awlock),
		.maxi_hbm05_awregion(maxi_hbm05_awregion),
		.maxi_hbm05_wvalid  (maxi_hbm05_wvalid),
		.maxi_hbm05_wdata   (maxi_hbm05_wdata),
		.maxi_hbm05_wstrb   (maxi_hbm05_wstrb),
		.maxi_hbm05_wlast   (maxi_hbm05_wlast),
		.maxi_hbm05_bready  (maxi_hbm05_bready),
		.maxi_hbm05_wready  (maxi_hbm05_wready),
		.maxi_hbm05_bvalid  (maxi_hbm05_bvalid),
		.maxi_hbm05_bresp   (maxi_hbm05_bresp),
		.maxi_hbm05_awready (maxi_hbm05_awready),
		.maxi_hbm05_arvalid (maxi_hbm05_arvalid),
		.maxi_hbm05_araddr  (maxi_hbm05_araddr),
		.maxi_hbm05_arlen   (maxi_hbm05_arlen),
		.maxi_hbm05_arsize  (maxi_hbm05_arsize),
		.maxi_hbm05_arburst (maxi_hbm05_arburst),
		.maxi_hbm05_arprot  (maxi_hbm05_arprot),
		.maxi_hbm05_arcache (maxi_hbm05_arcache),
		.maxi_hbm05_arqos   (maxi_hbm05_arqos),
		.maxi_hbm05_arlock  (maxi_hbm05_arlock),
		.maxi_hbm05_arregion(maxi_hbm05_arregion),
		.maxi_hbm05_rready  (maxi_hbm05_rready),
		.maxi_hbm05_arready (maxi_hbm05_arready),
		.maxi_hbm05_rvalid  (maxi_hbm05_rvalid),
		.maxi_hbm05_rdata   (maxi_hbm05_rdata),
		.maxi_hbm05_rresp   (maxi_hbm05_rresp),
		.maxi_hbm05_rlast   (maxi_hbm05_rlast),

		.maxi_hbm06_awvalid (maxi_hbm06_awvalid),
		.maxi_hbm06_awaddr  (maxi_hbm06_awaddr),
		.maxi_hbm06_awlen   (maxi_hbm06_awlen),
		.maxi_hbm06_awsize  (maxi_hbm06_awsize),
		.maxi_hbm06_awburst (maxi_hbm06_awburst),
		.maxi_hbm06_awprot  (maxi_hbm06_awprot),
		.maxi_hbm06_awcache (maxi_hbm06_awcache),
		.maxi_hbm06_awqos   (maxi_hbm06_awqos),
		.maxi_hbm06_awlock  (maxi_hbm06_awlock),
		.maxi_hbm06_awregion(maxi_hbm06_awregion),
		.maxi_hbm06_wvalid  (maxi_hbm06_wvalid),
		.maxi_hbm06_wdata   (maxi_hbm06_wdata),
		.maxi_hbm06_wstrb   (maxi_hbm06_wstrb),
		.maxi_hbm06_wlast   (maxi_hbm06_wlast),
		.maxi_hbm06_bready  (maxi_hbm06_bready),
		.maxi_hbm06_wready  (maxi_hbm06_wready),
		.maxi_hbm06_bvalid  (maxi_hbm06_bvalid),
		.maxi_hbm06_bresp   (maxi_hbm06_bresp),
		.maxi_hbm06_awready (maxi_hbm06_awready),
		.maxi_hbm06_arvalid (maxi_hbm06_arvalid),
		.maxi_hbm06_araddr  (maxi_hbm06_araddr),
		.maxi_hbm06_arlen   (maxi_hbm06_arlen),
		.maxi_hbm06_arsize  (maxi_hbm06_arsize),
		.maxi_hbm06_arburst (maxi_hbm06_arburst),
		.maxi_hbm06_arprot  (maxi_hbm06_arprot),
		.maxi_hbm06_arcache (maxi_hbm06_arcache),
		.maxi_hbm06_arqos   (maxi_hbm06_arqos),
		.maxi_hbm06_arlock  (maxi_hbm06_arlock),
		.maxi_hbm06_arregion(maxi_hbm06_arregion),
		.maxi_hbm06_rready  (maxi_hbm06_rready),
		.maxi_hbm06_arready (maxi_hbm06_arready),
		.maxi_hbm06_rvalid  (maxi_hbm06_rvalid),
		.maxi_hbm06_rdata   (maxi_hbm06_rdata),
		.maxi_hbm06_rresp   (maxi_hbm06_rresp),
		.maxi_hbm06_rlast   (maxi_hbm06_rlast),

		.maxi_hbm07_awvalid (maxi_hbm07_awvalid),
		.maxi_hbm07_awaddr  (maxi_hbm07_awaddr),
		.maxi_hbm07_awlen   (maxi_hbm07_awlen),
		.maxi_hbm07_awsize  (maxi_hbm07_awsize),
		.maxi_hbm07_awburst (maxi_hbm07_awburst),
		.maxi_hbm07_awprot  (maxi_hbm07_awprot),
		.maxi_hbm07_awcache (maxi_hbm07_awcache),
		.maxi_hbm07_awqos   (maxi_hbm07_awqos),
		.maxi_hbm07_awlock  (maxi_hbm07_awlock),
		.maxi_hbm07_awregion(maxi_hbm07_awregion),
		.maxi_hbm07_wvalid  (maxi_hbm07_wvalid),
		.maxi_hbm07_wdata   (maxi_hbm07_wdata),
		.maxi_hbm07_wstrb   (maxi_hbm07_wstrb),
		.maxi_hbm07_wlast   (maxi_hbm07_wlast),
		.maxi_hbm07_bready  (maxi_hbm07_bready),
		.maxi_hbm07_wready  (maxi_hbm07_wready),
		.maxi_hbm07_bvalid  (maxi_hbm07_bvalid),
		.maxi_hbm07_bresp   (maxi_hbm07_bresp),
		.maxi_hbm07_awready (maxi_hbm07_awready),
		.maxi_hbm07_arvalid (maxi_hbm07_arvalid),
		.maxi_hbm07_araddr  (maxi_hbm07_araddr),
		.maxi_hbm07_arlen   (maxi_hbm07_arlen),
		.maxi_hbm07_arsize  (maxi_hbm07_arsize),
		.maxi_hbm07_arburst (maxi_hbm07_arburst),
		.maxi_hbm07_arprot  (maxi_hbm07_arprot),
		.maxi_hbm07_arcache (maxi_hbm07_arcache),
		.maxi_hbm07_arqos   (maxi_hbm07_arqos),
		.maxi_hbm07_arlock  (maxi_hbm07_arlock),
		.maxi_hbm07_arregion(maxi_hbm07_arregion),
		.maxi_hbm07_rready  (maxi_hbm07_rready),
		.maxi_hbm07_arready (maxi_hbm07_arready),
		.maxi_hbm07_rvalid  (maxi_hbm07_rvalid),
		.maxi_hbm07_rdata   (maxi_hbm07_rdata),
		.maxi_hbm07_rresp   (maxi_hbm07_rresp),
		.maxi_hbm07_rlast   (maxi_hbm07_rlast),

		.maxi_hbm08_awvalid (maxi_hbm08_awvalid),
		.maxi_hbm08_awaddr  (maxi_hbm08_awaddr),
		.maxi_hbm08_awlen   (maxi_hbm08_awlen),
		.maxi_hbm08_awsize  (maxi_hbm08_awsize),
		.maxi_hbm08_awburst (maxi_hbm08_awburst),
		.maxi_hbm08_awprot  (maxi_hbm08_awprot),
		.maxi_hbm08_awcache (maxi_hbm08_awcache),
		.maxi_hbm08_awqos   (maxi_hbm08_awqos),
		.maxi_hbm08_awlock  (maxi_hbm08_awlock),
		.maxi_hbm08_awregion(maxi_hbm08_awregion),
		.maxi_hbm08_wvalid  (maxi_hbm08_wvalid),
		.maxi_hbm08_wdata   (maxi_hbm08_wdata),
		.maxi_hbm08_wstrb   (maxi_hbm08_wstrb),
		.maxi_hbm08_wlast   (maxi_hbm08_wlast),
		.maxi_hbm08_bready  (maxi_hbm08_bready),
		.maxi_hbm08_wready  (maxi_hbm08_wready),
		.maxi_hbm08_bvalid  (maxi_hbm08_bvalid),
		.maxi_hbm08_bresp   (maxi_hbm08_bresp),
		.maxi_hbm08_awready (maxi_hbm08_awready),
		.maxi_hbm08_arvalid (maxi_hbm08_arvalid),
		.maxi_hbm08_araddr  (maxi_hbm08_araddr),
		.maxi_hbm08_arlen   (maxi_hbm08_arlen),
		.maxi_hbm08_arsize  (maxi_hbm08_arsize),
		.maxi_hbm08_arburst (maxi_hbm08_arburst),
		.maxi_hbm08_arprot  (maxi_hbm08_arprot),
		.maxi_hbm08_arcache (maxi_hbm08_arcache),
		.maxi_hbm08_arqos   (maxi_hbm08_arqos),
		.maxi_hbm08_arlock  (maxi_hbm08_arlock),
		.maxi_hbm08_arregion(maxi_hbm08_arregion),
		.maxi_hbm08_rready  (maxi_hbm08_rready),
		.maxi_hbm08_arready (maxi_hbm08_arready),
		.maxi_hbm08_rvalid  (maxi_hbm08_rvalid),
		.maxi_hbm08_rdata   (maxi_hbm08_rdata),
		.maxi_hbm08_rresp   (maxi_hbm08_rresp),
		.maxi_hbm08_rlast   (maxi_hbm08_rlast),

		.maxi_hbm09_awvalid (maxi_hbm09_awvalid),
		.maxi_hbm09_awaddr  (maxi_hbm09_awaddr),
		.maxi_hbm09_awlen   (maxi_hbm09_awlen),
		.maxi_hbm09_awsize  (maxi_hbm09_awsize),
		.maxi_hbm09_awburst (maxi_hbm09_awburst),
		.maxi_hbm09_awprot  (maxi_hbm09_awprot),
		.maxi_hbm09_awcache (maxi_hbm09_awcache),
		.maxi_hbm09_awqos   (maxi_hbm09_awqos),
		.maxi_hbm09_awlock  (maxi_hbm09_awlock),
		.maxi_hbm09_awregion(maxi_hbm09_awregion),
		.maxi_hbm09_wvalid  (maxi_hbm09_wvalid),
		.maxi_hbm09_wdata   (maxi_hbm09_wdata),
		.maxi_hbm09_wstrb   (maxi_hbm09_wstrb),
		.maxi_hbm09_wlast   (maxi_hbm09_wlast),
		.maxi_hbm09_bready  (maxi_hbm09_bready),
		.maxi_hbm09_wready  (maxi_hbm09_wready),
		.maxi_hbm09_bvalid  (maxi_hbm09_bvalid),
		.maxi_hbm09_bresp   (maxi_hbm09_bresp),
		.maxi_hbm09_awready (maxi_hbm09_awready),
		.maxi_hbm09_arvalid (maxi_hbm09_arvalid),
		.maxi_hbm09_araddr  (maxi_hbm09_araddr),
		.maxi_hbm09_arlen   (maxi_hbm09_arlen),
		.maxi_hbm09_arsize  (maxi_hbm09_arsize),
		.maxi_hbm09_arburst (maxi_hbm09_arburst),
		.maxi_hbm09_arprot  (maxi_hbm09_arprot),
		.maxi_hbm09_arcache (maxi_hbm09_arcache),
		.maxi_hbm09_arqos   (maxi_hbm09_arqos),
		.maxi_hbm09_arlock  (maxi_hbm09_arlock),
		.maxi_hbm09_arregion(maxi_hbm09_arregion),
		.maxi_hbm09_rready  (maxi_hbm09_rready),
		.maxi_hbm09_arready (maxi_hbm09_arready),
		.maxi_hbm09_rvalid  (maxi_hbm09_rvalid),
		.maxi_hbm09_rdata   (maxi_hbm09_rdata),
		.maxi_hbm09_rresp   (maxi_hbm09_rresp),
		.maxi_hbm09_rlast   (maxi_hbm09_rlast),

		.maxi_hbm10_awvalid (maxi_hbm10_awvalid),
		.maxi_hbm10_awaddr  (maxi_hbm10_awaddr),
		.maxi_hbm10_awlen   (maxi_hbm10_awlen),
		.maxi_hbm10_awsize  (maxi_hbm10_awsize),
		.maxi_hbm10_awburst (maxi_hbm10_awburst),
		.maxi_hbm10_awprot  (maxi_hbm10_awprot),
		.maxi_hbm10_awcache (maxi_hbm10_awcache),
		.maxi_hbm10_awqos   (maxi_hbm10_awqos),
		.maxi_hbm10_awlock  (maxi_hbm10_awlock),
		.maxi_hbm10_awregion(maxi_hbm10_awregion),
		.maxi_hbm10_wvalid  (maxi_hbm10_wvalid),
		.maxi_hbm10_wdata   (maxi_hbm10_wdata),
		.maxi_hbm10_wstrb   (maxi_hbm10_wstrb),
		.maxi_hbm10_wlast   (maxi_hbm10_wlast),
		.maxi_hbm10_bready  (maxi_hbm10_bready),
		.maxi_hbm10_wready  (maxi_hbm10_wready),
		.maxi_hbm10_bvalid  (maxi_hbm10_bvalid),
		.maxi_hbm10_bresp   (maxi_hbm10_bresp),
		.maxi_hbm10_awready (maxi_hbm10_awready),
		.maxi_hbm10_arvalid (maxi_hbm10_arvalid),
		.maxi_hbm10_araddr  (maxi_hbm10_araddr),
		.maxi_hbm10_arlen   (maxi_hbm10_arlen),
		.maxi_hbm10_arsize  (maxi_hbm10_arsize),
		.maxi_hbm10_arburst (maxi_hbm10_arburst),
		.maxi_hbm10_arprot  (maxi_hbm10_arprot),
		.maxi_hbm10_arcache (maxi_hbm10_arcache),
		.maxi_hbm10_arqos   (maxi_hbm10_arqos),
		.maxi_hbm10_arlock  (maxi_hbm10_arlock),
		.maxi_hbm10_arregion(maxi_hbm10_arregion),
		.maxi_hbm10_rready  (maxi_hbm10_rready),
		.maxi_hbm10_arready (maxi_hbm10_arready),
		.maxi_hbm10_rvalid  (maxi_hbm10_rvalid),
		.maxi_hbm10_rdata   (maxi_hbm10_rdata),
		.maxi_hbm10_rresp   (maxi_hbm10_rresp),
		.maxi_hbm10_rlast   (maxi_hbm10_rlast),

		.maxi_hbm11_awvalid (maxi_hbm11_awvalid),
		.maxi_hbm11_awaddr  (maxi_hbm11_awaddr),
		.maxi_hbm11_awlen   (maxi_hbm11_awlen),
		.maxi_hbm11_awsize  (maxi_hbm11_awsize),
		.maxi_hbm11_awburst (maxi_hbm11_awburst),
		.maxi_hbm11_awprot  (maxi_hbm11_awprot),
		.maxi_hbm11_awcache (maxi_hbm11_awcache),
		.maxi_hbm11_awqos   (maxi_hbm11_awqos),
		.maxi_hbm11_awlock  (maxi_hbm11_awlock),
		.maxi_hbm11_awregion(maxi_hbm11_awregion),
		.maxi_hbm11_wvalid  (maxi_hbm11_wvalid),
		.maxi_hbm11_wdata   (maxi_hbm11_wdata),
		.maxi_hbm11_wstrb   (maxi_hbm11_wstrb),
		.maxi_hbm11_wlast   (maxi_hbm11_wlast),
		.maxi_hbm11_bready  (maxi_hbm11_bready),
		.maxi_hbm11_wready  (maxi_hbm11_wready),
		.maxi_hbm11_bvalid  (maxi_hbm11_bvalid),
		.maxi_hbm11_bresp   (maxi_hbm11_bresp),
		.maxi_hbm11_awready (maxi_hbm11_awready),
		.maxi_hbm11_arvalid (maxi_hbm11_arvalid),
		.maxi_hbm11_araddr  (maxi_hbm11_araddr),
		.maxi_hbm11_arlen   (maxi_hbm11_arlen),
		.maxi_hbm11_arsize  (maxi_hbm11_arsize),
		.maxi_hbm11_arburst (maxi_hbm11_arburst),
		.maxi_hbm11_arprot  (maxi_hbm11_arprot),
		.maxi_hbm11_arcache (maxi_hbm11_arcache),
		.maxi_hbm11_arqos   (maxi_hbm11_arqos),
		.maxi_hbm11_arlock  (maxi_hbm11_arlock),
		.maxi_hbm11_arregion(maxi_hbm11_arregion),
		.maxi_hbm11_rready  (maxi_hbm11_rready),
		.maxi_hbm11_arready (maxi_hbm11_arready),
		.maxi_hbm11_rvalid  (maxi_hbm11_rvalid),
		.maxi_hbm11_rdata   (maxi_hbm11_rdata),
		.maxi_hbm11_rresp   (maxi_hbm11_rresp),
		.maxi_hbm11_rlast   (maxi_hbm11_rlast),

		.maxi_hbm12_awvalid (maxi_hbm12_awvalid),
		.maxi_hbm12_awaddr  (maxi_hbm12_awaddr),
		.maxi_hbm12_awlen   (maxi_hbm12_awlen),
		.maxi_hbm12_awsize  (maxi_hbm12_awsize),
		.maxi_hbm12_awburst (maxi_hbm12_awburst),
		.maxi_hbm12_awprot  (maxi_hbm12_awprot),
		.maxi_hbm12_awcache (maxi_hbm12_awcache),
		.maxi_hbm12_awqos   (maxi_hbm12_awqos),
		.maxi_hbm12_awlock  (maxi_hbm12_awlock),
		.maxi_hbm12_awregion(maxi_hbm12_awregion),
		.maxi_hbm12_wvalid  (maxi_hbm12_wvalid),
		.maxi_hbm12_wdata   (maxi_hbm12_wdata),
		.maxi_hbm12_wstrb   (maxi_hbm12_wstrb),
		.maxi_hbm12_wlast   (maxi_hbm12_wlast),
		.maxi_hbm12_bready  (maxi_hbm12_bready),
		.maxi_hbm12_wready  (maxi_hbm12_wready),
		.maxi_hbm12_bvalid  (maxi_hbm12_bvalid),
		.maxi_hbm12_bresp   (maxi_hbm12_bresp),
		.maxi_hbm12_awready (maxi_hbm12_awready),
		.maxi_hbm12_arvalid (maxi_hbm12_arvalid),
		.maxi_hbm12_araddr  (maxi_hbm12_araddr),
		.maxi_hbm12_arlen   (maxi_hbm12_arlen),
		.maxi_hbm12_arsize  (maxi_hbm12_arsize),
		.maxi_hbm12_arburst (maxi_hbm12_arburst),
		.maxi_hbm12_arprot  (maxi_hbm12_arprot),
		.maxi_hbm12_arcache (maxi_hbm12_arcache),
		.maxi_hbm12_arqos   (maxi_hbm12_arqos),
		.maxi_hbm12_arlock  (maxi_hbm12_arlock),
		.maxi_hbm12_arregion(maxi_hbm12_arregion),
		.maxi_hbm12_rready  (maxi_hbm12_rready),
		.maxi_hbm12_arready (maxi_hbm12_arready),
		.maxi_hbm12_rvalid  (maxi_hbm12_rvalid),
		.maxi_hbm12_rdata   (maxi_hbm12_rdata),
		.maxi_hbm12_rresp   (maxi_hbm12_rresp),
		.maxi_hbm12_rlast   (maxi_hbm12_rlast),

		.maxi_hbm13_awvalid (maxi_hbm13_awvalid),
		.maxi_hbm13_awaddr  (maxi_hbm13_awaddr),
		.maxi_hbm13_awlen   (maxi_hbm13_awlen),
		.maxi_hbm13_awsize  (maxi_hbm13_awsize),
		.maxi_hbm13_awburst (maxi_hbm13_awburst),
		.maxi_hbm13_awprot  (maxi_hbm13_awprot),
		.maxi_hbm13_awcache (maxi_hbm13_awcache),
		.maxi_hbm13_awqos   (maxi_hbm13_awqos),
		.maxi_hbm13_awlock  (maxi_hbm13_awlock),
		.maxi_hbm13_awregion(maxi_hbm13_awregion),
		.maxi_hbm13_wvalid  (maxi_hbm13_wvalid),
		.maxi_hbm13_wdata   (maxi_hbm13_wdata),
		.maxi_hbm13_wstrb   (maxi_hbm13_wstrb),
		.maxi_hbm13_wlast   (maxi_hbm13_wlast),
		.maxi_hbm13_bready  (maxi_hbm13_bready),
		.maxi_hbm13_wready  (maxi_hbm13_wready),
		.maxi_hbm13_bvalid  (maxi_hbm13_bvalid),
		.maxi_hbm13_bresp   (maxi_hbm13_bresp),
		.maxi_hbm13_awready (maxi_hbm13_awready),
		.maxi_hbm13_arvalid (maxi_hbm13_arvalid),
		.maxi_hbm13_araddr  (maxi_hbm13_araddr),
		.maxi_hbm13_arlen   (maxi_hbm13_arlen),
		.maxi_hbm13_arsize  (maxi_hbm13_arsize),
		.maxi_hbm13_arburst (maxi_hbm13_arburst),
		.maxi_hbm13_arprot  (maxi_hbm13_arprot),
		.maxi_hbm13_arcache (maxi_hbm13_arcache),
		.maxi_hbm13_arqos   (maxi_hbm13_arqos),
		.maxi_hbm13_arlock  (maxi_hbm13_arlock),
		.maxi_hbm13_arregion(maxi_hbm13_arregion),
		.maxi_hbm13_rready  (maxi_hbm13_rready),
		.maxi_hbm13_arready (maxi_hbm13_arready),
		.maxi_hbm13_rvalid  (maxi_hbm13_rvalid),
		.maxi_hbm13_rdata   (maxi_hbm13_rdata),
		.maxi_hbm13_rresp   (maxi_hbm13_rresp),
		.maxi_hbm13_rlast   (maxi_hbm13_rlast),

		.maxi_hbm14_awvalid (maxi_hbm14_awvalid),
		.maxi_hbm14_awaddr  (maxi_hbm14_awaddr),
		.maxi_hbm14_awlen   (maxi_hbm14_awlen),
		.maxi_hbm14_awsize  (maxi_hbm14_awsize),
		.maxi_hbm14_awburst (maxi_hbm14_awburst),
		.maxi_hbm14_awprot  (maxi_hbm14_awprot),
		.maxi_hbm14_awcache (maxi_hbm14_awcache),
		.maxi_hbm14_awqos   (maxi_hbm14_awqos),
		.maxi_hbm14_awlock  (maxi_hbm14_awlock),
		.maxi_hbm14_awregion(maxi_hbm14_awregion),
		.maxi_hbm14_wvalid  (maxi_hbm14_wvalid),
		.maxi_hbm14_wdata   (maxi_hbm14_wdata),
		.maxi_hbm14_wstrb   (maxi_hbm14_wstrb),
		.maxi_hbm14_wlast   (maxi_hbm14_wlast),
		.maxi_hbm14_bready  (maxi_hbm14_bready),
		.maxi_hbm14_wready  (maxi_hbm14_wready),
		.maxi_hbm14_bvalid  (maxi_hbm14_bvalid),
		.maxi_hbm14_bresp   (maxi_hbm14_bresp),
		.maxi_hbm14_awready (maxi_hbm14_awready),
		.maxi_hbm14_arvalid (maxi_hbm14_arvalid),
		.maxi_hbm14_araddr  (maxi_hbm14_araddr),
		.maxi_hbm14_arlen   (maxi_hbm14_arlen),
		.maxi_hbm14_arsize  (maxi_hbm14_arsize),
		.maxi_hbm14_arburst (maxi_hbm14_arburst),
		.maxi_hbm14_arprot  (maxi_hbm14_arprot),
		.maxi_hbm14_arcache (maxi_hbm14_arcache),
		.maxi_hbm14_arqos   (maxi_hbm14_arqos),
		.maxi_hbm14_arlock  (maxi_hbm14_arlock),
		.maxi_hbm14_arregion(maxi_hbm14_arregion),
		.maxi_hbm14_rready  (maxi_hbm14_rready),
		.maxi_hbm14_arready (maxi_hbm14_arready),
		.maxi_hbm14_rvalid  (maxi_hbm14_rvalid),
		.maxi_hbm14_rdata   (maxi_hbm14_rdata),
		.maxi_hbm14_rresp   (maxi_hbm14_rresp),
		.maxi_hbm14_rlast   (maxi_hbm14_rlast),

		.maxi_hbm15_awvalid (maxi_hbm15_awvalid),
		.maxi_hbm15_awaddr  (maxi_hbm15_awaddr),
		.maxi_hbm15_awlen   (maxi_hbm15_awlen),
		.maxi_hbm15_awsize  (maxi_hbm15_awsize),
		.maxi_hbm15_awburst (maxi_hbm15_awburst),
		.maxi_hbm15_awprot  (maxi_hbm15_awprot),
		.maxi_hbm15_awcache (maxi_hbm15_awcache),
		.maxi_hbm15_awqos   (maxi_hbm15_awqos),
		.maxi_hbm15_awlock  (maxi_hbm15_awlock),
		.maxi_hbm15_awregion(maxi_hbm15_awregion),
		.maxi_hbm15_wvalid  (maxi_hbm15_wvalid),
		.maxi_hbm15_wdata   (maxi_hbm15_wdata),
		.maxi_hbm15_wstrb   (maxi_hbm15_wstrb),
		.maxi_hbm15_wlast   (maxi_hbm15_wlast),
		.maxi_hbm15_bready  (maxi_hbm15_bready),
		.maxi_hbm15_wready  (maxi_hbm15_wready),
		.maxi_hbm15_bvalid  (maxi_hbm15_bvalid),
		.maxi_hbm15_bresp   (maxi_hbm15_bresp),
		.maxi_hbm15_awready (maxi_hbm15_awready),
		.maxi_hbm15_arvalid (maxi_hbm15_arvalid),
		.maxi_hbm15_araddr  (maxi_hbm15_araddr),
		.maxi_hbm15_arlen   (maxi_hbm15_arlen),
		.maxi_hbm15_arsize  (maxi_hbm15_arsize),
		.maxi_hbm15_arburst (maxi_hbm15_arburst),
		.maxi_hbm15_arprot  (maxi_hbm15_arprot),
		.maxi_hbm15_arcache (maxi_hbm15_arcache),
		.maxi_hbm15_arqos   (maxi_hbm15_arqos),
		.maxi_hbm15_arlock  (maxi_hbm15_arlock),
		.maxi_hbm15_arregion(maxi_hbm15_arregion),
		.maxi_hbm15_rready  (maxi_hbm15_rready),
		.maxi_hbm15_arready (maxi_hbm15_arready),
		.maxi_hbm15_rvalid  (maxi_hbm15_rvalid),
		.maxi_hbm15_rdata   (maxi_hbm15_rdata),
		.maxi_hbm15_rresp   (maxi_hbm15_rresp),
		.maxi_hbm15_rlast   (maxi_hbm15_rlast),

		.maxi_hbm16_awvalid (maxi_hbm16_awvalid),
		.maxi_hbm16_awaddr  (maxi_hbm16_awaddr),
		.maxi_hbm16_awlen   (maxi_hbm16_awlen),
		.maxi_hbm16_awsize  (maxi_hbm16_awsize),
		.maxi_hbm16_awburst (maxi_hbm16_awburst),
		.maxi_hbm16_awprot  (maxi_hbm16_awprot),
		.maxi_hbm16_awcache (maxi_hbm16_awcache),
		.maxi_hbm16_awqos   (maxi_hbm16_awqos),
		.maxi_hbm16_awlock  (maxi_hbm16_awlock),
		.maxi_hbm16_awregion(maxi_hbm16_awregion),
		.maxi_hbm16_wvalid  (maxi_hbm16_wvalid),
		.maxi_hbm16_wdata   (maxi_hbm16_wdata),
		.maxi_hbm16_wstrb   (maxi_hbm16_wstrb),
		.maxi_hbm16_wlast   (maxi_hbm16_wlast),
		.maxi_hbm16_bready  (maxi_hbm16_bready),
		.maxi_hbm16_wready  (maxi_hbm16_wready),
		.maxi_hbm16_bvalid  (maxi_hbm16_bvalid),
		.maxi_hbm16_bresp   (maxi_hbm16_bresp),
		.maxi_hbm16_awready (maxi_hbm16_awready),
		.maxi_hbm16_arvalid (maxi_hbm16_arvalid),
		.maxi_hbm16_araddr  (maxi_hbm16_araddr),
		.maxi_hbm16_arlen   (maxi_hbm16_arlen),
		.maxi_hbm16_arsize  (maxi_hbm16_arsize),
		.maxi_hbm16_arburst (maxi_hbm16_arburst),
		.maxi_hbm16_arprot  (maxi_hbm16_arprot),
		.maxi_hbm16_arcache (maxi_hbm16_arcache),
		.maxi_hbm16_arqos   (maxi_hbm16_arqos),
		.maxi_hbm16_arlock  (maxi_hbm16_arlock),
		.maxi_hbm16_arregion(maxi_hbm16_arregion),
		.maxi_hbm16_rready  (maxi_hbm16_rready),
		.maxi_hbm16_arready (maxi_hbm16_arready),
		.maxi_hbm16_rvalid  (maxi_hbm16_rvalid),
		.maxi_hbm16_rdata   (maxi_hbm16_rdata),
		.maxi_hbm16_rresp   (maxi_hbm16_rresp),
		.maxi_hbm16_rlast   (maxi_hbm16_rlast),

		.maxi_hbm17_awvalid (maxi_hbm17_awvalid),
		.maxi_hbm17_awaddr  (maxi_hbm17_awaddr),
		.maxi_hbm17_awlen   (maxi_hbm17_awlen),
		.maxi_hbm17_awsize  (maxi_hbm17_awsize),
		.maxi_hbm17_awburst (maxi_hbm17_awburst),
		.maxi_hbm17_awprot  (maxi_hbm17_awprot),
		.maxi_hbm17_awcache (maxi_hbm17_awcache),
		.maxi_hbm17_awqos   (maxi_hbm17_awqos),
		.maxi_hbm17_awlock  (maxi_hbm17_awlock),
		.maxi_hbm17_awregion(maxi_hbm17_awregion),
		.maxi_hbm17_wvalid  (maxi_hbm17_wvalid),
		.maxi_hbm17_wdata   (maxi_hbm17_wdata),
		.maxi_hbm17_wstrb   (maxi_hbm17_wstrb),
		.maxi_hbm17_wlast   (maxi_hbm17_wlast),
		.maxi_hbm17_bready  (maxi_hbm17_bready),
		.maxi_hbm17_wready  (maxi_hbm17_wready),
		.maxi_hbm17_bvalid  (maxi_hbm17_bvalid),
		.maxi_hbm17_bresp   (maxi_hbm17_bresp),
		.maxi_hbm17_awready (maxi_hbm17_awready),
		.maxi_hbm17_arvalid (maxi_hbm17_arvalid),
		.maxi_hbm17_araddr  (maxi_hbm17_araddr),
		.maxi_hbm17_arlen   (maxi_hbm17_arlen),
		.maxi_hbm17_arsize  (maxi_hbm17_arsize),
		.maxi_hbm17_arburst (maxi_hbm17_arburst),
		.maxi_hbm17_arprot  (maxi_hbm17_arprot),
		.maxi_hbm17_arcache (maxi_hbm17_arcache),
		.maxi_hbm17_arqos   (maxi_hbm17_arqos),
		.maxi_hbm17_arlock  (maxi_hbm17_arlock),
		.maxi_hbm17_arregion(maxi_hbm17_arregion),
		.maxi_hbm17_rready  (maxi_hbm17_rready),
		.maxi_hbm17_arready (maxi_hbm17_arready),
		.maxi_hbm17_rvalid  (maxi_hbm17_rvalid),
		.maxi_hbm17_rdata   (maxi_hbm17_rdata),
		.maxi_hbm17_rresp   (maxi_hbm17_rresp),
		.maxi_hbm17_rlast   (maxi_hbm17_rlast),

		.maxi_hbm18_awvalid (maxi_hbm18_awvalid),
		.maxi_hbm18_awaddr  (maxi_hbm18_awaddr),
		.maxi_hbm18_awlen   (maxi_hbm18_awlen),
		.maxi_hbm18_awsize  (maxi_hbm18_awsize),
		.maxi_hbm18_awburst (maxi_hbm18_awburst),
		.maxi_hbm18_awprot  (maxi_hbm18_awprot),
		.maxi_hbm18_awcache (maxi_hbm18_awcache),
		.maxi_hbm18_awqos   (maxi_hbm18_awqos),
		.maxi_hbm18_awlock  (maxi_hbm18_awlock),
		.maxi_hbm18_awregion(maxi_hbm18_awregion),
		.maxi_hbm18_wvalid  (maxi_hbm18_wvalid),
		.maxi_hbm18_wdata   (maxi_hbm18_wdata),
		.maxi_hbm18_wstrb   (maxi_hbm18_wstrb),
		.maxi_hbm18_wlast   (maxi_hbm18_wlast),
		.maxi_hbm18_bready  (maxi_hbm18_bready),
		.maxi_hbm18_wready  (maxi_hbm18_wready),
		.maxi_hbm18_bvalid  (maxi_hbm18_bvalid),
		.maxi_hbm18_bresp   (maxi_hbm18_bresp),
		.maxi_hbm18_awready (maxi_hbm18_awready),
		.maxi_hbm18_arvalid (maxi_hbm18_arvalid),
		.maxi_hbm18_araddr  (maxi_hbm18_araddr),
		.maxi_hbm18_arlen   (maxi_hbm18_arlen),
		.maxi_hbm18_arsize  (maxi_hbm18_arsize),
		.maxi_hbm18_arburst (maxi_hbm18_arburst),
		.maxi_hbm18_arprot  (maxi_hbm18_arprot),
		.maxi_hbm18_arcache (maxi_hbm18_arcache),
		.maxi_hbm18_arqos   (maxi_hbm18_arqos),
		.maxi_hbm18_arlock  (maxi_hbm18_arlock),
		.maxi_hbm18_arregion(maxi_hbm18_arregion),
		.maxi_hbm18_rready  (maxi_hbm18_rready),
		.maxi_hbm18_arready (maxi_hbm18_arready),
		.maxi_hbm18_rvalid  (maxi_hbm18_rvalid),
		.maxi_hbm18_rdata   (maxi_hbm18_rdata),
		.maxi_hbm18_rresp   (maxi_hbm18_rresp),
		.maxi_hbm18_rlast   (maxi_hbm18_rlast),

		.maxi_hbm19_awvalid (maxi_hbm19_awvalid),
		.maxi_hbm19_awaddr  (maxi_hbm19_awaddr),
		.maxi_hbm19_awlen   (maxi_hbm19_awlen),
		.maxi_hbm19_awsize  (maxi_hbm19_awsize),
		.maxi_hbm19_awburst (maxi_hbm19_awburst),
		.maxi_hbm19_awprot  (maxi_hbm19_awprot),
		.maxi_hbm19_awcache (maxi_hbm19_awcache),
		.maxi_hbm19_awqos   (maxi_hbm19_awqos),
		.maxi_hbm19_awlock  (maxi_hbm19_awlock),
		.maxi_hbm19_awregion(maxi_hbm19_awregion),
		.maxi_hbm19_wvalid  (maxi_hbm19_wvalid),
		.maxi_hbm19_wdata   (maxi_hbm19_wdata),
		.maxi_hbm19_wstrb   (maxi_hbm19_wstrb),
		.maxi_hbm19_wlast   (maxi_hbm19_wlast),
		.maxi_hbm19_bready  (maxi_hbm19_bready),
		.maxi_hbm19_wready  (maxi_hbm19_wready),
		.maxi_hbm19_bvalid  (maxi_hbm19_bvalid),
		.maxi_hbm19_bresp   (maxi_hbm19_bresp),
		.maxi_hbm19_awready (maxi_hbm19_awready),
		.maxi_hbm19_arvalid (maxi_hbm19_arvalid),
		.maxi_hbm19_araddr  (maxi_hbm19_araddr),
		.maxi_hbm19_arlen   (maxi_hbm19_arlen),
		.maxi_hbm19_arsize  (maxi_hbm19_arsize),
		.maxi_hbm19_arburst (maxi_hbm19_arburst),
		.maxi_hbm19_arprot  (maxi_hbm19_arprot),
		.maxi_hbm19_arcache (maxi_hbm19_arcache),
		.maxi_hbm19_arqos   (maxi_hbm19_arqos),
		.maxi_hbm19_arlock  (maxi_hbm19_arlock),
		.maxi_hbm19_arregion(maxi_hbm19_arregion),
		.maxi_hbm19_rready  (maxi_hbm19_rready),
		.maxi_hbm19_arready (maxi_hbm19_arready),
		.maxi_hbm19_rvalid  (maxi_hbm19_rvalid),
		.maxi_hbm19_rdata   (maxi_hbm19_rdata),
		.maxi_hbm19_rresp   (maxi_hbm19_rresp),
		.maxi_hbm19_rlast   (maxi_hbm19_rlast),

		.maxi_hbm20_awvalid (maxi_hbm20_awvalid),
		.maxi_hbm20_awaddr  (maxi_hbm20_awaddr),
		.maxi_hbm20_awlen   (maxi_hbm20_awlen),
		.maxi_hbm20_awsize  (maxi_hbm20_awsize),
		.maxi_hbm20_awburst (maxi_hbm20_awburst),
		.maxi_hbm20_awprot  (maxi_hbm20_awprot),
		.maxi_hbm20_awcache (maxi_hbm20_awcache),
		.maxi_hbm20_awqos   (maxi_hbm20_awqos),
		.maxi_hbm20_awlock  (maxi_hbm20_awlock),
		.maxi_hbm20_awregion(maxi_hbm20_awregion),
		.maxi_hbm20_wvalid  (maxi_hbm20_wvalid),
		.maxi_hbm20_wdata   (maxi_hbm20_wdata),
		.maxi_hbm20_wstrb   (maxi_hbm20_wstrb),
		.maxi_hbm20_wlast   (maxi_hbm20_wlast),
		.maxi_hbm20_bready  (maxi_hbm20_bready),
		.maxi_hbm20_wready  (maxi_hbm20_wready),
		.maxi_hbm20_bvalid  (maxi_hbm20_bvalid),
		.maxi_hbm20_bresp   (maxi_hbm20_bresp),
		.maxi_hbm20_awready (maxi_hbm20_awready),
		.maxi_hbm20_arvalid (maxi_hbm20_arvalid),
		.maxi_hbm20_araddr  (maxi_hbm20_araddr),
		.maxi_hbm20_arlen   (maxi_hbm20_arlen),
		.maxi_hbm20_arsize  (maxi_hbm20_arsize),
		.maxi_hbm20_arburst (maxi_hbm20_arburst),
		.maxi_hbm20_arprot  (maxi_hbm20_arprot),
		.maxi_hbm20_arcache (maxi_hbm20_arcache),
		.maxi_hbm20_arqos   (maxi_hbm20_arqos),
		.maxi_hbm20_arlock  (maxi_hbm20_arlock),
		.maxi_hbm20_arregion(maxi_hbm20_arregion),
		.maxi_hbm20_rready  (maxi_hbm20_rready),
		.maxi_hbm20_arready (maxi_hbm20_arready),
		.maxi_hbm20_rvalid  (maxi_hbm20_rvalid),
		.maxi_hbm20_rdata   (maxi_hbm20_rdata),
		.maxi_hbm20_rresp   (maxi_hbm20_rresp),
		.maxi_hbm20_rlast   (maxi_hbm20_rlast),

		.maxi_hbm21_awvalid (maxi_hbm21_awvalid),
		.maxi_hbm21_awaddr  (maxi_hbm21_awaddr),
		.maxi_hbm21_awlen   (maxi_hbm21_awlen),
		.maxi_hbm21_awsize  (maxi_hbm21_awsize),
		.maxi_hbm21_awburst (maxi_hbm21_awburst),
		.maxi_hbm21_awprot  (maxi_hbm21_awprot),
		.maxi_hbm21_awcache (maxi_hbm21_awcache),
		.maxi_hbm21_awqos   (maxi_hbm21_awqos),
		.maxi_hbm21_awlock  (maxi_hbm21_awlock),
		.maxi_hbm21_awregion(maxi_hbm21_awregion),
		.maxi_hbm21_wvalid  (maxi_hbm21_wvalid),
		.maxi_hbm21_wdata   (maxi_hbm21_wdata),
		.maxi_hbm21_wstrb   (maxi_hbm21_wstrb),
		.maxi_hbm21_wlast   (maxi_hbm21_wlast),
		.maxi_hbm21_bready  (maxi_hbm21_bready),
		.maxi_hbm21_wready  (maxi_hbm21_wready),
		.maxi_hbm21_bvalid  (maxi_hbm21_bvalid),
		.maxi_hbm21_bresp   (maxi_hbm21_bresp),
		.maxi_hbm21_awready (maxi_hbm21_awready),
		.maxi_hbm21_arvalid (maxi_hbm21_arvalid),
		.maxi_hbm21_araddr  (maxi_hbm21_araddr),
		.maxi_hbm21_arlen   (maxi_hbm21_arlen),
		.maxi_hbm21_arsize  (maxi_hbm21_arsize),
		.maxi_hbm21_arburst (maxi_hbm21_arburst),
		.maxi_hbm21_arprot  (maxi_hbm21_arprot),
		.maxi_hbm21_arcache (maxi_hbm21_arcache),
		.maxi_hbm21_arqos   (maxi_hbm21_arqos),
		.maxi_hbm21_arlock  (maxi_hbm21_arlock),
		.maxi_hbm21_arregion(maxi_hbm21_arregion),
		.maxi_hbm21_rready  (maxi_hbm21_rready),
		.maxi_hbm21_arready (maxi_hbm21_arready),
		.maxi_hbm21_rvalid  (maxi_hbm21_rvalid),
		.maxi_hbm21_rdata   (maxi_hbm21_rdata),
		.maxi_hbm21_rresp   (maxi_hbm21_rresp),
		.maxi_hbm21_rlast   (maxi_hbm21_rlast),

		.maxi_hbm22_awvalid (maxi_hbm22_awvalid),
		.maxi_hbm22_awaddr  (maxi_hbm22_awaddr),
		.maxi_hbm22_awlen   (maxi_hbm22_awlen),
		.maxi_hbm22_awsize  (maxi_hbm22_awsize),
		.maxi_hbm22_awburst (maxi_hbm22_awburst),
		.maxi_hbm22_awprot  (maxi_hbm22_awprot),
		.maxi_hbm22_awcache (maxi_hbm22_awcache),
		.maxi_hbm22_awqos   (maxi_hbm22_awqos),
		.maxi_hbm22_awlock  (maxi_hbm22_awlock),
		.maxi_hbm22_awregion(maxi_hbm22_awregion),
		.maxi_hbm22_wvalid  (maxi_hbm22_wvalid),
		.maxi_hbm22_wdata   (maxi_hbm22_wdata),
		.maxi_hbm22_wstrb   (maxi_hbm22_wstrb),
		.maxi_hbm22_wlast   (maxi_hbm22_wlast),
		.maxi_hbm22_bready  (maxi_hbm22_bready),
		.maxi_hbm22_wready  (maxi_hbm22_wready),
		.maxi_hbm22_bvalid  (maxi_hbm22_bvalid),
		.maxi_hbm22_bresp   (maxi_hbm22_bresp),
		.maxi_hbm22_awready (maxi_hbm22_awready),
		.maxi_hbm22_arvalid (maxi_hbm22_arvalid),
		.maxi_hbm22_araddr  (maxi_hbm22_araddr),
		.maxi_hbm22_arlen   (maxi_hbm22_arlen),
		.maxi_hbm22_arsize  (maxi_hbm22_arsize),
		.maxi_hbm22_arburst (maxi_hbm22_arburst),
		.maxi_hbm22_arprot  (maxi_hbm22_arprot),
		.maxi_hbm22_arcache (maxi_hbm22_arcache),
		.maxi_hbm22_arqos   (maxi_hbm22_arqos),
		.maxi_hbm22_arlock  (maxi_hbm22_arlock),
		.maxi_hbm22_arregion(maxi_hbm22_arregion),
		.maxi_hbm22_rready  (maxi_hbm22_rready),
		.maxi_hbm22_arready (maxi_hbm22_arready),
		.maxi_hbm22_rvalid  (maxi_hbm22_rvalid),
		.maxi_hbm22_rdata   (maxi_hbm22_rdata),
		.maxi_hbm22_rresp   (maxi_hbm22_rresp),
		.maxi_hbm22_rlast   (maxi_hbm22_rlast),

		.maxi_hbm23_awvalid (maxi_hbm23_awvalid),
		.maxi_hbm23_awaddr  (maxi_hbm23_awaddr),
		.maxi_hbm23_awlen   (maxi_hbm23_awlen),
		.maxi_hbm23_awsize  (maxi_hbm23_awsize),
		.maxi_hbm23_awburst (maxi_hbm23_awburst),
		.maxi_hbm23_awprot  (maxi_hbm23_awprot),
		.maxi_hbm23_awcache (maxi_hbm23_awcache),
		.maxi_hbm23_awqos   (maxi_hbm23_awqos),
		.maxi_hbm23_awlock  (maxi_hbm23_awlock),
		.maxi_hbm23_awregion(maxi_hbm23_awregion),
		.maxi_hbm23_wvalid  (maxi_hbm23_wvalid),
		.maxi_hbm23_wdata   (maxi_hbm23_wdata),
		.maxi_hbm23_wstrb   (maxi_hbm23_wstrb),
		.maxi_hbm23_wlast   (maxi_hbm23_wlast),
		.maxi_hbm23_bready  (maxi_hbm23_bready),
		.maxi_hbm23_wready  (maxi_hbm23_wready),
		.maxi_hbm23_bvalid  (maxi_hbm23_bvalid),
		.maxi_hbm23_bresp   (maxi_hbm23_bresp),
		.maxi_hbm23_awready (maxi_hbm23_awready),
		.maxi_hbm23_arvalid (maxi_hbm23_arvalid),
		.maxi_hbm23_araddr  (maxi_hbm23_araddr),
		.maxi_hbm23_arlen   (maxi_hbm23_arlen),
		.maxi_hbm23_arsize  (maxi_hbm23_arsize),
		.maxi_hbm23_arburst (maxi_hbm23_arburst),
		.maxi_hbm23_arprot  (maxi_hbm23_arprot),
		.maxi_hbm23_arcache (maxi_hbm23_arcache),
		.maxi_hbm23_arqos   (maxi_hbm23_arqos),
		.maxi_hbm23_arlock  (maxi_hbm23_arlock),
		.maxi_hbm23_arregion(maxi_hbm23_arregion),
		.maxi_hbm23_rready  (maxi_hbm23_rready),
		.maxi_hbm23_arready (maxi_hbm23_arready),
		.maxi_hbm23_rvalid  (maxi_hbm23_rvalid),
		.maxi_hbm23_rdata   (maxi_hbm23_rdata),
		.maxi_hbm23_rresp   (maxi_hbm23_rresp),
		.maxi_hbm23_rlast   (maxi_hbm23_rlast),

		.maxi_hbm24_awvalid (maxi_hbm24_awvalid),
		.maxi_hbm24_awaddr  (maxi_hbm24_awaddr),
		.maxi_hbm24_awlen   (maxi_hbm24_awlen),
		.maxi_hbm24_awsize  (maxi_hbm24_awsize),
		.maxi_hbm24_awburst (maxi_hbm24_awburst),
		.maxi_hbm24_awprot  (maxi_hbm24_awprot),
		.maxi_hbm24_awcache (maxi_hbm24_awcache),
		.maxi_hbm24_awqos   (maxi_hbm24_awqos),
		.maxi_hbm24_awlock  (maxi_hbm24_awlock),
		.maxi_hbm24_awregion(maxi_hbm24_awregion),
		.maxi_hbm24_wvalid  (maxi_hbm24_wvalid),
		.maxi_hbm24_wdata   (maxi_hbm24_wdata),
		.maxi_hbm24_wstrb   (maxi_hbm24_wstrb),
		.maxi_hbm24_wlast   (maxi_hbm24_wlast),
		.maxi_hbm24_bready  (maxi_hbm24_bready),
		.maxi_hbm24_wready  (maxi_hbm24_wready),
		.maxi_hbm24_bvalid  (maxi_hbm24_bvalid),
		.maxi_hbm24_bresp   (maxi_hbm24_bresp),
		.maxi_hbm24_awready (maxi_hbm24_awready),
		.maxi_hbm24_arvalid (maxi_hbm24_arvalid),
		.maxi_hbm24_araddr  (maxi_hbm24_araddr),
		.maxi_hbm24_arlen   (maxi_hbm24_arlen),
		.maxi_hbm24_arsize  (maxi_hbm24_arsize),
		.maxi_hbm24_arburst (maxi_hbm24_arburst),
		.maxi_hbm24_arprot  (maxi_hbm24_arprot),
		.maxi_hbm24_arcache (maxi_hbm24_arcache),
		.maxi_hbm24_arqos   (maxi_hbm24_arqos),
		.maxi_hbm24_arlock  (maxi_hbm24_arlock),
		.maxi_hbm24_arregion(maxi_hbm24_arregion),
		.maxi_hbm24_rready  (maxi_hbm24_rready),
		.maxi_hbm24_arready (maxi_hbm24_arready),
		.maxi_hbm24_rvalid  (maxi_hbm24_rvalid),
		.maxi_hbm24_rdata   (maxi_hbm24_rdata),
		.maxi_hbm24_rresp   (maxi_hbm24_rresp),
		.maxi_hbm24_rlast   (maxi_hbm24_rlast),

		.maxi_hbm25_awvalid (maxi_hbm25_awvalid),
		.maxi_hbm25_awaddr  (maxi_hbm25_awaddr),
		.maxi_hbm25_awlen   (maxi_hbm25_awlen),
		.maxi_hbm25_awsize  (maxi_hbm25_awsize),
		.maxi_hbm25_awburst (maxi_hbm25_awburst),
		.maxi_hbm25_awprot  (maxi_hbm25_awprot),
		.maxi_hbm25_awcache (maxi_hbm25_awcache),
		.maxi_hbm25_awqos   (maxi_hbm25_awqos),
		.maxi_hbm25_awlock  (maxi_hbm25_awlock),
		.maxi_hbm25_awregion(maxi_hbm25_awregion),
		.maxi_hbm25_wvalid  (maxi_hbm25_wvalid),
		.maxi_hbm25_wdata   (maxi_hbm25_wdata),
		.maxi_hbm25_wstrb   (maxi_hbm25_wstrb),
		.maxi_hbm25_wlast   (maxi_hbm25_wlast),
		.maxi_hbm25_bready  (maxi_hbm25_bready),
		.maxi_hbm25_wready  (maxi_hbm25_wready),
		.maxi_hbm25_bvalid  (maxi_hbm25_bvalid),
		.maxi_hbm25_bresp   (maxi_hbm25_bresp),
		.maxi_hbm25_awready (maxi_hbm25_awready),
		.maxi_hbm25_arvalid (maxi_hbm25_arvalid),
		.maxi_hbm25_araddr  (maxi_hbm25_araddr),
		.maxi_hbm25_arlen   (maxi_hbm25_arlen),
		.maxi_hbm25_arsize  (maxi_hbm25_arsize),
		.maxi_hbm25_arburst (maxi_hbm25_arburst),
		.maxi_hbm25_arprot  (maxi_hbm25_arprot),
		.maxi_hbm25_arcache (maxi_hbm25_arcache),
		.maxi_hbm25_arqos   (maxi_hbm25_arqos),
		.maxi_hbm25_arlock  (maxi_hbm25_arlock),
		.maxi_hbm25_arregion(maxi_hbm25_arregion),
		.maxi_hbm25_rready  (maxi_hbm25_rready),
		.maxi_hbm25_arready (maxi_hbm25_arready),
		.maxi_hbm25_rvalid  (maxi_hbm25_rvalid),
		.maxi_hbm25_rdata   (maxi_hbm25_rdata),
		.maxi_hbm25_rresp   (maxi_hbm25_rresp),
		.maxi_hbm25_rlast   (maxi_hbm25_rlast),

		.maxi_hbm26_awvalid (maxi_hbm26_awvalid),
		.maxi_hbm26_awaddr  (maxi_hbm26_awaddr),
		.maxi_hbm26_awlen   (maxi_hbm26_awlen),
		.maxi_hbm26_awsize  (maxi_hbm26_awsize),
		.maxi_hbm26_awburst (maxi_hbm26_awburst),
		.maxi_hbm26_awprot  (maxi_hbm26_awprot),
		.maxi_hbm26_awcache (maxi_hbm26_awcache),
		.maxi_hbm26_awqos   (maxi_hbm26_awqos),
		.maxi_hbm26_awlock  (maxi_hbm26_awlock),
		.maxi_hbm26_awregion(maxi_hbm26_awregion),
		.maxi_hbm26_wvalid  (maxi_hbm26_wvalid),
		.maxi_hbm26_wdata   (maxi_hbm26_wdata),
		.maxi_hbm26_wstrb   (maxi_hbm26_wstrb),
		.maxi_hbm26_wlast   (maxi_hbm26_wlast),
		.maxi_hbm26_bready  (maxi_hbm26_bready),
		.maxi_hbm26_wready  (maxi_hbm26_wready),
		.maxi_hbm26_bvalid  (maxi_hbm26_bvalid),
		.maxi_hbm26_bresp   (maxi_hbm26_bresp),
		.maxi_hbm26_awready (maxi_hbm26_awready),
		.maxi_hbm26_arvalid (maxi_hbm26_arvalid),
		.maxi_hbm26_araddr  (maxi_hbm26_araddr),
		.maxi_hbm26_arlen   (maxi_hbm26_arlen),
		.maxi_hbm26_arsize  (maxi_hbm26_arsize),
		.maxi_hbm26_arburst (maxi_hbm26_arburst),
		.maxi_hbm26_arprot  (maxi_hbm26_arprot),
		.maxi_hbm26_arcache (maxi_hbm26_arcache),
		.maxi_hbm26_arqos   (maxi_hbm26_arqos),
		.maxi_hbm26_arlock  (maxi_hbm26_arlock),
		.maxi_hbm26_arregion(maxi_hbm26_arregion),
		.maxi_hbm26_rready  (maxi_hbm26_rready),
		.maxi_hbm26_arready (maxi_hbm26_arready),
		.maxi_hbm26_rvalid  (maxi_hbm26_rvalid),
		.maxi_hbm26_rdata   (maxi_hbm26_rdata),
		.maxi_hbm26_rresp   (maxi_hbm26_rresp),
		.maxi_hbm26_rlast   (maxi_hbm26_rlast),

		.maxi_hbm27_awvalid (maxi_hbm27_awvalid),
		.maxi_hbm27_awaddr  (maxi_hbm27_awaddr),
		.maxi_hbm27_awlen   (maxi_hbm27_awlen),
		.maxi_hbm27_awsize  (maxi_hbm27_awsize),
		.maxi_hbm27_awburst (maxi_hbm27_awburst),
		.maxi_hbm27_awprot  (maxi_hbm27_awprot),
		.maxi_hbm27_awcache (maxi_hbm27_awcache),
		.maxi_hbm27_awqos   (maxi_hbm27_awqos),
		.maxi_hbm27_awlock  (maxi_hbm27_awlock),
		.maxi_hbm27_awregion(maxi_hbm27_awregion),
		.maxi_hbm27_wvalid  (maxi_hbm27_wvalid),
		.maxi_hbm27_wdata   (maxi_hbm27_wdata),
		.maxi_hbm27_wstrb   (maxi_hbm27_wstrb),
		.maxi_hbm27_wlast   (maxi_hbm27_wlast),
		.maxi_hbm27_bready  (maxi_hbm27_bready),
		.maxi_hbm27_wready  (maxi_hbm27_wready),
		.maxi_hbm27_bvalid  (maxi_hbm27_bvalid),
		.maxi_hbm27_bresp   (maxi_hbm27_bresp),
		.maxi_hbm27_awready (maxi_hbm27_awready),
		.maxi_hbm27_arvalid (maxi_hbm27_arvalid),
		.maxi_hbm27_araddr  (maxi_hbm27_araddr),
		.maxi_hbm27_arlen   (maxi_hbm27_arlen),
		.maxi_hbm27_arsize  (maxi_hbm27_arsize),
		.maxi_hbm27_arburst (maxi_hbm27_arburst),
		.maxi_hbm27_arprot  (maxi_hbm27_arprot),
		.maxi_hbm27_arcache (maxi_hbm27_arcache),
		.maxi_hbm27_arqos   (maxi_hbm27_arqos),
		.maxi_hbm27_arlock  (maxi_hbm27_arlock),
		.maxi_hbm27_arregion(maxi_hbm27_arregion),
		.maxi_hbm27_rready  (maxi_hbm27_rready),
		.maxi_hbm27_arready (maxi_hbm27_arready),
		.maxi_hbm27_rvalid  (maxi_hbm27_rvalid),
		.maxi_hbm27_rdata   (maxi_hbm27_rdata),
		.maxi_hbm27_rresp   (maxi_hbm27_rresp),
		.maxi_hbm27_rlast   (maxi_hbm27_rlast),

		.maxi_hbm28_awvalid (maxi_hbm28_awvalid),
		.maxi_hbm28_awaddr  (maxi_hbm28_awaddr),
		.maxi_hbm28_awlen   (maxi_hbm28_awlen),
		.maxi_hbm28_awsize  (maxi_hbm28_awsize),
		.maxi_hbm28_awburst (maxi_hbm28_awburst),
		.maxi_hbm28_awprot  (maxi_hbm28_awprot),
		.maxi_hbm28_awcache (maxi_hbm28_awcache),
		.maxi_hbm28_awqos   (maxi_hbm28_awqos),
		.maxi_hbm28_awlock  (maxi_hbm28_awlock),
		.maxi_hbm28_awregion(maxi_hbm28_awregion),
		.maxi_hbm28_wvalid  (maxi_hbm28_wvalid),
		.maxi_hbm28_wdata   (maxi_hbm28_wdata),
		.maxi_hbm28_wstrb   (maxi_hbm28_wstrb),
		.maxi_hbm28_wlast   (maxi_hbm28_wlast),
		.maxi_hbm28_bready  (maxi_hbm28_bready),
		.maxi_hbm28_wready  (maxi_hbm28_wready),
		.maxi_hbm28_bvalid  (maxi_hbm28_bvalid),
		.maxi_hbm28_bresp   (maxi_hbm28_bresp),
		.maxi_hbm28_awready (maxi_hbm28_awready),
		.maxi_hbm28_arvalid (maxi_hbm28_arvalid),
		.maxi_hbm28_araddr  (maxi_hbm28_araddr),
		.maxi_hbm28_arlen   (maxi_hbm28_arlen),
		.maxi_hbm28_arsize  (maxi_hbm28_arsize),
		.maxi_hbm28_arburst (maxi_hbm28_arburst),
		.maxi_hbm28_arprot  (maxi_hbm28_arprot),
		.maxi_hbm28_arcache (maxi_hbm28_arcache),
		.maxi_hbm28_arqos   (maxi_hbm28_arqos),
		.maxi_hbm28_arlock  (maxi_hbm28_arlock),
		.maxi_hbm28_arregion(maxi_hbm28_arregion),
		.maxi_hbm28_rready  (maxi_hbm28_rready),
		.maxi_hbm28_arready (maxi_hbm28_arready),
		.maxi_hbm28_rvalid  (maxi_hbm28_rvalid),
		.maxi_hbm28_rdata   (maxi_hbm28_rdata),
		.maxi_hbm28_rresp   (maxi_hbm28_rresp),
		.maxi_hbm28_rlast   (maxi_hbm28_rlast),

		.maxi_hbm29_awvalid (maxi_hbm29_awvalid),
		.maxi_hbm29_awaddr  (maxi_hbm29_awaddr),
		.maxi_hbm29_awlen   (maxi_hbm29_awlen),
		.maxi_hbm29_awsize  (maxi_hbm29_awsize),
		.maxi_hbm29_awburst (maxi_hbm29_awburst),
		.maxi_hbm29_awprot  (maxi_hbm29_awprot),
		.maxi_hbm29_awcache (maxi_hbm29_awcache),
		.maxi_hbm29_awqos   (maxi_hbm29_awqos),
		.maxi_hbm29_awlock  (maxi_hbm29_awlock),
		.maxi_hbm29_awregion(maxi_hbm29_awregion),
		.maxi_hbm29_wvalid  (maxi_hbm29_wvalid),
		.maxi_hbm29_wdata   (maxi_hbm29_wdata),
		.maxi_hbm29_wstrb   (maxi_hbm29_wstrb),
		.maxi_hbm29_wlast   (maxi_hbm29_wlast),
		.maxi_hbm29_bready  (maxi_hbm29_bready),
		.maxi_hbm29_wready  (maxi_hbm29_wready),
		.maxi_hbm29_bvalid  (maxi_hbm29_bvalid),
		.maxi_hbm29_bresp   (maxi_hbm29_bresp),
		.maxi_hbm29_awready (maxi_hbm29_awready),
		.maxi_hbm29_arvalid (maxi_hbm29_arvalid),
		.maxi_hbm29_araddr  (maxi_hbm29_araddr),
		.maxi_hbm29_arlen   (maxi_hbm29_arlen),
		.maxi_hbm29_arsize  (maxi_hbm29_arsize),
		.maxi_hbm29_arburst (maxi_hbm29_arburst),
		.maxi_hbm29_arprot  (maxi_hbm29_arprot),
		.maxi_hbm29_arcache (maxi_hbm29_arcache),
		.maxi_hbm29_arqos   (maxi_hbm29_arqos),
		.maxi_hbm29_arlock  (maxi_hbm29_arlock),
		.maxi_hbm29_arregion(maxi_hbm29_arregion),
		.maxi_hbm29_rready  (maxi_hbm29_rready),
		.maxi_hbm29_arready (maxi_hbm29_arready),
		.maxi_hbm29_rvalid  (maxi_hbm29_rvalid),
		.maxi_hbm29_rdata   (maxi_hbm29_rdata),
		.maxi_hbm29_rresp   (maxi_hbm29_rresp),
		.maxi_hbm29_rlast   (maxi_hbm29_rlast),

		.maxi_hbm30_awvalid (maxi_hbm30_awvalid),
		.maxi_hbm30_awaddr  (maxi_hbm30_awaddr),
		.maxi_hbm30_awlen   (maxi_hbm30_awlen),
		.maxi_hbm30_awsize  (maxi_hbm30_awsize),
		.maxi_hbm30_awburst (maxi_hbm30_awburst),
		.maxi_hbm30_awprot  (maxi_hbm30_awprot),
		.maxi_hbm30_awcache (maxi_hbm30_awcache),
		.maxi_hbm30_awqos   (maxi_hbm30_awqos),
		.maxi_hbm30_awlock  (maxi_hbm30_awlock),
		.maxi_hbm30_awregion(maxi_hbm30_awregion),
		.maxi_hbm30_wvalid  (maxi_hbm30_wvalid),
		.maxi_hbm30_wdata   (maxi_hbm30_wdata),
		.maxi_hbm30_wstrb   (maxi_hbm30_wstrb),
		.maxi_hbm30_wlast   (maxi_hbm30_wlast),
		.maxi_hbm30_bready  (maxi_hbm30_bready),
		.maxi_hbm30_wready  (maxi_hbm30_wready),
		.maxi_hbm30_bvalid  (maxi_hbm30_bvalid),
		.maxi_hbm30_bresp   (maxi_hbm30_bresp),
		.maxi_hbm30_awready (maxi_hbm30_awready),
		.maxi_hbm30_arvalid (maxi_hbm30_arvalid),
		.maxi_hbm30_araddr  (maxi_hbm30_araddr),
		.maxi_hbm30_arlen   (maxi_hbm30_arlen),
		.maxi_hbm30_arsize  (maxi_hbm30_arsize),
		.maxi_hbm30_arburst (maxi_hbm30_arburst),
		.maxi_hbm30_arprot  (maxi_hbm30_arprot),
		.maxi_hbm30_arcache (maxi_hbm30_arcache),
		.maxi_hbm30_arqos   (maxi_hbm30_arqos),
		.maxi_hbm30_arlock  (maxi_hbm30_arlock),
		.maxi_hbm30_arregion(maxi_hbm30_arregion),
		.maxi_hbm30_rready  (maxi_hbm30_rready),
		.maxi_hbm30_arready (maxi_hbm30_arready),
		.maxi_hbm30_rvalid  (maxi_hbm30_rvalid),
		.maxi_hbm30_rdata   (maxi_hbm30_rdata),
		.maxi_hbm30_rresp   (maxi_hbm30_rresp),
		.maxi_hbm30_rlast   (maxi_hbm30_rlast),

		.maxi_hbm31_awvalid (maxi_hbm31_awvalid),
		.maxi_hbm31_awaddr  (maxi_hbm31_awaddr),
		.maxi_hbm31_awlen   (maxi_hbm31_awlen),
		.maxi_hbm31_awsize  (maxi_hbm31_awsize),
		.maxi_hbm31_awburst (maxi_hbm31_awburst),
		.maxi_hbm31_awprot  (maxi_hbm31_awprot),
		.maxi_hbm31_awcache (maxi_hbm31_awcache),
		.maxi_hbm31_awqos   (maxi_hbm31_awqos),
		.maxi_hbm31_awlock  (maxi_hbm31_awlock),
		.maxi_hbm31_awregion(maxi_hbm31_awregion),
		.maxi_hbm31_wvalid  (maxi_hbm31_wvalid),
		.maxi_hbm31_wdata   (maxi_hbm31_wdata),
		.maxi_hbm31_wstrb   (maxi_hbm31_wstrb),
		.maxi_hbm31_wlast   (maxi_hbm31_wlast),
		.maxi_hbm31_bready  (maxi_hbm31_bready),
		.maxi_hbm31_wready  (maxi_hbm31_wready),
		.maxi_hbm31_bvalid  (maxi_hbm31_bvalid),
		.maxi_hbm31_bresp   (maxi_hbm31_bresp),
		.maxi_hbm31_awready (maxi_hbm31_awready),
		.maxi_hbm31_arvalid (maxi_hbm31_arvalid),
		.maxi_hbm31_araddr  (maxi_hbm31_araddr),
		.maxi_hbm31_arlen   (maxi_hbm31_arlen),
		.maxi_hbm31_arsize  (maxi_hbm31_arsize),
		.maxi_hbm31_arburst (maxi_hbm31_arburst),
		.maxi_hbm31_arprot  (maxi_hbm31_arprot),
		.maxi_hbm31_arcache (maxi_hbm31_arcache),
		.maxi_hbm31_arqos   (maxi_hbm31_arqos),
		.maxi_hbm31_arlock  (maxi_hbm31_arlock),
		.maxi_hbm31_arregion(maxi_hbm31_arregion),
		.maxi_hbm31_rready  (maxi_hbm31_rready),
		.maxi_hbm31_arready (maxi_hbm31_arready),
		.maxi_hbm31_rvalid  (maxi_hbm31_rvalid),
		.maxi_hbm31_rdata   (maxi_hbm31_rdata),
		.maxi_hbm31_rresp   (maxi_hbm31_rresp),
		.maxi_hbm31_rlast   (maxi_hbm31_rlast)
	);

	simple_axi_mem #(
		.ADDR_WIDTH (64),
		.DATA_WIDTH (512),
		.DEPTH  (`Y_VEC_START_ADDR*2)
	) ddr_mem (
		.aclk    (aclk),
		.aresetn  (aresetn),
		.awvalid (maxi_ddr00_awvalid),
		.awready (maxi_ddr00_awready),
		.awaddr  (maxi_ddr00_awaddr),
		.awlen   (maxi_ddr00_awlen),
		.awsize  (maxi_ddr00_awsize),
		.awburst (maxi_ddr00_awburst),
		.wvalid  (maxi_ddr00_wvalid),
		.wready  (maxi_ddr00_wready),
		.wdata   (maxi_ddr00_wdata),
		.wstrb   (maxi_ddr00_wstrb),
		.wlast   (maxi_ddr00_wlast),
		.bvalid  (maxi_ddr00_bvalid),
		.bready  (maxi_ddr00_bready),
		.bresp   (maxi_ddr00_bresp),
		.arvalid (maxi_ddr00_arvalid),
		.arready (maxi_ddr00_arready),
		.araddr  (maxi_ddr00_araddr),
		.arlen   (maxi_ddr00_arlen),
		.arsize  (maxi_ddr00_arsize),
		.arburst (maxi_ddr00_arburst),
		.rvalid  (maxi_ddr00_rvalid),
		.rready  (maxi_ddr00_rready),
		.rdata   (maxi_ddr00_rdata),
		.rresp   (maxi_ddr00_rresp),
		.rlast   (maxi_ddr00_rlast)
	);


simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm00_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm00_awvalid),
        .awready (maxi_hbm00_awready),
        .awaddr  (maxi_hbm00_awaddr),
        .awlen   (maxi_hbm00_awlen),
        .awsize  (maxi_hbm00_awsize),
        .awburst (maxi_hbm00_awburst),
        .wvalid  (maxi_hbm00_wvalid),
        .wready  (maxi_hbm00_wready),
        .wdata   (maxi_hbm00_wdata),
        .wstrb   (maxi_hbm00_wstrb),
        .wlast   (maxi_hbm00_wlast),
        .bvalid  (maxi_hbm00_bvalid),
        .bready  (maxi_hbm00_bready),
        .bresp   (maxi_hbm00_bresp),
        .arvalid (maxi_hbm00_arvalid),
        .arready (maxi_hbm00_arready),
        .araddr  (maxi_hbm00_araddr),
        .arlen   (maxi_hbm00_arlen),
        .arsize  (maxi_hbm00_arsize),
        .arburst (maxi_hbm00_arburst),
        .rvalid  (maxi_hbm00_rvalid),
        .rready  (maxi_hbm00_rready),
        .rdata   (maxi_hbm00_rdata),
        .rresp   (maxi_hbm00_rresp),
        .rlast   (maxi_hbm00_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm01_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm01_awvalid),
        .awready (maxi_hbm01_awready),
        .awaddr  (maxi_hbm01_awaddr),
        .awlen   (maxi_hbm01_awlen),
        .awsize  (maxi_hbm01_awsize),
        .awburst (maxi_hbm01_awburst),
        .wvalid  (maxi_hbm01_wvalid),
        .wready  (maxi_hbm01_wready),
        .wdata   (maxi_hbm01_wdata),
        .wstrb   (maxi_hbm01_wstrb),
        .wlast   (maxi_hbm01_wlast),
        .bvalid  (maxi_hbm01_bvalid),
        .bready  (maxi_hbm01_bready),
        .bresp   (maxi_hbm01_bresp),
        .arvalid (maxi_hbm01_arvalid),
        .arready (maxi_hbm01_arready),
        .araddr  (maxi_hbm01_araddr),
        .arlen   (maxi_hbm01_arlen),
        .arsize  (maxi_hbm01_arsize),
        .arburst (maxi_hbm01_arburst),
        .rvalid  (maxi_hbm01_rvalid),
        .rready  (maxi_hbm01_rready),
        .rdata   (maxi_hbm01_rdata),
        .rresp   (maxi_hbm01_rresp),
        .rlast   (maxi_hbm01_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm02_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm02_awvalid),
        .awready (maxi_hbm02_awready),
        .awaddr  (maxi_hbm02_awaddr),
        .awlen   (maxi_hbm02_awlen),
        .awsize  (maxi_hbm02_awsize),
        .awburst (maxi_hbm02_awburst),
        .wvalid  (maxi_hbm02_wvalid),
        .wready  (maxi_hbm02_wready),
        .wdata   (maxi_hbm02_wdata),
        .wstrb   (maxi_hbm02_wstrb),
        .wlast   (maxi_hbm02_wlast),
        .bvalid  (maxi_hbm02_bvalid),
        .bready  (maxi_hbm02_bready),
        .bresp   (maxi_hbm02_bresp),
        .arvalid (maxi_hbm02_arvalid),
        .arready (maxi_hbm02_arready),
        .araddr  (maxi_hbm02_araddr),
        .arlen   (maxi_hbm02_arlen),
        .arsize  (maxi_hbm02_arsize),
        .arburst (maxi_hbm02_arburst),
        .rvalid  (maxi_hbm02_rvalid),
        .rready  (maxi_hbm02_rready),
        .rdata   (maxi_hbm02_rdata),
        .rresp   (maxi_hbm02_rresp),
        .rlast   (maxi_hbm02_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm03_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm03_awvalid),
        .awready (maxi_hbm03_awready),
        .awaddr  (maxi_hbm03_awaddr),
        .awlen   (maxi_hbm03_awlen),
        .awsize  (maxi_hbm03_awsize),
        .awburst (maxi_hbm03_awburst),
        .wvalid  (maxi_hbm03_wvalid),
        .wready  (maxi_hbm03_wready),
        .wdata   (maxi_hbm03_wdata),
        .wstrb   (maxi_hbm03_wstrb),
        .wlast   (maxi_hbm03_wlast),
        .bvalid  (maxi_hbm03_bvalid),
        .bready  (maxi_hbm03_bready),
        .bresp   (maxi_hbm03_bresp),
        .arvalid (maxi_hbm03_arvalid),
        .arready (maxi_hbm03_arready),
        .araddr  (maxi_hbm03_araddr),
        .arlen   (maxi_hbm03_arlen),
        .arsize  (maxi_hbm03_arsize),
        .arburst (maxi_hbm03_arburst),
        .rvalid  (maxi_hbm03_rvalid),
        .rready  (maxi_hbm03_rready),
        .rdata   (maxi_hbm03_rdata),
        .rresp   (maxi_hbm03_rresp),
        .rlast   (maxi_hbm03_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm04_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm04_awvalid),
        .awready (maxi_hbm04_awready),
        .awaddr  (maxi_hbm04_awaddr),
        .awlen   (maxi_hbm04_awlen),
        .awsize  (maxi_hbm04_awsize),
        .awburst (maxi_hbm04_awburst),
        .wvalid  (maxi_hbm04_wvalid),
        .wready  (maxi_hbm04_wready),
        .wdata   (maxi_hbm04_wdata),
        .wstrb   (maxi_hbm04_wstrb),
        .wlast   (maxi_hbm04_wlast),
        .bvalid  (maxi_hbm04_bvalid),
        .bready  (maxi_hbm04_bready),
        .bresp   (maxi_hbm04_bresp),
        .arvalid (maxi_hbm04_arvalid),
        .arready (maxi_hbm04_arready),
        .araddr  (maxi_hbm04_araddr),
        .arlen   (maxi_hbm04_arlen),
        .arsize  (maxi_hbm04_arsize),
        .arburst (maxi_hbm04_arburst),
        .rvalid  (maxi_hbm04_rvalid),
        .rready  (maxi_hbm04_rready),
        .rdata   (maxi_hbm04_rdata),
        .rresp   (maxi_hbm04_rresp),
        .rlast   (maxi_hbm04_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm05_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm05_awvalid),
        .awready (maxi_hbm05_awready),
        .awaddr  (maxi_hbm05_awaddr),
        .awlen   (maxi_hbm05_awlen),
        .awsize  (maxi_hbm05_awsize),
        .awburst (maxi_hbm05_awburst),
        .wvalid  (maxi_hbm05_wvalid),
        .wready  (maxi_hbm05_wready),
        .wdata   (maxi_hbm05_wdata),
        .wstrb   (maxi_hbm05_wstrb),
        .wlast   (maxi_hbm05_wlast),
        .bvalid  (maxi_hbm05_bvalid),
        .bready  (maxi_hbm05_bready),
        .bresp   (maxi_hbm05_bresp),
        .arvalid (maxi_hbm05_arvalid),
        .arready (maxi_hbm05_arready),
        .araddr  (maxi_hbm05_araddr),
        .arlen   (maxi_hbm05_arlen),
        .arsize  (maxi_hbm05_arsize),
        .arburst (maxi_hbm05_arburst),
        .rvalid  (maxi_hbm05_rvalid),
        .rready  (maxi_hbm05_rready),
        .rdata   (maxi_hbm05_rdata),
        .rresp   (maxi_hbm05_rresp),
        .rlast   (maxi_hbm05_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm06_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm06_awvalid),
        .awready (maxi_hbm06_awready),
        .awaddr  (maxi_hbm06_awaddr),
        .awlen   (maxi_hbm06_awlen),
        .awsize  (maxi_hbm06_awsize),
        .awburst (maxi_hbm06_awburst),
        .wvalid  (maxi_hbm06_wvalid),
        .wready  (maxi_hbm06_wready),
        .wdata   (maxi_hbm06_wdata),
        .wstrb   (maxi_hbm06_wstrb),
        .wlast   (maxi_hbm06_wlast),
        .bvalid  (maxi_hbm06_bvalid),
        .bready  (maxi_hbm06_bready),
        .bresp   (maxi_hbm06_bresp),
        .arvalid (maxi_hbm06_arvalid),
        .arready (maxi_hbm06_arready),
        .araddr  (maxi_hbm06_araddr),
        .arlen   (maxi_hbm06_arlen),
        .arsize  (maxi_hbm06_arsize),
        .arburst (maxi_hbm06_arburst),
        .rvalid  (maxi_hbm06_rvalid),
        .rready  (maxi_hbm06_rready),
        .rdata   (maxi_hbm06_rdata),
        .rresp   (maxi_hbm06_rresp),
        .rlast   (maxi_hbm06_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm07_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm07_awvalid),
        .awready (maxi_hbm07_awready),
        .awaddr  (maxi_hbm07_awaddr),
        .awlen   (maxi_hbm07_awlen),
        .awsize  (maxi_hbm07_awsize),
        .awburst (maxi_hbm07_awburst),
        .wvalid  (maxi_hbm07_wvalid),
        .wready  (maxi_hbm07_wready),
        .wdata   (maxi_hbm07_wdata),
        .wstrb   (maxi_hbm07_wstrb),
        .wlast   (maxi_hbm07_wlast),
        .bvalid  (maxi_hbm07_bvalid),
        .bready  (maxi_hbm07_bready),
        .bresp   (maxi_hbm07_bresp),
        .arvalid (maxi_hbm07_arvalid),
        .arready (maxi_hbm07_arready),
        .araddr  (maxi_hbm07_araddr),
        .arlen   (maxi_hbm07_arlen),
        .arsize  (maxi_hbm07_arsize),
        .arburst (maxi_hbm07_arburst),
        .rvalid  (maxi_hbm07_rvalid),
        .rready  (maxi_hbm07_rready),
        .rdata   (maxi_hbm07_rdata),
        .rresp   (maxi_hbm07_rresp),
        .rlast   (maxi_hbm07_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm08_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm08_awvalid),
        .awready (maxi_hbm08_awready),
        .awaddr  (maxi_hbm08_awaddr),
        .awlen   (maxi_hbm08_awlen),
        .awsize  (maxi_hbm08_awsize),
        .awburst (maxi_hbm08_awburst),
        .wvalid  (maxi_hbm08_wvalid),
        .wready  (maxi_hbm08_wready),
        .wdata   (maxi_hbm08_wdata),
        .wstrb   (maxi_hbm08_wstrb),
        .wlast   (maxi_hbm08_wlast),
        .bvalid  (maxi_hbm08_bvalid),
        .bready  (maxi_hbm08_bready),
        .bresp   (maxi_hbm08_bresp),
        .arvalid (maxi_hbm08_arvalid),
        .arready (maxi_hbm08_arready),
        .araddr  (maxi_hbm08_araddr),
        .arlen   (maxi_hbm08_arlen),
        .arsize  (maxi_hbm08_arsize),
        .arburst (maxi_hbm08_arburst),
        .rvalid  (maxi_hbm08_rvalid),
        .rready  (maxi_hbm08_rready),
        .rdata   (maxi_hbm08_rdata),
        .rresp   (maxi_hbm08_rresp),
        .rlast   (maxi_hbm08_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm09_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm09_awvalid),
        .awready (maxi_hbm09_awready),
        .awaddr  (maxi_hbm09_awaddr),
        .awlen   (maxi_hbm09_awlen),
        .awsize  (maxi_hbm09_awsize),
        .awburst (maxi_hbm09_awburst),
        .wvalid  (maxi_hbm09_wvalid),
        .wready  (maxi_hbm09_wready),
        .wdata   (maxi_hbm09_wdata),
        .wstrb   (maxi_hbm09_wstrb),
        .wlast   (maxi_hbm09_wlast),
        .bvalid  (maxi_hbm09_bvalid),
        .bready  (maxi_hbm09_bready),
        .bresp   (maxi_hbm09_bresp),
        .arvalid (maxi_hbm09_arvalid),
        .arready (maxi_hbm09_arready),
        .araddr  (maxi_hbm09_araddr),
        .arlen   (maxi_hbm09_arlen),
        .arsize  (maxi_hbm09_arsize),
        .arburst (maxi_hbm09_arburst),
        .rvalid  (maxi_hbm09_rvalid),
        .rready  (maxi_hbm09_rready),
        .rdata   (maxi_hbm09_rdata),
        .rresp   (maxi_hbm09_rresp),
        .rlast   (maxi_hbm09_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm10_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm10_awvalid),
        .awready (maxi_hbm10_awready),
        .awaddr  (maxi_hbm10_awaddr),
        .awlen   (maxi_hbm10_awlen),
        .awsize  (maxi_hbm10_awsize),
        .awburst (maxi_hbm10_awburst),
        .wvalid  (maxi_hbm10_wvalid),
        .wready  (maxi_hbm10_wready),
        .wdata   (maxi_hbm10_wdata),
        .wstrb   (maxi_hbm10_wstrb),
        .wlast   (maxi_hbm10_wlast),
        .bvalid  (maxi_hbm10_bvalid),
        .bready  (maxi_hbm10_bready),
        .bresp   (maxi_hbm10_bresp),
        .arvalid (maxi_hbm10_arvalid),
        .arready (maxi_hbm10_arready),
        .araddr  (maxi_hbm10_araddr),
        .arlen   (maxi_hbm10_arlen),
        .arsize  (maxi_hbm10_arsize),
        .arburst (maxi_hbm10_arburst),
        .rvalid  (maxi_hbm10_rvalid),
        .rready  (maxi_hbm10_rready),
        .rdata   (maxi_hbm10_rdata),
        .rresp   (maxi_hbm10_rresp),
        .rlast   (maxi_hbm10_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm11_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm11_awvalid),
        .awready (maxi_hbm11_awready),
        .awaddr  (maxi_hbm11_awaddr),
        .awlen   (maxi_hbm11_awlen),
        .awsize  (maxi_hbm11_awsize),
        .awburst (maxi_hbm11_awburst),
        .wvalid  (maxi_hbm11_wvalid),
        .wready  (maxi_hbm11_wready),
        .wdata   (maxi_hbm11_wdata),
        .wstrb   (maxi_hbm11_wstrb),
        .wlast   (maxi_hbm11_wlast),
        .bvalid  (maxi_hbm11_bvalid),
        .bready  (maxi_hbm11_bready),
        .bresp   (maxi_hbm11_bresp),
        .arvalid (maxi_hbm11_arvalid),
        .arready (maxi_hbm11_arready),
        .araddr  (maxi_hbm11_araddr),
        .arlen   (maxi_hbm11_arlen),
        .arsize  (maxi_hbm11_arsize),
        .arburst (maxi_hbm11_arburst),
        .rvalid  (maxi_hbm11_rvalid),
        .rready  (maxi_hbm11_rready),
        .rdata   (maxi_hbm11_rdata),
        .rresp   (maxi_hbm11_rresp),
        .rlast   (maxi_hbm11_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm12_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm12_awvalid),
        .awready (maxi_hbm12_awready),
        .awaddr  (maxi_hbm12_awaddr),
        .awlen   (maxi_hbm12_awlen),
        .awsize  (maxi_hbm12_awsize),
        .awburst (maxi_hbm12_awburst),
        .wvalid  (maxi_hbm12_wvalid),
        .wready  (maxi_hbm12_wready),
        .wdata   (maxi_hbm12_wdata),
        .wstrb   (maxi_hbm12_wstrb),
        .wlast   (maxi_hbm12_wlast),
        .bvalid  (maxi_hbm12_bvalid),
        .bready  (maxi_hbm12_bready),
        .bresp   (maxi_hbm12_bresp),
        .arvalid (maxi_hbm12_arvalid),
        .arready (maxi_hbm12_arready),
        .araddr  (maxi_hbm12_araddr),
        .arlen   (maxi_hbm12_arlen),
        .arsize  (maxi_hbm12_arsize),
        .arburst (maxi_hbm12_arburst),
        .rvalid  (maxi_hbm12_rvalid),
        .rready  (maxi_hbm12_rready),
        .rdata   (maxi_hbm12_rdata),
        .rresp   (maxi_hbm12_rresp),
        .rlast   (maxi_hbm12_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm13_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm13_awvalid),
        .awready (maxi_hbm13_awready),
        .awaddr  (maxi_hbm13_awaddr),
        .awlen   (maxi_hbm13_awlen),
        .awsize  (maxi_hbm13_awsize),
        .awburst (maxi_hbm13_awburst),
        .wvalid  (maxi_hbm13_wvalid),
        .wready  (maxi_hbm13_wready),
        .wdata   (maxi_hbm13_wdata),
        .wstrb   (maxi_hbm13_wstrb),
        .wlast   (maxi_hbm13_wlast),
        .bvalid  (maxi_hbm13_bvalid),
        .bready  (maxi_hbm13_bready),
        .bresp   (maxi_hbm13_bresp),
        .arvalid (maxi_hbm13_arvalid),
        .arready (maxi_hbm13_arready),
        .araddr  (maxi_hbm13_araddr),
        .arlen   (maxi_hbm13_arlen),
        .arsize  (maxi_hbm13_arsize),
        .arburst (maxi_hbm13_arburst),
        .rvalid  (maxi_hbm13_rvalid),
        .rready  (maxi_hbm13_rready),
        .rdata   (maxi_hbm13_rdata),
        .rresp   (maxi_hbm13_rresp),
        .rlast   (maxi_hbm13_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm14_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm14_awvalid),
        .awready (maxi_hbm14_awready),
        .awaddr  (maxi_hbm14_awaddr),
        .awlen   (maxi_hbm14_awlen),
        .awsize  (maxi_hbm14_awsize),
        .awburst (maxi_hbm14_awburst),
        .wvalid  (maxi_hbm14_wvalid),
        .wready  (maxi_hbm14_wready),
        .wdata   (maxi_hbm14_wdata),
        .wstrb   (maxi_hbm14_wstrb),
        .wlast   (maxi_hbm14_wlast),
        .bvalid  (maxi_hbm14_bvalid),
        .bready  (maxi_hbm14_bready),
        .bresp   (maxi_hbm14_bresp),
        .arvalid (maxi_hbm14_arvalid),
        .arready (maxi_hbm14_arready),
        .araddr  (maxi_hbm14_araddr),
        .arlen   (maxi_hbm14_arlen),
        .arsize  (maxi_hbm14_arsize),
        .arburst (maxi_hbm14_arburst),
        .rvalid  (maxi_hbm14_rvalid),
        .rready  (maxi_hbm14_rready),
        .rdata   (maxi_hbm14_rdata),
        .rresp   (maxi_hbm14_rresp),
        .rlast   (maxi_hbm14_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm15_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm15_awvalid),
        .awready (maxi_hbm15_awready),
        .awaddr  (maxi_hbm15_awaddr),
        .awlen   (maxi_hbm15_awlen),
        .awsize  (maxi_hbm15_awsize),
        .awburst (maxi_hbm15_awburst),
        .wvalid  (maxi_hbm15_wvalid),
        .wready  (maxi_hbm15_wready),
        .wdata   (maxi_hbm15_wdata),
        .wstrb   (maxi_hbm15_wstrb),
        .wlast   (maxi_hbm15_wlast),
        .bvalid  (maxi_hbm15_bvalid),
        .bready  (maxi_hbm15_bready),
        .bresp   (maxi_hbm15_bresp),
        .arvalid (maxi_hbm15_arvalid),
        .arready (maxi_hbm15_arready),
        .araddr  (maxi_hbm15_araddr),
        .arlen   (maxi_hbm15_arlen),
        .arsize  (maxi_hbm15_arsize),
        .arburst (maxi_hbm15_arburst),
        .rvalid  (maxi_hbm15_rvalid),
        .rready  (maxi_hbm15_rready),
        .rdata   (maxi_hbm15_rdata),
        .rresp   (maxi_hbm15_rresp),
        .rlast   (maxi_hbm15_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm16_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm16_awvalid),
        .awready (maxi_hbm16_awready),
        .awaddr  (maxi_hbm16_awaddr),
        .awlen   (maxi_hbm16_awlen),
        .awsize  (maxi_hbm16_awsize),
        .awburst (maxi_hbm16_awburst),
        .wvalid  (maxi_hbm16_wvalid),
        .wready  (maxi_hbm16_wready),
        .wdata   (maxi_hbm16_wdata),
        .wstrb   (maxi_hbm16_wstrb),
        .wlast   (maxi_hbm16_wlast),
        .bvalid  (maxi_hbm16_bvalid),
        .bready  (maxi_hbm16_bready),
        .bresp   (maxi_hbm16_bresp),
        .arvalid (maxi_hbm16_arvalid),
        .arready (maxi_hbm16_arready),
        .araddr  (maxi_hbm16_araddr),
        .arlen   (maxi_hbm16_arlen),
        .arsize  (maxi_hbm16_arsize),
        .arburst (maxi_hbm16_arburst),
        .rvalid  (maxi_hbm16_rvalid),
        .rready  (maxi_hbm16_rready),
        .rdata   (maxi_hbm16_rdata),
        .rresp   (maxi_hbm16_rresp),
        .rlast   (maxi_hbm16_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm17_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm17_awvalid),
        .awready (maxi_hbm17_awready),
        .awaddr  (maxi_hbm17_awaddr),
        .awlen   (maxi_hbm17_awlen),
        .awsize  (maxi_hbm17_awsize),
        .awburst (maxi_hbm17_awburst),
        .wvalid  (maxi_hbm17_wvalid),
        .wready  (maxi_hbm17_wready),
        .wdata   (maxi_hbm17_wdata),
        .wstrb   (maxi_hbm17_wstrb),
        .wlast   (maxi_hbm17_wlast),
        .bvalid  (maxi_hbm17_bvalid),
        .bready  (maxi_hbm17_bready),
        .bresp   (maxi_hbm17_bresp),
        .arvalid (maxi_hbm17_arvalid),
        .arready (maxi_hbm17_arready),
        .araddr  (maxi_hbm17_araddr),
        .arlen   (maxi_hbm17_arlen),
        .arsize  (maxi_hbm17_arsize),
        .arburst (maxi_hbm17_arburst),
        .rvalid  (maxi_hbm17_rvalid),
        .rready  (maxi_hbm17_rready),
        .rdata   (maxi_hbm17_rdata),
        .rresp   (maxi_hbm17_rresp),
        .rlast   (maxi_hbm17_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm18_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm18_awvalid),
        .awready (maxi_hbm18_awready),
        .awaddr  (maxi_hbm18_awaddr),
        .awlen   (maxi_hbm18_awlen),
        .awsize  (maxi_hbm18_awsize),
        .awburst (maxi_hbm18_awburst),
        .wvalid  (maxi_hbm18_wvalid),
        .wready  (maxi_hbm18_wready),
        .wdata   (maxi_hbm18_wdata),
        .wstrb   (maxi_hbm18_wstrb),
        .wlast   (maxi_hbm18_wlast),
        .bvalid  (maxi_hbm18_bvalid),
        .bready  (maxi_hbm18_bready),
        .bresp   (maxi_hbm18_bresp),
        .arvalid (maxi_hbm18_arvalid),
        .arready (maxi_hbm18_arready),
        .araddr  (maxi_hbm18_araddr),
        .arlen   (maxi_hbm18_arlen),
        .arsize  (maxi_hbm18_arsize),
        .arburst (maxi_hbm18_arburst),
        .rvalid  (maxi_hbm18_rvalid),
        .rready  (maxi_hbm18_rready),
        .rdata   (maxi_hbm18_rdata),
        .rresp   (maxi_hbm18_rresp),
        .rlast   (maxi_hbm18_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm19_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm19_awvalid),
        .awready (maxi_hbm19_awready),
        .awaddr  (maxi_hbm19_awaddr),
        .awlen   (maxi_hbm19_awlen),
        .awsize  (maxi_hbm19_awsize),
        .awburst (maxi_hbm19_awburst),
        .wvalid  (maxi_hbm19_wvalid),
        .wready  (maxi_hbm19_wready),
        .wdata   (maxi_hbm19_wdata),
        .wstrb   (maxi_hbm19_wstrb),
        .wlast   (maxi_hbm19_wlast),
        .bvalid  (maxi_hbm19_bvalid),
        .bready  (maxi_hbm19_bready),
        .bresp   (maxi_hbm19_bresp),
        .arvalid (maxi_hbm19_arvalid),
        .arready (maxi_hbm19_arready),
        .araddr  (maxi_hbm19_araddr),
        .arlen   (maxi_hbm19_arlen),
        .arsize  (maxi_hbm19_arsize),
        .arburst (maxi_hbm19_arburst),
        .rvalid  (maxi_hbm19_rvalid),
        .rready  (maxi_hbm19_rready),
        .rdata   (maxi_hbm19_rdata),
        .rresp   (maxi_hbm19_rresp),
        .rlast   (maxi_hbm19_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm20_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm20_awvalid),
        .awready (maxi_hbm20_awready),
        .awaddr  (maxi_hbm20_awaddr),
        .awlen   (maxi_hbm20_awlen),
        .awsize  (maxi_hbm20_awsize),
        .awburst (maxi_hbm20_awburst),
        .wvalid  (maxi_hbm20_wvalid),
        .wready  (maxi_hbm20_wready),
        .wdata   (maxi_hbm20_wdata),
        .wstrb   (maxi_hbm20_wstrb),
        .wlast   (maxi_hbm20_wlast),
        .bvalid  (maxi_hbm20_bvalid),
        .bready  (maxi_hbm20_bready),
        .bresp   (maxi_hbm20_bresp),
        .arvalid (maxi_hbm20_arvalid),
        .arready (maxi_hbm20_arready),
        .araddr  (maxi_hbm20_araddr),
        .arlen   (maxi_hbm20_arlen),
        .arsize  (maxi_hbm20_arsize),
        .arburst (maxi_hbm20_arburst),
        .rvalid  (maxi_hbm20_rvalid),
        .rready  (maxi_hbm20_rready),
        .rdata   (maxi_hbm20_rdata),
        .rresp   (maxi_hbm20_rresp),
        .rlast   (maxi_hbm20_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm21_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm21_awvalid),
        .awready (maxi_hbm21_awready),
        .awaddr  (maxi_hbm21_awaddr),
        .awlen   (maxi_hbm21_awlen),
        .awsize  (maxi_hbm21_awsize),
        .awburst (maxi_hbm21_awburst),
        .wvalid  (maxi_hbm21_wvalid),
        .wready  (maxi_hbm21_wready),
        .wdata   (maxi_hbm21_wdata),
        .wstrb   (maxi_hbm21_wstrb),
        .wlast   (maxi_hbm21_wlast),
        .bvalid  (maxi_hbm21_bvalid),
        .bready  (maxi_hbm21_bready),
        .bresp   (maxi_hbm21_bresp),
        .arvalid (maxi_hbm21_arvalid),
        .arready (maxi_hbm21_arready),
        .araddr  (maxi_hbm21_araddr),
        .arlen   (maxi_hbm21_arlen),
        .arsize  (maxi_hbm21_arsize),
        .arburst (maxi_hbm21_arburst),
        .rvalid  (maxi_hbm21_rvalid),
        .rready  (maxi_hbm21_rready),
        .rdata   (maxi_hbm21_rdata),
        .rresp   (maxi_hbm21_rresp),
        .rlast   (maxi_hbm21_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm22_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm22_awvalid),
        .awready (maxi_hbm22_awready),
        .awaddr  (maxi_hbm22_awaddr),
        .awlen   (maxi_hbm22_awlen),
        .awsize  (maxi_hbm22_awsize),
        .awburst (maxi_hbm22_awburst),
        .wvalid  (maxi_hbm22_wvalid),
        .wready  (maxi_hbm22_wready),
        .wdata   (maxi_hbm22_wdata),
        .wstrb   (maxi_hbm22_wstrb),
        .wlast   (maxi_hbm22_wlast),
        .bvalid  (maxi_hbm22_bvalid),
        .bready  (maxi_hbm22_bready),
        .bresp   (maxi_hbm22_bresp),
        .arvalid (maxi_hbm22_arvalid),
        .arready (maxi_hbm22_arready),
        .araddr  (maxi_hbm22_araddr),
        .arlen   (maxi_hbm22_arlen),
        .arsize  (maxi_hbm22_arsize),
        .arburst (maxi_hbm22_arburst),
        .rvalid  (maxi_hbm22_rvalid),
        .rready  (maxi_hbm22_rready),
        .rdata   (maxi_hbm22_rdata),
        .rresp   (maxi_hbm22_rresp),
        .rlast   (maxi_hbm22_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm23_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm23_awvalid),
        .awready (maxi_hbm23_awready),
        .awaddr  (maxi_hbm23_awaddr),
        .awlen   (maxi_hbm23_awlen),
        .awsize  (maxi_hbm23_awsize),
        .awburst (maxi_hbm23_awburst),
        .wvalid  (maxi_hbm23_wvalid),
        .wready  (maxi_hbm23_wready),
        .wdata   (maxi_hbm23_wdata),
        .wstrb   (maxi_hbm23_wstrb),
        .wlast   (maxi_hbm23_wlast),
        .bvalid  (maxi_hbm23_bvalid),
        .bready  (maxi_hbm23_bready),
        .bresp   (maxi_hbm23_bresp),
        .arvalid (maxi_hbm23_arvalid),
        .arready (maxi_hbm23_arready),
        .araddr  (maxi_hbm23_araddr),
        .arlen   (maxi_hbm23_arlen),
        .arsize  (maxi_hbm23_arsize),
        .arburst (maxi_hbm23_arburst),
        .rvalid  (maxi_hbm23_rvalid),
        .rready  (maxi_hbm23_rready),
        .rdata   (maxi_hbm23_rdata),
        .rresp   (maxi_hbm23_rresp),
        .rlast   (maxi_hbm23_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm24_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm24_awvalid),
        .awready (maxi_hbm24_awready),
        .awaddr  (maxi_hbm24_awaddr),
        .awlen   (maxi_hbm24_awlen),
        .awsize  (maxi_hbm24_awsize),
        .awburst (maxi_hbm24_awburst),
        .wvalid  (maxi_hbm24_wvalid),
        .wready  (maxi_hbm24_wready),
        .wdata   (maxi_hbm24_wdata),
        .wstrb   (maxi_hbm24_wstrb),
        .wlast   (maxi_hbm24_wlast),
        .bvalid  (maxi_hbm24_bvalid),
        .bready  (maxi_hbm24_bready),
        .bresp   (maxi_hbm24_bresp),
        .arvalid (maxi_hbm24_arvalid),
        .arready (maxi_hbm24_arready),
        .araddr  (maxi_hbm24_araddr),
        .arlen   (maxi_hbm24_arlen),
        .arsize  (maxi_hbm24_arsize),
        .arburst (maxi_hbm24_arburst),
        .rvalid  (maxi_hbm24_rvalid),
        .rready  (maxi_hbm24_rready),
        .rdata   (maxi_hbm24_rdata),
        .rresp   (maxi_hbm24_rresp),
        .rlast   (maxi_hbm24_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm25_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm25_awvalid),
        .awready (maxi_hbm25_awready),
        .awaddr  (maxi_hbm25_awaddr),
        .awlen   (maxi_hbm25_awlen),
        .awsize  (maxi_hbm25_awsize),
        .awburst (maxi_hbm25_awburst),
        .wvalid  (maxi_hbm25_wvalid),
        .wready  (maxi_hbm25_wready),
        .wdata   (maxi_hbm25_wdata),
        .wstrb   (maxi_hbm25_wstrb),
        .wlast   (maxi_hbm25_wlast),
        .bvalid  (maxi_hbm25_bvalid),
        .bready  (maxi_hbm25_bready),
        .bresp   (maxi_hbm25_bresp),
        .arvalid (maxi_hbm25_arvalid),
        .arready (maxi_hbm25_arready),
        .araddr  (maxi_hbm25_araddr),
        .arlen   (maxi_hbm25_arlen),
        .arsize  (maxi_hbm25_arsize),
        .arburst (maxi_hbm25_arburst),
        .rvalid  (maxi_hbm25_rvalid),
        .rready  (maxi_hbm25_rready),
        .rdata   (maxi_hbm25_rdata),
        .rresp   (maxi_hbm25_rresp),
        .rlast   (maxi_hbm25_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm26_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm26_awvalid),
        .awready (maxi_hbm26_awready),
        .awaddr  (maxi_hbm26_awaddr),
        .awlen   (maxi_hbm26_awlen),
        .awsize  (maxi_hbm26_awsize),
        .awburst (maxi_hbm26_awburst),
        .wvalid  (maxi_hbm26_wvalid),
        .wready  (maxi_hbm26_wready),
        .wdata   (maxi_hbm26_wdata),
        .wstrb   (maxi_hbm26_wstrb),
        .wlast   (maxi_hbm26_wlast),
        .bvalid  (maxi_hbm26_bvalid),
        .bready  (maxi_hbm26_bready),
        .bresp   (maxi_hbm26_bresp),
        .arvalid (maxi_hbm26_arvalid),
        .arready (maxi_hbm26_arready),
        .araddr  (maxi_hbm26_araddr),
        .arlen   (maxi_hbm26_arlen),
        .arsize  (maxi_hbm26_arsize),
        .arburst (maxi_hbm26_arburst),
        .rvalid  (maxi_hbm26_rvalid),
        .rready  (maxi_hbm26_rready),
        .rdata   (maxi_hbm26_rdata),
        .rresp   (maxi_hbm26_rresp),
        .rlast   (maxi_hbm26_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm27_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm27_awvalid),
        .awready (maxi_hbm27_awready),
        .awaddr  (maxi_hbm27_awaddr),
        .awlen   (maxi_hbm27_awlen),
        .awsize  (maxi_hbm27_awsize),
        .awburst (maxi_hbm27_awburst),
        .wvalid  (maxi_hbm27_wvalid),
        .wready  (maxi_hbm27_wready),
        .wdata   (maxi_hbm27_wdata),
        .wstrb   (maxi_hbm27_wstrb),
        .wlast   (maxi_hbm27_wlast),
        .bvalid  (maxi_hbm27_bvalid),
        .bready  (maxi_hbm27_bready),
        .bresp   (maxi_hbm27_bresp),
        .arvalid (maxi_hbm27_arvalid),
        .arready (maxi_hbm27_arready),
        .araddr  (maxi_hbm27_araddr),
        .arlen   (maxi_hbm27_arlen),
        .arsize  (maxi_hbm27_arsize),
        .arburst (maxi_hbm27_arburst),
        .rvalid  (maxi_hbm27_rvalid),
        .rready  (maxi_hbm27_rready),
        .rdata   (maxi_hbm27_rdata),
        .rresp   (maxi_hbm27_rresp),
        .rlast   (maxi_hbm27_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm28_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm28_awvalid),
        .awready (maxi_hbm28_awready),
        .awaddr  (maxi_hbm28_awaddr),
        .awlen   (maxi_hbm28_awlen),
        .awsize  (maxi_hbm28_awsize),
        .awburst (maxi_hbm28_awburst),
        .wvalid  (maxi_hbm28_wvalid),
        .wready  (maxi_hbm28_wready),
        .wdata   (maxi_hbm28_wdata),
        .wstrb   (maxi_hbm28_wstrb),
        .wlast   (maxi_hbm28_wlast),
        .bvalid  (maxi_hbm28_bvalid),
        .bready  (maxi_hbm28_bready),
        .bresp   (maxi_hbm28_bresp),
        .arvalid (maxi_hbm28_arvalid),
        .arready (maxi_hbm28_arready),
        .araddr  (maxi_hbm28_araddr),
        .arlen   (maxi_hbm28_arlen),
        .arsize  (maxi_hbm28_arsize),
        .arburst (maxi_hbm28_arburst),
        .rvalid  (maxi_hbm28_rvalid),
        .rready  (maxi_hbm28_rready),
        .rdata   (maxi_hbm28_rdata),
        .rresp   (maxi_hbm28_rresp),
        .rlast   (maxi_hbm28_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm29_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm29_awvalid),
        .awready (maxi_hbm29_awready),
        .awaddr  (maxi_hbm29_awaddr),
        .awlen   (maxi_hbm29_awlen),
        .awsize  (maxi_hbm29_awsize),
        .awburst (maxi_hbm29_awburst),
        .wvalid  (maxi_hbm29_wvalid),
        .wready  (maxi_hbm29_wready),
        .wdata   (maxi_hbm29_wdata),
        .wstrb   (maxi_hbm29_wstrb),
        .wlast   (maxi_hbm29_wlast),
        .bvalid  (maxi_hbm29_bvalid),
        .bready  (maxi_hbm29_bready),
        .bresp   (maxi_hbm29_bresp),
        .arvalid (maxi_hbm29_arvalid),
        .arready (maxi_hbm29_arready),
        .araddr  (maxi_hbm29_araddr),
        .arlen   (maxi_hbm29_arlen),
        .arsize  (maxi_hbm29_arsize),
        .arburst (maxi_hbm29_arburst),
        .rvalid  (maxi_hbm29_rvalid),
        .rready  (maxi_hbm29_rready),
        .rdata   (maxi_hbm29_rdata),
        .rresp   (maxi_hbm29_rresp),
        .rlast   (maxi_hbm29_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm30_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm30_awvalid),
        .awready (maxi_hbm30_awready),
        .awaddr  (maxi_hbm30_awaddr),
        .awlen   (maxi_hbm30_awlen),
        .awsize  (maxi_hbm30_awsize),
        .awburst (maxi_hbm30_awburst),
        .wvalid  (maxi_hbm30_wvalid),
        .wready  (maxi_hbm30_wready),
        .wdata   (maxi_hbm30_wdata),
        .wstrb   (maxi_hbm30_wstrb),
        .wlast   (maxi_hbm30_wlast),
        .bvalid  (maxi_hbm30_bvalid),
        .bready  (maxi_hbm30_bready),
        .bresp   (maxi_hbm30_bresp),
        .arvalid (maxi_hbm30_arvalid),
        .arready (maxi_hbm30_arready),
        .araddr  (maxi_hbm30_araddr),
        .arlen   (maxi_hbm30_arlen),
        .arsize  (maxi_hbm30_arsize),
        .arburst (maxi_hbm30_arburst),
        .rvalid  (maxi_hbm30_rvalid),
        .rready  (maxi_hbm30_rready),
        .rdata   (maxi_hbm30_rdata),
        .rresp   (maxi_hbm30_rresp),
        .rlast   (maxi_hbm30_rlast)
    );
    simple_axi_mem #(
        .ADDR_WIDTH (64),
        .DATA_WIDTH (256),
        .DEPTH  (1024*1024)
    ) hbm31_mem (
        .aclk    (aclk),
        .aresetn  (aresetn),
        .awvalid (maxi_hbm31_awvalid),
        .awready (maxi_hbm31_awready),
        .awaddr  (maxi_hbm31_awaddr),
        .awlen   (maxi_hbm31_awlen),
        .awsize  (maxi_hbm31_awsize),
        .awburst (maxi_hbm31_awburst),
        .wvalid  (maxi_hbm31_wvalid),
        .wready  (maxi_hbm31_wready),
        .wdata   (maxi_hbm31_wdata),
        .wstrb   (maxi_hbm31_wstrb),
        .wlast   (maxi_hbm31_wlast),
        .bvalid  (maxi_hbm31_bvalid),
        .bready  (maxi_hbm31_bready),
        .bresp   (maxi_hbm31_bresp),
        .arvalid (maxi_hbm31_arvalid),
        .arready (maxi_hbm31_arready),
        .araddr  (maxi_hbm31_araddr),
        .arlen   (maxi_hbm31_arlen),
        .arsize  (maxi_hbm31_arsize),
        .arburst (maxi_hbm31_arburst),
        .rvalid  (maxi_hbm31_rvalid),
        .rready  (maxi_hbm31_rready),
        .rdata   (maxi_hbm31_rdata),
        .rresp   (maxi_hbm31_rresp),
        .rlast   (maxi_hbm31_rlast)
    );

	//
	// Simple AXI-Lite Master Tasks
	//
	// Assumes:
	//   - signals are visible in current scope
	//   - clock is named `aclk`
	//   - active-low reset is `aresetn`
	//   - 64-bit AXI-Lite data bus
	//   - 12-bit AXI-Lite address bus
	//

	// ================================================================
	// RESET DEFAULTS
	// ================================================================

	task automatic axi_lite_master_init();
	begin
		s_axi_control_awaddr  = '0;
		s_axi_control_awvalid = 1'b0;
		s_axi_control_awprot  = '0;

		s_axi_control_wdata   = '0;
		s_axi_control_wstrb   = '0;
		s_axi_control_wvalid  = 1'b0;

		s_axi_control_bready  = 1'b0;

		s_axi_control_araddr  = '0;
		s_axi_control_arvalid = 1'b0;
		s_axi_control_arprot  = '0;

		s_axi_control_rready  = 1'b0;
	end
	endtask

	// ================================================================
	// AXI-LITE WRITE
	// ================================================================

	task automatic axi_lite_write(
		input logic [11:0] addr,
		input logic [63:0] data,
		input logic [7:0]  strb = 8'hFF
	);
	begin

		// ------------------------------------------------------------
		// Drive address + data
		// ------------------------------------------------------------

		@(posedge aclk);

		s_axi_control_awaddr  <= addr;
		s_axi_control_awvalid <= 1'b1;
		s_axi_control_awprot  <= 3'b000;

		s_axi_control_wdata   <= data;
		s_axi_control_wstrb   <= strb;
		s_axi_control_wvalid  <= 1'b1;

		s_axi_control_bready  <= 1'b1;

		@(posedge aclk);
		// ------------------------------------------------------------
		// Wait for AW handshake
		// Wait for W handshake
		// Wait for B response
		// ------------------------------------------------------------

		fork
			begin
				while (!s_axi_control_awready)
					@(posedge aclk);

				s_axi_control_awvalid <= 1'b0;
			end
			begin
				while (!s_axi_control_wready)
					@(posedge aclk);

				s_axi_control_wvalid <= 1'b0;
			end
			begin
				while (!s_axi_control_bvalid)
					@(posedge aclk);

				s_axi_control_bready <= 1'b0;
			end
		join
	end
	endtask

	// ================================================================
	// AXI-LITE READ
	// ================================================================

	task automatic axi_lite_read(
		input  logic [11:0] addr,
		output logic [63:0] data
	);
	begin

		// ------------------------------------------------------------
		// Drive read address
		// ------------------------------------------------------------

		@(posedge aclk);

		s_axi_control_araddr  <= addr;
		s_axi_control_arvalid <= 1'b1;
		s_axi_control_arprot  <= 3'b000;

		s_axi_control_rready  <= 1'b1;

		// ------------------------------------------------------------
		// Wait for AR handshake
		// ------------------------------------------------------------

		while (!s_axi_control_arready)
			@(posedge aclk);

		s_axi_control_arvalid <= 1'b0;

		// ------------------------------------------------------------
		// Wait for read data
		// ------------------------------------------------------------

		while (!s_axi_control_rvalid)
			@(posedge aclk);

		data = s_axi_control_rdata;

		if (s_axi_control_rresp != 2'b00) begin
			$display("[%0t] AXI-Lite READ ERROR: addr=%h resp=%b",
					$time,
					addr,
					s_axi_control_rresp);
		end

		@(posedge aclk);

		s_axi_control_rready <= 1'b0;

	end
	endtask

	initial begin
		aresetn <= 0;
		repeat(30) @(posedge aclk);

		aresetn <= 1;
	end

	logic[511:0] expected_buffer[(`Y_VEC_LEN + 15) / 16];
    
    shortreal write_ys[16];
    
    always_comb begin
        for(int i = 0; i < 16; i++) begin
            write_ys[i] = $bitstoshortreal(maxi_ddr00_wdata[i * 32 +: 32]);
        end
    end
    
	initial begin
		axi_lite_master_init();
		$readmemh("hbm00.mem", hbm00_mem.mem);
		$readmemh("hbm01.mem", hbm01_mem.mem);
		$readmemh("hbm02.mem", hbm02_mem.mem);
		$readmemh("hbm03.mem", hbm03_mem.mem);
		$readmemh("hbm04.mem", hbm04_mem.mem);
		$readmemh("hbm05.mem", hbm05_mem.mem);
		$readmemh("hbm06.mem", hbm06_mem.mem);
		$readmemh("hbm07.mem", hbm07_mem.mem);
		$readmemh("hbm08.mem", hbm08_mem.mem);
		$readmemh("hbm09.mem", hbm09_mem.mem);
		$readmemh("hbm10.mem", hbm10_mem.mem);
		$readmemh("hbm11.mem", hbm11_mem.mem);
		$readmemh("hbm12.mem", hbm12_mem.mem);
		$readmemh("hbm13.mem", hbm13_mem.mem);
		$readmemh("hbm14.mem", hbm14_mem.mem);
		$readmemh("hbm15.mem", hbm15_mem.mem);
		$readmemh("hbm16.mem", hbm16_mem.mem);
		$readmemh("hbm17.mem", hbm17_mem.mem);
		$readmemh("hbm18.mem", hbm18_mem.mem);
		$readmemh("hbm19.mem", hbm19_mem.mem);
		$readmemh("hbm20.mem", hbm20_mem.mem);
		$readmemh("hbm21.mem", hbm21_mem.mem);
		$readmemh("hbm22.mem", hbm22_mem.mem);
		$readmemh("hbm23.mem", hbm23_mem.mem);
		$readmemh("hbm24.mem", hbm24_mem.mem);
		$readmemh("hbm25.mem", hbm25_mem.mem);
		$readmemh("hbm26.mem", hbm26_mem.mem);
		$readmemh("hbm27.mem", hbm27_mem.mem);
		$readmemh("hbm28.mem", hbm28_mem.mem);
		$readmemh("hbm29.mem", hbm29_mem.mem);
		$readmemh("hbm30.mem", hbm30_mem.mem);
		$readmemh("hbm31.mem", hbm31_mem.mem);
		$readmemh("x_vec.mem", ddr_mem.mem);
		$readmemh("expected.mem", expected_buffer);

		wait(aresetn);
		// repeat(4100) @(posedge aclk);

		// X vector reg
		axi_lite_write(12'h020, `X_VEC_START_ADDR);

		// Y vector reg
		axi_lite_write(12'h030, `Y_VEC_START_ADDR);

		// Number of tiles in X direction
		axi_lite_write(12'h040, `X_TILES);

		// Number of tiles in Y direction
		axi_lite_write(12'h050, `Y_REPEATS);

		// HBM00 addr
		axi_lite_write(12'h060, 64'h00000000_00000000);
		// HBM00 256bit block count
		axi_lite_write(12'h070, `HBM00_LEN);

		// HBM01 addr
		axi_lite_write(12'h080, 64'h00000000_00000000);
		// HBM01 256bit block count
		axi_lite_write(12'h090, `HBM01_LEN);

		// HBM02 addr
		axi_lite_write(12'h0a0, 64'h00000000_00000000);
		// HBM02 256bit block count
		axi_lite_write(12'h0b0, `HBM02_LEN);

		// HBM03 addr
		axi_lite_write(12'h0c0, 64'h00000000_00000000);
		// HBM03 256bit block count
		axi_lite_write(12'h0d0, `HBM03_LEN);

		// HBM04 addr
		axi_lite_write(12'h0e0, 64'h00000000_00000000);
		// HBM04 256bit block count
		axi_lite_write(12'h0f0, `HBM04_LEN);

		// HBM05 addr
		axi_lite_write(12'h100, 64'h00000000_00000000);
		// HBM05 256bit block count
		axi_lite_write(12'h110, `HBM05_LEN);

		// HBM06 addr
		axi_lite_write(12'h120, 64'h00000000_00000000);
		// HBM06 256bit block count
		axi_lite_write(12'h130, `HBM06_LEN);

		// HBM07 addr
		axi_lite_write(12'h140, 64'h00000000_00000000);
		// HBM07 256bit block count
		axi_lite_write(12'h150, `HBM07_LEN);

		// HBM08 addr
		axi_lite_write(12'h160, 64'h00000000_00000000);
		// HBM08 256bit block count
		axi_lite_write(12'h170, `HBM08_LEN);

		// HBM09 addr
		axi_lite_write(12'h180, 64'h00000000_00000000);
		// HBM09 256bit block count
		axi_lite_write(12'h190, `HBM09_LEN);

		// HBM10 addr
		axi_lite_write(12'h1a0, 64'h00000000_00000000);
		// HBM10 256bit block count
		axi_lite_write(12'h1b0, `HBM10_LEN);

		// HBM11 addr
		axi_lite_write(12'h1c0, 64'h00000000_00000000);
		// HBM11 256bit block count
		axi_lite_write(12'h1d0, `HBM11_LEN);

		// HBM12 addr
		axi_lite_write(12'h1e0, 64'h00000000_00000000);
		// HBM12 256bit block count
		axi_lite_write(12'h1f0, `HBM12_LEN);

		// HBM13 addr
		axi_lite_write(12'h200, 64'h00000000_00000000);
		// HBM13 256bit block count
		axi_lite_write(12'h210, `HBM13_LEN);

		// HBM14 addr
		axi_lite_write(12'h220, 64'h00000000_00000000);
		// HBM14 256bit block count
		axi_lite_write(12'h230, `HBM14_LEN);

		// HBM15 addr
		axi_lite_write(12'h240, 64'h00000000_00000000);
		// HBM15 256bit block count
		axi_lite_write(12'h250, `HBM15_LEN);

		// HBM16 addr
		axi_lite_write(12'h260, 64'h00000000_00000000);
		// HBM16 256bit block count
		axi_lite_write(12'h270, `HBM16_LEN);

		// HBM17 addr
		axi_lite_write(12'h280, 64'h00000000_00000000);
		// HBM17 256bit block count
		axi_lite_write(12'h290, `HBM17_LEN);

		// HBM18 addr
		axi_lite_write(12'h2a0, 64'h00000000_00000000);
		// HBM18 256bit block count
		axi_lite_write(12'h2b0, `HBM18_LEN);

		// HBM19 addr
		axi_lite_write(12'h2c0, 64'h00000000_00000000);
		// HBM19 256bit block count
		axi_lite_write(12'h2d0, `HBM19_LEN);

		// HBM20 addr
		axi_lite_write(12'h2e0, 64'h00000000_00000000);
		// HBM20 256bit block count
		axi_lite_write(12'h2f0, `HBM20_LEN);

		// HBM21 addr
		axi_lite_write(12'h300, 64'h00000000_00000000);
		// HBM21 256bit block count
		axi_lite_write(12'h310, `HBM21_LEN);

		// HBM22 addr
		axi_lite_write(12'h320, 64'h00000000_00000000);
		// HBM22 256bit block count
		axi_lite_write(12'h330, `HBM22_LEN);

		// HBM23 addr
		axi_lite_write(12'h340, 64'h00000000_00000000);
		// HBM23 256bit block count
		axi_lite_write(12'h350, `HBM23_LEN);

		// HBM24 addr
		axi_lite_write(12'h360, 64'h00000000_00000000);
		// HBM24 256bit block count
		axi_lite_write(12'h370, `HBM24_LEN);

		// HBM25 addr
		axi_lite_write(12'h380, 64'h00000000_00000000);
		// HBM25 256bit block count
		axi_lite_write(12'h390, `HBM25_LEN);

		// HBM26 addr
		axi_lite_write(12'h3a0, 64'h00000000_00000000);
		// HBM26 256bit block count
		axi_lite_write(12'h3b0, `HBM26_LEN);

		// HBM27 addr
		axi_lite_write(12'h3c0, 64'h00000000_00000000);
		// HBM27 256bit block count
		axi_lite_write(12'h3d0, `HBM27_LEN);

		// HBM28 addr
		axi_lite_write(12'h3e0, 64'h00000000_00000000);
		// HBM28 256bit block count
		axi_lite_write(12'h3f0, `HBM28_LEN);

		// HBM29 addr
		axi_lite_write(12'h400, 64'h00000000_00000000);
		// HBM29 256bit block count
		axi_lite_write(12'h410, `HBM29_LEN);

		// HBM30 addr
		axi_lite_write(12'h420, 64'h00000000_00000000);
		// HBM30 256bit block count
		axi_lite_write(12'h430, `HBM30_LEN);

		// HBM31 addr
		axi_lite_write(12'h440, 64'h00000000_00000000);
		// HBM31 256bit block count
		axi_lite_write(12'h450, `HBM31_LEN);

		// Start!
		axi_lite_write(12'h000, 64'h00000000_00000001);

		// Wait for the accelerator to finish
		wait(intr);
		
		for(int i = 0; i < `Y_VEC_LEN; i++) begin
			automatic shortreal found_y_value = $bitstoshortreal(ddr_mem.mem[i / 16 + `Y_VEC_START_ADDR / 64][(i % 16) * 32 +: 32]);
			automatic shortreal expected_y_value = $bitstoshortreal(expected_buffer[i / 16][(i % 16) * 32 +: 32]);
			automatic shortreal diff = (found_y_value - expected_y_value) / ((expected_y_value < 0.0 ? -expected_y_value : expected_y_value) + 0.000001);
            // automatic shortreal diff = found_y_value - expected_y_value;

			if(diff >= -1e-5 && diff <= 1e-5) begin
				$display("Y %d: Found %f, Expected %f", i, found_y_value, expected_y_value);
			end else begin
				$display("WRONG Y %d: Found %f, Expected %f", i, found_y_value, expected_y_value);
			end
		end
		
		#10
		$finish();
	end
endmodule // SUSpMV_Full_tb

module simple_axi_mem #(
    parameter ADDR_WIDTH = 64,
    parameter DATA_WIDTH = 512,
    parameter DEPTH      = 1024
)(
    input  logic                     aclk,
    input  logic                     aresetn,

    // ============================================================
    // AXI WRITE ADDRESS CHANNEL
    // ============================================================

    input  logic                     awvalid,
    output logic                     awready,
    input  logic [ADDR_WIDTH-1:0]    awaddr,
    input  logic [7:0]               awlen,
    input  logic [2:0]               awsize,
    input  logic [1:0]               awburst,

    // ============================================================
    // AXI WRITE DATA CHANNEL
    // ============================================================

    input  logic                     wvalid,
    output logic                     wready,
    input  logic [DATA_WIDTH-1:0]    wdata,
    input  logic [DATA_WIDTH/8-1:0]  wstrb,
    input  logic                     wlast,

    // ============================================================
    // AXI WRITE RESPONSE CHANNEL
    // ============================================================

    output logic                     bvalid,
    input  logic                     bready,
    output logic [1:0]               bresp,

    // ============================================================
    // AXI READ ADDRESS CHANNEL
    // ============================================================

    input  logic                     arvalid,
    output logic                     arready,
    input  logic [ADDR_WIDTH-1:0]    araddr,
    input  logic [7:0]               arlen,
    input  logic [2:0]               arsize,
    input  logic [1:0]               arburst,

    // ============================================================
    // AXI READ DATA CHANNEL
    // ============================================================

    output logic                     rvalid,
    input  logic                     rready,
    output logic [DATA_WIDTH-1:0]    rdata,
    output logic [1:0]               rresp,
    output logic                     rlast
);

    // ============================================================
    // MEMORY
    // ============================================================

    logic [DATA_WIDTH:0] mem [0:DEPTH-1];

    // ============================================================
    // WRITE STATE
    // ============================================================

    logic [ADDR_WIDTH-1:0] wr_addr;
    logic [7:0]            wr_beats_left;
    logic                  wr_active;

    // ============================================================
    // READ STATE
    // ============================================================

    logic [ADDR_WIDTH-1:0] rd_addr;
    logic [7:0]            rd_beats_left;
    logic                  rd_active;

    // ============================================================
    // MAIN LOGIC
    // ============================================================

	assign arready = !rd_active & aresetn;
	assign awready = !wr_active & !bvalid & aresetn;

	assign rvalid = rd_active & aresetn;
	assign wready = wr_active & aresetn;

	always_comb begin
		if(rvalid) begin
			// build read data
			for (int i = 0; i < DATA_WIDTH / 8; i++) begin
				rdata[i*8 +: 8] = mem[rd_addr][i*8 +: 8];
			end

			rlast = rd_beats_left == 1;			
		end
	end

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            bvalid  <= 1'b0;
            bresp   <= 2'b00;

            rresp   <= 2'b00;
            rlast   <= 1'b0;

            wr_active <= 1'b0;
            rd_active <= 1'b0;
        end else begin

            // ====================================================
            // WRITE ADDRESS HANDSHAKE
            // ====================================================

            if (awvalid && awready) begin
                wr_addr       = awaddr / (DATA_WIDTH / 8);
                wr_beats_left = awlen+1;
                wr_active     <= 1'b1;
            end

            // ====================================================
            // WRITE DATA
            // ====================================================

            if (wvalid && wready) begin
                // byte-wise write
                for (int i = 0; i < DATA_WIDTH / 8; i++) begin
                    if (wstrb[i]) begin
                        mem[wr_addr][i*8 +: 8] <= wdata[i*8 +: 8];
                    end
                end

                // burst increment
                wr_addr <= wr_addr + 1;

				wr_beats_left--;

                if (wlast) begin

                    bvalid <= 1'b1;
                    bresp  <= 2'b00; // OKAY
					wr_active <= 1'b0;

					if(wr_beats_left != 0) begin
						$fatal("WR Beats Left Isn't 0 at the end of write transer???");
					end
                end
            end

            // ====================================================
            // WRITE RESPONSE
            // ====================================================

            if (bvalid && bready) begin
                bvalid <= 1'b0;
            end

            // ====================================================
            // READ ADDRESS HANDSHAKE
            // ====================================================

            if (arvalid && arready) begin
                rd_addr       <= araddr / (DATA_WIDTH / 8);
                rd_beats_left <= arlen+1;
                rd_active     <= 1'b1;

                rvalid <= 1'b1;
                rresp  <= 2'b00;
            end

            // ====================================================
            // READ DATA CHANNEL
            // ====================================================

			if(rready && rvalid) begin
                // advance burst
                rd_addr <= rd_addr + 1;

                if (rlast) begin
                    rd_active <= 1'b0;
                end else begin
                    rd_beats_left <= rd_beats_left - 1;
                end
			end
        end
    end

endmodule
