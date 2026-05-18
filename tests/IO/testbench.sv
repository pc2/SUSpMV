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
        // {aclk} input bool #()[32] s_axi_control_wdata'2000
        logic[31:0] s_axi_control_wdata;
        // {aclk} input bool #()[4] s_axi_control_wstrb'2000
        logic[3:0] s_axi_control_wstrb;
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
        // {aclk} output bool #()[32] s_axi_control_rdata'2000
        wire[31:0] s_axi_control_rdata;
        // {aclk} output bool #()[2] s_axi_control_rresp'2000
        wire[1:0] s_axi_control_rresp;
        // {aclk} output bool #() s_axi_control_rvalid'2000
        wire s_axi_control_rvalid;
        // {aclk} input bool #() s_axi_control_rready'2000
        logic s_axi_control_rready;
        // {aclk} output bool #() ddr_connection_awvalid'3000
        wire ddr_connection_awvalid;
        // {aclk} input bool #() ddr_connection_awready'3000
        logic ddr_connection_awready;
        // {aclk} output int #(FROM: 0, TO: 18446744073709551616) ddr_connection_awaddr'3000
        wire[63:0] ddr_connection_awaddr;
        // {aclk} output int #(FROM: 0, TO: 256) ddr_connection_awlen'3000
        wire[7:0] ddr_connection_awlen;
        // {aclk} output int #(FROM: 0, TO: 8) ddr_connection_awsize'3000
        wire[2:0] ddr_connection_awsize;
        // {aclk} output bool #()[2] ddr_connection_awburst'3000
        wire[1:0] ddr_connection_awburst;
        // {aclk} output bool #()[3] ddr_connection_awprot'3000
        wire[2:0] ddr_connection_awprot;
        // {aclk} output bool #()[4] ddr_connection_awcache'3000
        wire[3:0] ddr_connection_awcache;
        // {aclk} output int #(FROM: 0, TO: 16) ddr_connection_awqos'3000
        wire[3:0] ddr_connection_awqos;
        // {aclk} output bool #() ddr_connection_awlock'3000
        wire ddr_connection_awlock;
        // {aclk} output int #(FROM: 0, TO: 16) ddr_connection_awregion'3000
        wire[3:0] ddr_connection_awregion;
        // {aclk} output bool #() ddr_connection_wvalid'3000
        wire ddr_connection_wvalid;
        // {aclk} input bool #() ddr_connection_wready'3000
        logic ddr_connection_wready;
        // {aclk} output bool #()[512] ddr_connection_wdata'3000
        wire[511:0] ddr_connection_wdata;
        // {aclk} output bool #()[64] ddr_connection_wstrb'3000
        wire[63:0] ddr_connection_wstrb;
        // {aclk} output bool #() ddr_connection_wlast'3000
        wire ddr_connection_wlast;
        // {aclk} input bool #() ddr_connection_bvalid'3000
        logic ddr_connection_bvalid;
        // {aclk} output bool #() ddr_connection_bready'3000
        wire ddr_connection_bready;
        // {aclk} input bool #()[2] ddr_connection_bresp'3000
        logic[1:0] ddr_connection_bresp;
        // {aclk} output bool #() ddr_connection_arvalid'0
        wire ddr_connection_arvalid;
        // {aclk} input bool #() ddr_connection_arready'0
        logic ddr_connection_arready;
        // {aclk} output int #(FROM: 0, TO: 18446744073709551616) ddr_connection_araddr'0
        wire[63:0] ddr_connection_araddr;
        // {aclk} output int #(FROM: 0, TO: 256) ddr_connection_arlen'0
        wire[7:0] ddr_connection_arlen;
        // {aclk} output int #(FROM: 0, TO: 8) ddr_connection_arsize'0
        wire[2:0] ddr_connection_arsize;
        // {aclk} output bool #()[2] ddr_connection_arburst'0
        wire[1:0] ddr_connection_arburst;
        // {aclk} output bool #()[3] ddr_connection_arprot'0
        wire[2:0] ddr_connection_arprot;
        // {aclk} output bool #()[4] ddr_connection_arcache'0
        wire[3:0] ddr_connection_arcache;
        // {aclk} output int #(FROM: 0, TO: 16) ddr_connection_arqos'0
        wire[3:0] ddr_connection_arqos;
        // {aclk} output bool #() ddr_connection_arlock'0
        wire ddr_connection_arlock;
        // {aclk} output int #(FROM: 0, TO: 16) ddr_connection_arregion'0
        wire[3:0] ddr_connection_arregion;
        // {aclk} input bool #() ddr_connection_rvalid'0
        logic ddr_connection_rvalid;
        // {aclk} output bool #() ddr_connection_rready'0
        wire ddr_connection_rready;
        // {aclk} input bool #()[512] ddr_connection_rdata'0
        logic[511:0] ddr_connection_rdata;
        // {aclk} input bool #()[2] ddr_connection_rresp'0
        logic[1:0] ddr_connection_rresp;
        // {aclk} input bool #() ddr_connection_rlast'0
        logic ddr_connection_rlast;
        // {aclk} output bool #() hbm0_awvalid'0
        wire hbm0_awvalid;
        // {aclk} output int #(FROM: 0, TO: 18446744073709551616) hbm0_awaddr'0
        wire[63:0] hbm0_awaddr;
        // {aclk} output int #(FROM: 0, TO: 256) hbm0_awlen'0
        wire[7:0] hbm0_awlen;
        // {aclk} output int #(FROM: 0, TO: 8) hbm0_awsize'0
        wire[2:0] hbm0_awsize;
        // {aclk} output bool #()[2] hbm0_awburst'0
        wire[1:0] hbm0_awburst;
        // {aclk} output bool #()[3] hbm0_awprot'0
        wire[2:0] hbm0_awprot;
        // {aclk} output bool #()[4] hbm0_awcache'0
        wire[3:0] hbm0_awcache;
        // {aclk} output int #(FROM: 0, TO: 16) hbm0_awqos'0
        wire[3:0] hbm0_awqos;
        // {aclk} output bool #() hbm0_awlock'0
        wire hbm0_awlock;
        // {aclk} output int #(FROM: 0, TO: 16) hbm0_awregion'0
        wire[3:0] hbm0_awregion;
        // {aclk} output bool #() hbm0_wvalid'0
        wire hbm0_wvalid;
        // {aclk} output bool #()[256] hbm0_wdata'0
        wire[255:0] hbm0_wdata;
        // {aclk} output bool #()[32] hbm0_wstrb'0
        wire[31:0] hbm0_wstrb;
        // {aclk} output bool #() hbm0_wlast'0
        wire hbm0_wlast;
        // {aclk} output bool #() hbm0_bready'0
        wire hbm0_bready;
        // {aclk} input bool #() hbm0_wready'0
        logic hbm0_wready;
        // {aclk} input bool #() hbm0_bvalid'0
        logic hbm0_bvalid;
        // {aclk} input bool #()[2] hbm0_bresp'0
        logic[1:0] hbm0_bresp;
        // {aclk} input bool #() hbm0_awready'0
        logic hbm0_awready;
        // {aclk} output bool #() hbm0_arvalid'0
        wire hbm0_arvalid;
        // {aclk} output int #(FROM: 0, TO: 115792089237316195423570985008687907853269984665640564039457584007913129639936) hbm0_araddr'0
        wire[255:0] hbm0_araddr;
        // {aclk} output int #(FROM: 0, TO: 256) hbm0_arlen'0
        wire[7:0] hbm0_arlen;
        // {aclk} output int #(FROM: 0, TO: 8) hbm0_arsize'0
        wire[2:0] hbm0_arsize;
        // {aclk} output bool #()[2] hbm0_arburst'0
        wire[1:0] hbm0_arburst;
        // {aclk} output bool #()[3] hbm0_arprot'0
        wire[2:0] hbm0_arprot;
        // {aclk} output bool #()[4] hbm0_arcache'0
        wire[3:0] hbm0_arcache;
        // {aclk} output int #(FROM: 0, TO: 16) hbm0_arqos'0
        wire[3:0] hbm0_arqos;
        // {aclk} output bool #() hbm0_arlock'0
        wire hbm0_arlock;
        // {aclk} output int #(FROM: 0, TO: 16) hbm0_arregion'0
        wire[3:0] hbm0_arregion;
        // {aclk} output bool #() hbm0_rready'0
        wire hbm0_rready;
        // {aclk} input bool #() hbm0_arready'0
        logic hbm0_arready;
        // {aclk} input bool #() hbm0_rvalid'0
        logic hbm0_rvalid;
        // {aclk} input bool #()[256] hbm0_rdata'0
        logic[255:0] hbm0_rdata;
        // {aclk} input bool #()[2] hbm0_rresp'0
        logic[1:0] hbm0_rresp;
        // {aclk} input bool #() hbm0_rlast'0
        logic hbm0_rlast;
        // {aclk} output bool #() hbm1_awvalid'0
        wire hbm1_awvalid;
        // {aclk} output int #(FROM: 0, TO: 18446744073709551616) hbm1_awaddr'0
        wire[63:0] hbm1_awaddr;
        // {aclk} output int #(FROM: 0, TO: 256) hbm1_awlen'0
        wire[7:0] hbm1_awlen;
        // {aclk} output int #(FROM: 0, TO: 8) hbm1_awsize'0
        wire[2:0] hbm1_awsize;
        // {aclk} output bool #()[2] hbm1_awburst'0
        wire[1:0] hbm1_awburst;
        // {aclk} output bool #()[3] hbm1_awprot'0
        wire[2:0] hbm1_awprot;
        // {aclk} output bool #()[4] hbm1_awcache'0
        wire[3:0] hbm1_awcache;
        // {aclk} output int #(FROM: 0, TO: 16) hbm1_awqos'0
        wire[3:0] hbm1_awqos;
        // {aclk} output bool #() hbm1_awlock'0
        wire hbm1_awlock;
        // {aclk} output int #(FROM: 0, TO: 16) hbm1_awregion'0
        wire[3:0] hbm1_awregion;
        // {aclk} output bool #() hbm1_wvalid'0
        wire hbm1_wvalid;
        // {aclk} output bool #()[256] hbm1_wdata'0
        wire[255:0] hbm1_wdata;
        // {aclk} output bool #()[32] hbm1_wstrb'0
        wire[31:0] hbm1_wstrb;
        // {aclk} output bool #() hbm1_wlast'0
        wire hbm1_wlast;
        // {aclk} output bool #() hbm1_bready'0
        wire hbm1_bready;
        // {aclk} input bool #() hbm1_wready'0
        logic hbm1_wready;
        // {aclk} input bool #() hbm1_bvalid'0
        logic hbm1_bvalid;
        // {aclk} input bool #()[2] hbm1_bresp'0
        logic[1:0] hbm1_bresp;
        // {aclk} input bool #() hbm1_awready'0
        logic hbm1_awready;
        // {aclk} output bool #() hbm1_arvalid'0
        wire hbm1_arvalid;
        // {aclk} output int #(FROM: 0, TO: 115792089237316195423570985008687907853269984665640564039457584007913129639936) hbm1_araddr'0
        wire[255:0] hbm1_araddr;
        // {aclk} output int #(FROM: 0, TO: 256) hbm1_arlen'0
        wire[7:0] hbm1_arlen;
        // {aclk} output int #(FROM: 0, TO: 8) hbm1_arsize'0
        wire[2:0] hbm1_arsize;
        // {aclk} output bool #()[2] hbm1_arburst'0
        wire[1:0] hbm1_arburst;
        // {aclk} output bool #()[3] hbm1_arprot'0
        wire[2:0] hbm1_arprot;
        // {aclk} output bool #()[4] hbm1_arcache'0
        wire[3:0] hbm1_arcache;
        // {aclk} output int #(FROM: 0, TO: 16) hbm1_arqos'0
        wire[3:0] hbm1_arqos;
        // {aclk} output bool #() hbm1_arlock'0
        wire hbm1_arlock;
        // {aclk} output int #(FROM: 0, TO: 16) hbm1_arregion'0
        wire[3:0] hbm1_arregion;
        // {aclk} output bool #() hbm1_rready'0
        wire hbm1_rready;
        // {aclk} input bool #() hbm1_arready'0
        logic hbm1_arready;
        // {aclk} input bool #() hbm1_rvalid'0
        logic hbm1_rvalid;
        // {aclk} input bool #()[256] hbm1_rdata'0
        logic[255:0] hbm1_rdata;
        // {aclk} input bool #()[2] hbm1_rresp'0
        logic[1:0] hbm1_rresp;
        // {aclk} input bool #() hbm1_rlast'0
        logic hbm1_rlast;

        // Latency Registers

        // DUT
        SUSpMV_Full dut(
                .aclk(aclk),
                .aresetn(aresetn),
                .s_axi_control_awaddr(s_axi_control_awaddr),
                .s_axi_control_awvalid(s_axi_control_awvalid),
                .s_axi_control_awready(s_axi_control_awready),
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
                .s_axi_control_rdata(s_axi_control_rdata),
                .s_axi_control_rresp(s_axi_control_rresp),
                .s_axi_control_rvalid(s_axi_control_rvalid),
                .s_axi_control_rready(s_axi_control_rready),
                .ddr_connection_awvalid(ddr_connection_awvalid),
                .ddr_connection_awready(ddr_connection_awready),
                .ddr_connection_awaddr(ddr_connection_awaddr),
                .ddr_connection_awlen(ddr_connection_awlen),
                .ddr_connection_awsize(ddr_connection_awsize),
                .ddr_connection_awburst(ddr_connection_awburst),
                .ddr_connection_awprot(ddr_connection_awprot),
                .ddr_connection_awcache(ddr_connection_awcache),
                .ddr_connection_awqos(ddr_connection_awqos),
                .ddr_connection_awlock(ddr_connection_awlock),
                .ddr_connection_awregion(ddr_connection_awregion),
                .ddr_connection_wvalid(ddr_connection_wvalid),
                .ddr_connection_wready(ddr_connection_wready),
                .ddr_connection_wdata(ddr_connection_wdata),
                .ddr_connection_wstrb(ddr_connection_wstrb),
                .ddr_connection_wlast(ddr_connection_wlast),
                .ddr_connection_bvalid(ddr_connection_bvalid),
                .ddr_connection_bready(ddr_connection_bready),
                .ddr_connection_bresp(ddr_connection_bresp),
                .ddr_connection_arvalid(ddr_connection_arvalid),
                .ddr_connection_arready(ddr_connection_arready),
                .ddr_connection_araddr(ddr_connection_araddr),
                .ddr_connection_arlen(ddr_connection_arlen),
                .ddr_connection_arsize(ddr_connection_arsize),
                .ddr_connection_arburst(ddr_connection_arburst),
                .ddr_connection_arprot(ddr_connection_arprot),
                .ddr_connection_arcache(ddr_connection_arcache),
                .ddr_connection_arqos(ddr_connection_arqos),
                .ddr_connection_arlock(ddr_connection_arlock),
                .ddr_connection_arregion(ddr_connection_arregion),
                .ddr_connection_rvalid(ddr_connection_rvalid),
                .ddr_connection_rready(ddr_connection_rready),
                .ddr_connection_rdata(ddr_connection_rdata),
                .ddr_connection_rresp(ddr_connection_rresp),
                .ddr_connection_rlast(ddr_connection_rlast),
                .hbm0_awvalid(hbm0_awvalid),
                .hbm0_awaddr(hbm0_awaddr),
                .hbm0_awlen(hbm0_awlen),
                .hbm0_awsize(hbm0_awsize),
                .hbm0_awburst(hbm0_awburst),
                .hbm0_awprot(hbm0_awprot),
                .hbm0_awcache(hbm0_awcache),
                .hbm0_awqos(hbm0_awqos),
                .hbm0_awlock(hbm0_awlock),
                .hbm0_awregion(hbm0_awregion),
                .hbm0_wvalid(hbm0_wvalid),
                .hbm0_wdata(hbm0_wdata),
                .hbm0_wstrb(hbm0_wstrb),
                .hbm0_wlast(hbm0_wlast),
                .hbm0_bready(hbm0_bready),
                .hbm0_wready(hbm0_wready),
                .hbm0_bvalid(hbm0_bvalid),
                .hbm0_bresp(hbm0_bresp),
                .hbm0_awready(hbm0_awready),
                .hbm0_arvalid(hbm0_arvalid),
                .hbm0_araddr(hbm0_araddr),
                .hbm0_arlen(hbm0_arlen),
                .hbm0_arsize(hbm0_arsize),
                .hbm0_arburst(hbm0_arburst),
                .hbm0_arprot(hbm0_arprot),
                .hbm0_arcache(hbm0_arcache),
                .hbm0_arqos(hbm0_arqos),
                .hbm0_arlock(hbm0_arlock),
                .hbm0_arregion(hbm0_arregion),
                .hbm0_rready(hbm0_rready),
                .hbm0_arready(hbm0_arready),
                .hbm0_rvalid(hbm0_rvalid),
                .hbm0_rdata(hbm0_rdata),
                .hbm0_rresp(hbm0_rresp),
                .hbm0_rlast(hbm0_rlast),
                .hbm1_awvalid(hbm1_awvalid),
                .hbm1_awaddr(hbm1_awaddr),
                .hbm1_awlen(hbm1_awlen),
                .hbm1_awsize(hbm1_awsize),
                .hbm1_awburst(hbm1_awburst),
                .hbm1_awprot(hbm1_awprot),
                .hbm1_awcache(hbm1_awcache),
                .hbm1_awqos(hbm1_awqos),
                .hbm1_awlock(hbm1_awlock),
                .hbm1_awregion(hbm1_awregion),
                .hbm1_wvalid(hbm1_wvalid),
                .hbm1_wdata(hbm1_wdata),
                .hbm1_wstrb(hbm1_wstrb),
                .hbm1_wlast(hbm1_wlast),
                .hbm1_bready(hbm1_bready),
                .hbm1_wready(hbm1_wready),
                .hbm1_bvalid(hbm1_bvalid),
                .hbm1_bresp(hbm1_bresp),
                .hbm1_awready(hbm1_awready),
                .hbm1_arvalid(hbm1_arvalid),
                .hbm1_araddr(hbm1_araddr),
                .hbm1_arlen(hbm1_arlen),
                .hbm1_arsize(hbm1_arsize),
                .hbm1_arburst(hbm1_arburst),
                .hbm1_arprot(hbm1_arprot),
                .hbm1_arcache(hbm1_arcache),
                .hbm1_arqos(hbm1_arqos),
                .hbm1_arlock(hbm1_arlock),
                .hbm1_arregion(hbm1_arregion),
                .hbm1_rready(hbm1_rready),
                .hbm1_arready(hbm1_arready),
                .hbm1_rvalid(hbm1_rvalid),
                .hbm1_rdata(hbm1_rdata),
                .hbm1_rresp(hbm1_rresp),
                .hbm1_rlast(hbm1_rlast)
        );

        initial begin
                // ... your testbench here
        end
endmodule // SUSpMV_Full_tb