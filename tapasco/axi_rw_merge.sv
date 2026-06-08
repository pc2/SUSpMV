
module axi_rw_merge#(
    parameter ADDR_WIDTH = 64,
    parameter DATA_WIDTH = 256,
    parameter ID_WIDTH   = 1
) (
    input  logic aclk,
    input  logic aresetn,

    // maxi
    output logic                   maxi_awvalid,
    input  logic                   maxi_awready,
    output logic[ADDR_WIDTH-1:0]   maxi_awaddr,
    output logic[7:0]              maxi_awlen,
    output logic[2:0]              maxi_awsize,
    output logic[1:0]              maxi_awburst,
    output logic[2:0]              maxi_awprot,
    output logic[3:0]              maxi_awcache,
    output logic[3:0]              maxi_awqos,
    output logic                   maxi_awlock,
    output logic[3:0]              maxi_awregion,
    output logic[ID_WIDTH-1:0]     maxi_awid,

    output logic                   maxi_wvalid,
    input  logic                   maxi_wready,
    output logic[DATA_WIDTH-1:0]   maxi_wdata,
    output logic[DATA_WIDTH/8-1:0] maxi_wstrb,
    output logic                   maxi_wlast,

    input  logic                   maxi_bvalid,
    output logic                   maxi_bready,
    input  logic[1:0]              maxi_bresp,
    input  logic[ID_WIDTH-1:0]     maxi_bid,

    output logic                   maxi_arvalid,
    input  logic                   maxi_arready,
    output logic[ADDR_WIDTH-1:0]   maxi_araddr,
    output logic[7:0]              maxi_arlen,
    output logic[2:0]              maxi_arsize,
    output logic[1:0]              maxi_arburst,
    output logic[2:0]              maxi_arprot,
    output logic[3:0]              maxi_arcache,
    output logic[3:0]              maxi_arqos,
    output logic                   maxi_arlock,
    output logic[3:0]              maxi_arregion,
    output logic[ID_WIDTH-1:0]     maxi_arid,

    input  logic                   maxi_rvalid,
    output logic                   maxi_rready,
    input  logic[DATA_WIDTH-1:0]   maxi_rdata,
    input  logic[1:0]              maxi_rresp,
    input  logic                   maxi_rlast,
    input  logic[ID_WIDTH-1:0]     maxi_rid,

    // saxi_r
    input  logic                   saxi_r_awvalid,
    output logic                   saxi_r_awready,
    input  logic[ADDR_WIDTH-1:0]   saxi_r_awaddr,
    input  logic[7:0]              saxi_r_awlen,
    input  logic[2:0]              saxi_r_awsize,
    input  logic[1:0]              saxi_r_awburst,
    input  logic[2:0]              saxi_r_awprot,
    input  logic[3:0]              saxi_r_awcache,
    input  logic[3:0]              saxi_r_awqos,
    input  logic                   saxi_r_awlock,
    input  logic[3:0]              saxi_r_awregion,
    input  logic[ID_WIDTH-1:0]     saxi_r_awid,

    input  logic                   saxi_r_wvalid,
    output logic                   saxi_r_wready,
    input  logic[DATA_WIDTH-1:0]   saxi_r_wdata,
    input  logic[DATA_WIDTH/8-1:0] saxi_r_wstrb,
    input  logic                   saxi_r_wlast,

    output logic                   saxi_r_bvalid,
    input  logic                   saxi_r_bready,
    output logic[1:0]              saxi_r_bresp,
    output logic[ID_WIDTH-1:0]     saxi_r_bid,

    input  logic                   saxi_r_arvalid,
    output logic                   saxi_r_arready,
    input  logic[ADDR_WIDTH-1:0]   saxi_r_araddr,
    input  logic[7:0]              saxi_r_arlen,
    input  logic[2:0]              saxi_r_arsize,
    input  logic[1:0]              saxi_r_arburst,
    input  logic[2:0]              saxi_r_arprot,
    input  logic[3:0]              saxi_r_arcache,
    input  logic[3:0]              saxi_r_arqos,
    input  logic                   saxi_r_arlock,
    input  logic[3:0]              saxi_r_arregion,
    input  logic[ID_WIDTH-1:0]     saxi_r_arid,

    output logic                   saxi_r_rvalid,
    input  logic                   saxi_r_rready,
    output logic[DATA_WIDTH-1:0]   saxi_r_rdata,
    output logic[1:0]              saxi_r_rresp,
    output logic                   saxi_r_rlast,
    output logic[ID_WIDTH-1:0]     saxi_r_rid,

    // saxi_w
    input  logic                   saxi_w_awvalid,
    output logic                   saxi_w_awready,
    input  logic[ADDR_WIDTH-1:0]   saxi_w_awaddr,
    input  logic[7:0]              saxi_w_awlen,
    input  logic[2:0]              saxi_w_awsize,
    input  logic[1:0]              saxi_w_awburst,
    input  logic[2:0]              saxi_w_awprot,
    input  logic[3:0]              saxi_w_awcache,
    input  logic[3:0]              saxi_w_awqos,
    input  logic                   saxi_w_awlock,
    input  logic[3:0]              saxi_w_awregion,
    input  logic[ID_WIDTH-1:0]     saxi_w_awid,

    input  logic                   saxi_w_wvalid,
    output logic                   saxi_w_wready,
    input  logic[DATA_WIDTH-1:0]   saxi_w_wdata,
    input  logic[DATA_WIDTH/8-1:0] saxi_w_wstrb,
    input  logic                   saxi_w_wlast,
    
    output logic                   saxi_w_bvalid,
    input  logic                   saxi_w_bready,
    output logic[1:0]              saxi_w_bresp,
    output logic[ID_WIDTH-1:0]     saxi_w_bid,

    input  logic                   saxi_w_arvalid,
    output logic                   saxi_w_arready,
    input  logic[ADDR_WIDTH-1:0]   saxi_w_araddr,
    input  logic[7:0]              saxi_w_arlen,
    input  logic[2:0]              saxi_w_arsize,
    input  logic[1:0]              saxi_w_arburst,
    input  logic[2:0]              saxi_w_arprot,
    input  logic[3:0]              saxi_w_arcache,
    input  logic[3:0]              saxi_w_arqos,
    input  logic                   saxi_w_arlock,
    input  logic[3:0]              saxi_w_arregion,
    input  logic[ID_WIDTH-1:0]     saxi_w_arid,

    output logic                   saxi_w_rvalid,
    input  logic                   saxi_w_rready,
    output logic[DATA_WIDTH-1:0]   saxi_w_rdata,
    output logic[1:0]              saxi_w_rresp,
    output logic                   saxi_w_rlast,
    output logic[ID_WIDTH-1:0]     saxi_w_rid
);

// saxi_r
assign maxi_arvalid   = saxi_r_arvalid;
assign saxi_r_arready = maxi_arready;
assign maxi_araddr    = saxi_r_araddr;
assign maxi_arlen     = saxi_r_arlen;
assign maxi_arsize    = saxi_r_arsize;
assign maxi_arburst   = saxi_r_arburst;
assign maxi_arprot    = saxi_r_arprot;
assign maxi_arcache   = saxi_r_arcache;
assign maxi_arqos     = saxi_r_arqos;
assign maxi_arlock    = saxi_r_arlock;
assign maxi_arregion  = saxi_r_arregion;
assign maxi_arid      = saxi_r_arid;

assign saxi_r_rvalid  = maxi_rvalid;
assign maxi_rready    = saxi_r_rready;
assign saxi_r_rdata   = maxi_rdata;
assign saxi_r_rresp   = maxi_rresp;
assign saxi_r_rlast   = maxi_rlast;
assign saxi_r_rid     = maxi_rid;

assign saxi_r_awready = 1;

assign saxi_r_wready  = 1;

assign maxi_bvalid    = 0;
assign maxi_bresp     = 0;
assign maxi_bid       = 0;

// saxi_w
assign saxi_w_arready = 1;

assign saxi_w_rvalid  = 0;
assign saxi_w_rdata   = 0;
assign saxi_w_rresp   = 0;
assign saxi_w_rlast   = 0;
assign saxi_w_rid     = 0;

assign maxi_awvalid   = saxi_w_awvalid;
assign saxi_w_awready = maxi_awready;
assign maxi_awaddr    = saxi_w_awaddr;
assign maxi_awlen     = saxi_w_awlen;
assign maxi_awsize    = saxi_w_awsize;
assign maxi_awburst   = saxi_w_awburst;
assign maxi_awprot    = saxi_w_awprot;
assign maxi_awcache   = saxi_w_awcache;
assign maxi_awqos     = saxi_w_awqos;
assign maxi_awlock    = saxi_w_awlock;
assign maxi_awregion  = saxi_w_awregion;
assign maxi_awid      = saxi_w_awid;

assign maxi_wvalid    = saxi_w_wvalid;
assign saxi_w_wready  = maxi_wready;
assign maxi_wdata     = saxi_w_wdata;
assign maxi_wstrb     = saxi_w_wstrb;
assign maxi_wlast     = saxi_w_wlast;

assign saxi_w_bvalid  = maxi_bvalid;
assign maxi_bready    = saxi_w_bready;
assign saxi_w_bresp   = maxi_bresp;
assign saxi_w_bid     = maxi_bid;

endmodule
