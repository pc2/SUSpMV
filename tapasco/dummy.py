verilog = """
module suspmv (
	input  logic aclk,
	input  logic aresetn,

	input  logic[11:0] saxil_awaddr,
	input  logic       saxil_awvalid,
	output logic       saxil_awready,
	input  logic[63:0] saxil_wdata,
	input  logic[7:0]  saxil_wstrb,
	input  logic       saxil_wvalid,
	output logic       saxil_wready,
	output logic[1:0]  saxil_bresp,
	output logic       saxil_bvalid,
	input  logic       saxil_bready,
	input  logic[11:0] saxil_araddr,
	input  logic       saxil_arvalid,
	output logic       saxil_arready,
	output logic[63:0] saxil_rdata,
	output logic[1:0]  saxil_rresp,
	output logic       saxil_rvalid,
	input  logic       saxil_rready,
"""

ports = list()
for i in range(1):
    ports.append(f"ddr{str(i).zfill(2)}")
for i in range(0):
    ports.append(f"hbm{str(i).zfill(2)}")

for port in ports:
    verilog += f"""
	output logic        maxi_{port}_awvalid,
	input  logic        maxi_{port}_awready,
	output logic[63:0]  maxi_{port}_awaddr,
	output logic[7:0]   maxi_{port}_awlen,
	output logic[2:0]   maxi_{port}_awsize,
	output logic[1:0]   maxi_{port}_awburst,
	output logic        maxi_{port}_wvalid,
	input  logic        maxi_{port}_wready,
	output logic[255:0] maxi_{port}_wdata,
	output logic[31:0]  maxi_{port}_wstrb,
	output logic        maxi_{port}_wlast,
	input  logic        maxi_{port}_bvalid,
	output logic        maxi_{port}_bready,
	input  logic[1:0]   maxi_{port}_bresp,
	output logic        maxi_{port}_arvalid,
	input  logic        maxi_{port}_arready,
	output logic[63:0]  maxi_{port}_araddr,
	output logic[7:0]   maxi_{port}_arlen,
	output logic[2:0]   maxi_{port}_arsize,
	output logic[1:0]   maxi_{port}_arburst,
	output logic[2:0]   maxi_{port}_arprot,
	output logic[3:0]   maxi_{port}_arcache,
	output logic[3:0]   maxi_{port}_arqos,
	output logic        maxi_{port}_arlock,
	output logic[3:0]   maxi_{port}_arregion,
	input  logic        maxi_{port}_rvalid,
	output logic        maxi_{port}_rready,
	input  logic[255:0] maxi_{port}_rdata,
	input  logic[1:0]   maxi_{port}_rresp,
	input  logic        maxi_{port}_rlast,
	output logic[2:0]   maxi_{port}_awprot,
	output logic[3:0]   maxi_{port}_awcache,
	output logic[3:0]   maxi_{port}_awqos,
	output logic        maxi_{port}_awlock,
	output logic[3:0]   maxi_{port}_awregion,
"""

verilog += """
	output logic intr
);

endmodule
"""

with open('suspmv.sv', 'w') as file:
    file.write(verilog)
