`include "matrix_params.vh"

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
		.maxi_hbm00_awvalid(maxi_hbm00_awvalid),
		.maxi_hbm00_awaddr(maxi_hbm00_awaddr),
		.maxi_hbm00_awlen(maxi_hbm00_awlen),
		.maxi_hbm00_awsize(maxi_hbm00_awsize),
		.maxi_hbm00_awburst(maxi_hbm00_awburst),
		.maxi_hbm00_awprot(maxi_hbm00_awprot),
		.maxi_hbm00_awcache(maxi_hbm00_awcache),
		.maxi_hbm00_awqos(maxi_hbm00_awqos),
		.maxi_hbm00_awlock(maxi_hbm00_awlock),
		.maxi_hbm00_awregion(maxi_hbm00_awregion),
		.maxi_hbm00_wvalid(maxi_hbm00_wvalid),
		.maxi_hbm00_wdata(maxi_hbm00_wdata),
		.maxi_hbm00_wstrb(maxi_hbm00_wstrb),
		.maxi_hbm00_wlast(maxi_hbm00_wlast),
		.maxi_hbm00_bready(maxi_hbm00_bready),
		.maxi_hbm00_wready(maxi_hbm00_wready),
		.maxi_hbm00_bvalid(maxi_hbm00_bvalid),
		.maxi_hbm00_bresp(maxi_hbm00_bresp),
		.maxi_hbm00_awready(maxi_hbm00_awready),
		.maxi_hbm00_arvalid(maxi_hbm00_arvalid),
		.maxi_hbm00_araddr(maxi_hbm00_araddr),
		.maxi_hbm00_arlen(maxi_hbm00_arlen),
		.maxi_hbm00_arsize(maxi_hbm00_arsize),
		.maxi_hbm00_arburst(maxi_hbm00_arburst),
		.maxi_hbm00_arprot(maxi_hbm00_arprot),
		.maxi_hbm00_arcache(maxi_hbm00_arcache),
		.maxi_hbm00_arqos(maxi_hbm00_arqos),
		.maxi_hbm00_arlock(maxi_hbm00_arlock),
		.maxi_hbm00_arregion(maxi_hbm00_arregion),
		.maxi_hbm00_rready(maxi_hbm00_rready),
		.maxi_hbm00_arready(maxi_hbm00_arready),
		.maxi_hbm00_rvalid(maxi_hbm00_rvalid),
		.maxi_hbm00_rdata(maxi_hbm00_rdata),
		.maxi_hbm00_rresp(maxi_hbm00_rresp),
		.maxi_hbm00_rlast(maxi_hbm00_rlast),
		.maxi_hbm01_awvalid(maxi_hbm01_awvalid),
		.maxi_hbm01_awaddr(maxi_hbm01_awaddr),
		.maxi_hbm01_awlen(maxi_hbm01_awlen),
		.maxi_hbm01_awsize(maxi_hbm01_awsize),
		.maxi_hbm01_awburst(maxi_hbm01_awburst),
		.maxi_hbm01_awprot(maxi_hbm01_awprot),
		.maxi_hbm01_awcache(maxi_hbm01_awcache),
		.maxi_hbm01_awqos(maxi_hbm01_awqos),
		.maxi_hbm01_awlock(maxi_hbm01_awlock),
		.maxi_hbm01_awregion(maxi_hbm01_awregion),
		.maxi_hbm01_wvalid(maxi_hbm01_wvalid),
		.maxi_hbm01_wdata(maxi_hbm01_wdata),
		.maxi_hbm01_wstrb(maxi_hbm01_wstrb),
		.maxi_hbm01_wlast(maxi_hbm01_wlast),
		.maxi_hbm01_bready(maxi_hbm01_bready),
		.maxi_hbm01_wready(maxi_hbm01_wready),
		.maxi_hbm01_bvalid(maxi_hbm01_bvalid),
		.maxi_hbm01_bresp(maxi_hbm01_bresp),
		.maxi_hbm01_awready(maxi_hbm01_awready),
		.maxi_hbm01_arvalid(maxi_hbm01_arvalid),
		.maxi_hbm01_araddr(maxi_hbm01_araddr),
		.maxi_hbm01_arlen(maxi_hbm01_arlen),
		.maxi_hbm01_arsize(maxi_hbm01_arsize),
		.maxi_hbm01_arburst(maxi_hbm01_arburst),
		.maxi_hbm01_arprot(maxi_hbm01_arprot),
		.maxi_hbm01_arcache(maxi_hbm01_arcache),
		.maxi_hbm01_arqos(maxi_hbm01_arqos),
		.maxi_hbm01_arlock(maxi_hbm01_arlock),
		.maxi_hbm01_arregion(maxi_hbm01_arregion),
		.maxi_hbm01_rready(maxi_hbm01_rready),
		.maxi_hbm01_arready(maxi_hbm01_arready),
		.maxi_hbm01_rvalid(maxi_hbm01_rvalid),
		.maxi_hbm01_rdata(maxi_hbm01_rdata),
		.maxi_hbm01_rresp(maxi_hbm01_rresp),
		.maxi_hbm01_rlast(maxi_hbm01_rlast)
	);

	simple_axi_mem #(
		.ADDR_WIDTH (64),
		.DATA_WIDTH (512),
		.MEM_BYTES  (1024*1024)
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
		.MEM_BYTES  (1024*1024)
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
		.MEM_BYTES  (1024*1024)
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
		repeat(4100) @(posedge aclk);

		aresetn <= 1;
	end

	initial begin
		axi_lite_master_init();
		$readmemh("hbm0.mem", hbm00_mem.mem);
		$readmemh("hbm0.mem", hbm01_mem.mem);
		$readmemh("x_vec.mem", ddr_mem.mem);

		wait(aresetn);

		// X vector reg
		axi_lite_write(12'h020, 64'h00000000_00000000);

		// Y vector reg
		axi_lite_write(12'h030, 64'h00000000_00000000);

		// X element count
		axi_lite_write(12'h040, `X_VEC_LEN);

		// Y repeats
		axi_lite_write(12'h050, 1);

		// HBM00 addr
		axi_lite_write(12'h060, 64'h00000000_00000000);

		// HBM00 256bit block count
		axi_lite_write(12'h070, 214);

		// HBM00 addr
		axi_lite_write(12'h080, 64'h00000000_00000000);

		// HBM00 256bit block count
		axi_lite_write(12'h090, 214);

		// HBM00 addr
		axi_lite_write(12'h000, 64'h00000000_00000001);
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

    integer i;

    // ============================================================
    // MAIN LOGIC
    // ============================================================

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin

            awready <= 1'b1;
            wready  <= 1'b1;

            bvalid  <= 1'b0;
            bresp   <= 2'b00;

            arready <= 1'b1;

            rvalid  <= 1'b0;
            rresp   <= 2'b00;
            rlast   <= 1'b0;

            wr_active <= 1'b0;
            rd_active <= 1'b0;

        end else begin

            // ====================================================
            // WRITE ADDRESS HANDSHAKE
            // ====================================================

            if (awvalid && awready) begin
                wr_addr       <= awaddr;
                wr_beats_left <= awlen;
                wr_active     <= 1'b1;
            end

            // ====================================================
            // WRITE DATA
            // ====================================================

            if (wr_active && wvalid && wready) begin

                // byte-wise write
                for (i = 0; i < DATA_WIDTH / 8; i++) begin
                    if (wstrb[i]) begin
                        mem[wr_addr][i*8 +: 8] <= wdata[i*8 +: 8];
                    end
                end

                // burst increment
                wr_addr <= wr_addr + 1;

                if (wlast) begin
                    wr_active <= 1'b0;

                    bvalid <= 1'b1;
                    bresp  <= 2'b00; // OKAY
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

            if (arvalid && arready && !rd_active) begin
                rd_addr       <= araddr / (DATA_WIDTH / 8);
                rd_beats_left <= arlen;
                rd_active     <= 1'b1;

                rvalid <= 1'b1;
                rresp  <= 2'b00;
            end

            // ====================================================
            // READ DATA CHANNEL
            // ====================================================

            if (rd_active && (!rvalid || (rvalid && rready))) begin

                // build read data
                for (i = 0; i < DATA_WIDTH / 8; i++) begin
                    rdata[i*8 +: 8] <= mem[rd_addr][i*8 +: 8];
                end

                rlast <= (rd_beats_left == 0);

                // advance burst
                rd_addr <= rd_addr + 1;

                if (rd_beats_left == 0) begin
                    rd_active <= 1'b0;
                end else begin
                    rd_beats_left <= rd_beats_left - 1;
                end
            end

            // final beat accepted
            if (rvalid && rready && rlast) begin
                rvalid <= 1'b0;
                rlast  <= 1'b0;
            end
        end
    end

endmodule
