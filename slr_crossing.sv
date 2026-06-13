
module primitive_pipeline #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 12
) (
    input wire clk,
    input wire[WIDTH-1:0] din,
    output wire[WIDTH-1:0] dout
);
    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    (* USER_CROSSING_SLR = "true" *)
    reg[WIDTH-1:0] pipeline_stages[0 : DEPTH-1];

    always_ff @(posedge clk) begin
        pipeline_stages[0] <= din;
        for(int i = 0; i < DEPTH; i++) begin
            pipeline_stages[i+1] <= pipeline_stages[i];
        end
    end

    assign dout = pipeline_stages[DEPTH-1];
endmodule

module primitive_pipeline_to_slr_crossing #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 12
) (
    input wire clk,
    input wire[WIDTH-1:0] din,
    output wire[WIDTH-1:0] dout_laguna
);
    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    reg[WIDTH-1:0] pipeline_stages[0 : DEPTH-2];

    always_ff @(posedge clk) begin
        pipeline_stages[0] <= din;
        for(int i = 0; i < DEPTH-1; i++) begin
            pipeline_stages[i+1] <= pipeline_stages[i];
        end
    end

    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    (* user_sll_reg = 1 *)
    reg[WIDTH-1:0] suspmv_dout_laguna_reg;    
    always_ff @(posedge clk) begin
        suspmv_dout_laguna_reg <= pipeline_stages[DEPTH-2];
    end
    assign dout_laguna = suspmv_dout_laguna_reg;
endmodule

module primitive_pipeline_from_slr_crossing #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 12
) (
    input wire clk,
    input wire[WIDTH-1:0] din_laguna,
    output wire[WIDTH-1:0] dout
);
    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    reg[WIDTH-1:0] pipeline_stages[0 : DEPTH-2];

    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    (* user_sll_reg = 1 *)
    reg[WIDTH-1:0] suspmv_din_laguna_reg;

    always_ff @(posedge clk) begin
        suspmv_din_laguna_reg <= din_laguna;
        pipeline_stages[0] <= suspmv_din_laguna_reg;
        for(int i = 0; i < DEPTH-1; i++) begin
            pipeline_stages[i+1] <= pipeline_stages[i];
        end
    end

    assign dout = pipeline_stages[DEPTH-2];
endmodule

module primitive_pipeline_slr_crossing_to_slr_crossing #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 12
) (
    input wire clk,
    input wire[WIDTH-1:0] din_laguna,
    output wire[WIDTH-1:0] dout_laguna
);
    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    reg[WIDTH-1:0] pipeline_stages[0 : DEPTH-3];

    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    (* user_sll_reg = 1 *)
    reg[WIDTH-1:0] suspmv_din_laguna_reg;

    always_ff @(posedge clk) begin
        suspmv_din_laguna_reg <= din_laguna;
        pipeline_stages[0] <= suspmv_din_laguna_reg;
        for(int i = 0; i < DEPTH-2; i++) begin
            pipeline_stages[i+1] <= pipeline_stages[i];
        end
    end

    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    (* user_sll_reg = 1 *)
    reg[WIDTH-1:0] suspmv_dout_laguna_reg;    
    always_ff @(posedge clk) begin
        suspmv_dout_laguna_reg <= pipeline_stages[DEPTH-3];
    end
    assign dout_laguna = suspmv_dout_laguna_reg;
endmodule


// Reimplement FWFT in SystemVerilog, to use Distributed RAM, and save on BRAMs. 
module LUTRAM_FWFT #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 64,
    parameter integer MAY_PUSH_LATENCY = 12
) (
	/* clock */ input clk,
	output /*mux_wire*/ logic may_push,
	input wire push,
	input wire[WIDTH-1:0] push_data,
	output /*mux_wire*/ logic pop_available,
	output /*mux_wire*/ logic[WIDTH-1:0] pop_data,
	input wire pop,
	input wire rst
);

(* ram_style = "distributed" *) logic[WIDTH-1:0] mem[0:DEPTH-1];
/*state*/ logic[$clog2(DEPTH)-1:0] read_addr;
/*state*/ logic[$clog2(DEPTH)-1:0] write_addr;
// Pipeline the write fields, because there seems to be a lot of trouble getting the write addr distributed. 
logic[$clog2(DEPTH)-1:0] write_addr_pipeline;
logic[WIDTH-1:0] push_data_pipeline;
logic push_pipeline;
always_ff @(posedge clk) begin
    write_addr_pipeline <= write_addr;
    push_data_pipeline <= push_data;
    push_pipeline <= push;
end
always_ff @(posedge clk) begin
    if(rst) begin
        read_addr <= 0;
        pop_available <= 1'b0;
    end else if(!pop_available || pop) begin
        if(read_addr != write_addr_pipeline) begin
            pop_data <= mem[read_addr];
            pop_available <= 1'b1;
            read_addr <= read_addr + 1;
        end else begin
            pop_available <= 1'b0;
        end
    end
end
always_ff @(posedge clk) begin // state mem
	if(push_pipeline) mem[write_addr_pipeline] <= push_data_pipeline;
end
always_ff @(posedge clk) begin // state write_addr
	if(push) write_addr <= write_addr + 1;
	if(rst) write_addr <= 0;
end
/*mux_wire*/ logic[7:0] space_remaining;
assign space_remaining = read_addr - write_addr - 1;
always_ff @(posedge clk) begin
	may_push <= space_remaining > MAY_PUSH_LATENCY - 2;
end
endmodule
