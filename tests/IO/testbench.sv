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
	// Latency Registers

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
		.maxi_hbm07_rlast   (maxi_hbm07_rlast)
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
		repeat(10) @(posedge aclk);

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
		$readmemh("hbm0.mem", hbm00_mem.mem);
		$readmemh("hbm1.mem", hbm01_mem.mem);
		$readmemh("hbm2.mem", hbm02_mem.mem);
		$readmemh("hbm3.mem", hbm03_mem.mem);
		$readmemh("hbm4.mem", hbm04_mem.mem);
		$readmemh("hbm5.mem", hbm05_mem.mem);
		$readmemh("hbm6.mem", hbm06_mem.mem);
		$readmemh("hbm7.mem", hbm07_mem.mem);
		$readmemh("x_vec.mem", ddr_mem.mem);
		$readmemh("expected.mem", expected_buffer);

		wait(aresetn);
		repeat(4100) @(posedge aclk);

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
		axi_lite_write(12'h070, `HBM0_LEN);

		// HBM01 addr
		axi_lite_write(12'h080, 64'h00000000_00000000);
		// HBM01 256bit block count
		axi_lite_write(12'h090, `HBM1_LEN);

		// HBM02 addr
		axi_lite_write(12'h0a0, 64'h00000000_00000000);
		// HBM02 256bit block count
		axi_lite_write(12'h0b0, `HBM2_LEN);

		// HBM03 addr
		axi_lite_write(12'h0c0, 64'h00000000_00000000);
		// HBM03 256bit block count
		axi_lite_write(12'h0d0, `HBM3_LEN);

		// HBM03 addr
		axi_lite_write(12'h0e0, 64'h00000000_00000000);
		// HBM03 256bit block count
		axi_lite_write(12'h0f0, `HBM4_LEN);

		// HBM03 addr
		axi_lite_write(12'h100, 64'h00000000_00000000);
		// HBM03 256bit block count
		axi_lite_write(12'h110, `HBM5_LEN);

		// HBM03 addr
		axi_lite_write(12'h120, 64'h00000000_00000000);
		// HBM03 256bit block count
		axi_lite_write(12'h130, `HBM6_LEN);

		// HBM03 addr
		axi_lite_write(12'h140, 64'h00000000_00000000);
		// HBM03 256bit block count
		axi_lite_write(12'h150, `HBM7_LEN);

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
