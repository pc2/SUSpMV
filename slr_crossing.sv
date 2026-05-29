
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
