// Testbench for module SUSpMV_Full #()
module SUSpMV_Full_tb;
	// Clocks
	logic aclk = 0;
	initial #0 forever #5 aclk = !aclk;

	// Ports
	// {aclk} input bool #() aresetn'1000
	logic aresetn;
	// {aclk} input int #(FROM: 0, TO: 4096) saxil_awaddr'2000
	logic[11:0] saxil_awaddr;
	// {aclk} input bool #() saxil_awvalid'2000
	logic saxil_awvalid;
	// {aclk} output bool #() saxil_awready'2000
	wire saxil_awready;
	// {aclk} input bool #()[32] saxil_wdata'2000
	logic[31:0] saxil_wdata;
	// {aclk} input bool #()[4] saxil_wstrb'2000
	logic[3:0] saxil_wstrb;
	// {aclk} input bool #() saxil_wvalid'2000
	logic saxil_wvalid;
	// {aclk} output bool #() saxil_wready'2000
	wire saxil_wready;
	// {aclk} output bool #()[2] saxil_bresp'2000
	wire[1:0] saxil_bresp;
	// {aclk} output bool #() saxil_bvalid'2000
	wire saxil_bvalid;
	// {aclk} input bool #() saxil_bready'2000
	logic saxil_bready;
	// {aclk} input int #(FROM: 0, TO: 4096) saxil_araddr'2000
	logic[11:0] saxil_araddr;
	// {aclk} input bool #() saxil_arvalid'2000
	logic saxil_arvalid;
	// {aclk} output bool #() saxil_arready'2000
	wire saxil_arready;
	// {aclk} output bool #()[32] saxil_rdata'2000
	wire[31:0] saxil_rdata;
	// {aclk} output bool #()[2] saxil_rresp'2000
	wire[1:0] saxil_rresp;
	// {aclk} output bool #() saxil_rvalid'2000
	wire saxil_rvalid;
	// {aclk} input bool #() saxil_rready'2000
	logic saxil_rready;
	// {aclk} output bool #() intr'4000
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
		.saxil_awaddr(saxil_awaddr),
		.saxil_awvalid(saxil_awvalid),
		.saxil_awready(saxil_awready),
		.saxil_wdata(saxil_wdata),
		.saxil_wstrb(saxil_wstrb),
		.saxil_wvalid(saxil_wvalid),
		.saxil_wready(saxil_wready),
		.saxil_bresp(saxil_bresp),
		.saxil_bvalid(saxil_bvalid),
		.saxil_bready(saxil_bready),
		.saxil_araddr(saxil_araddr),
		.saxil_arvalid(saxil_arvalid),
		.saxil_arready(saxil_arready),
		.saxil_rdata(saxil_rdata),
		.saxil_rresp(saxil_rresp),
		.saxil_rvalid(saxil_rvalid),
		.saxil_rready(saxil_rready),
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

	initial begin
		// ... your testbench here
	end
endmodule // SUSpMV_Full_tb

