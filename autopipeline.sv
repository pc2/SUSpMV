
(* autopipeline_module = "true" *)
module primitive_autopipeline # (
    parameter integer C_DATA_WIDTH = 32
) (
    input wire clk,
    input wire [C_DATA_WIDTH-1:0] din,
    (* autopipeline_group="fwt",autopipeline_limit=12 *)
    output reg [C_DATA_WIDTH-1:0] dout
);

    always @(posedge clk) begin
        dout <= din;
    end
endmodule
