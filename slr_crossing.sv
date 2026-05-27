
module primitive_pipeline # (
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
    reg[WIDTH-1:0] pipeline_stages[0 : DEPTH-1];

    always_ff @(posedge clk) begin
        pipeline_stages[0] <= din;
        for(int i = 0; i < DEPTH; i++) begin
            pipeline_stages[i+1] <= pipeline_stages[i];
        end
    end

    assign dout = pipeline_stages[DEPTH-1];
endmodule
