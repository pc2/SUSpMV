// Testbench for module SpMVUnit #()
module SpMVUnit_tb;
	// Clocks
	logic clk = 0;
	initial #0 forever #5 clk = !clk;

	// Ports
	// {clk} input bool #() push'0
	logic push;
	// {clk} input bool #()[256] packed_matrix_data'0
	logic[255:0] packed_matrix_data;
	// {clk} input bool #() is_last'0
	logic is_last;
	// {clk} input bool #() write_x_values'0
	logic write_x_values;
	// {clk} input float #()[8] x_values'0
	logic[31:0] x_values[7:0];
	// {clk} input bool #() is_last_write'0
	logic is_last_write;
	// {clk} output bool #() may_take_totals'1000
	wire may_take_totals;
	// {clk} input bool #() take_totals'1000
	logic take_totals;
	// {clk} output double #()[16] totals'1001
	wire[63:0] totals[15:0];
	// {clk} input bool #() rst'2000
	logic rst;

	// Latency Registers
	/*latency*/ logic _may_take_totals_D1001; always_ff @(posedge clk) begin _may_take_totals_D1001 <= may_take_totals; end
	/*latency*/ logic _take_totals_D1001; always_ff @(posedge clk) begin _take_totals_D1001 <= take_totals; end

	function automatic logic [255:0] pack_float6(
		input logic [31:0] weights [6],
		input logic [9:0]  x_idx   [6], // x_idx[0] = lowest index
		input logic [3:0]  mode
	);
		logic [255:0] data;
		data = '0;

		// --- Floats [0:192]
		for (int i = 0; i < 6; i++) begin
			data[i*32 +: 32] = weights[i];
		end

		// --- X indices [192:252] (reverse order)
		for (int i = 0; i < 6; i++) begin
			data[192 + i*10 +: 10] = x_idx[5 - i];
		end

		// --- Mode [252:256]
		data[252 +: 4] = mode;

		return data;
	endfunction

	function automatic logic [255:0] pack_float5(
		input logic [31:0] weights [5],
		input logic [7:0]  y_delta [5],
		input logic [9:0]  x_idx   [5]
	);
		logic [255:0] data;
		data = '0;

		// --- Floats [0:160]
		for (int i = 0; i < 5; i++) begin
			data[i*32 +: 32] = weights[i];
		end

		// --- Y deltas [160:200]
		for (int i = 0; i < 5; i++) begin
			data[160 + i*8 +: 8] = y_delta[i];
		end

		// --- [200:202] UNUSED (already zero)

		// --- X indices [202:252] (reverse order)
		for (int i = 0; i < 5; i++) begin
			data[202 + i*10 +: 10] = x_idx[4 - i];
		end

		// --- Mode [252:256]
		data[252 +: 4] = 4'b1111;

		return data;
	endfunction

	// DUT
	SpMVUnit dut(
		.clk(clk),
		.push(push),
		.packed_matrix_data(packed_matrix_data),
		.is_last(is_last),
		.write_x_values(write_x_values),
		.x_values(x_values),
		.is_last_write(is_last_write),
		.may_take_totals(may_take_totals),
		.take_totals(take_totals),
		.totals(totals),
		.rst(rst)
	);

	initial begin
		rst <= 1;
		push <= 0;
		write_x_values <= 0;
		take_totals <= 0;

		repeat(200) @(posedge clk);

		rst <= 0;
		repeat(10) @(posedge clk);

		write_x_values <= 1;
		repeat(64) begin


			@(posedge clk);
		end
		write_x_values <= 0;
	end
endmodule // SpMVUnit_tb
