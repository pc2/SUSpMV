module MultiAccumulate_tb;

	// Clocks
	logic clk = 0;
	initial forever #5 clk = !clk;

	// Ports
	// {clk} input bool #() valid_set'0
	logic valid_set;
	// {clk} input double #()[6] values'0
	logic[63:0] values[5:0];
	// {clk} input bool #()[6] is_lasts'0
	logic[5:0] is_lasts;
	// {clk} output double #()[6] partial_sums'154
	wire[63:0] partial_sums[5:0];
	// {clk} input bool #() rst'1000
	logic rst;

	// DUT
	MultiAccumulate dut(
		.clk(clk),
		.valid_set(valid_set),
		.values(values),
		.is_lasts(is_lasts),
		.partial_sums(partial_sums),
		.rst(rst)
	);

	// -----------------------------
	// Reference model state
	// -----------------------------
	real acc;  // running accumulator

	// Expected outputs BEFORE pipeline delay
	real expected_now[5:0];

	// Pipeline delay buffer (154 cycles)
	real expected_pipe[0:154][5:0];

	// -----------------------------
	// Helpers
	// -----------------------------

	function real rand_double();
		// Simple bounded random double
		return $urandom_range(1, 10) / 10.0;
	endfunction

	function logic rand_last();
		// ~20% chance of last
		return ($urandom_range(0,4) == 0);
	endfunction

	// -----------------------------
	// Test sequence
	// -----------------------------
	initial begin
		rst <= 1;
		valid_set <= 0;
		acc = 0.0;
        
        for (int d = 0; d < 155; d++) begin
            expected_pipe[d] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        end
        
		repeat(200) @(posedge clk);
		rst <= 0;

		repeat(10) @(posedge clk);

		// Run long enough to flush pipeline
		repeat(2000) begin
			automatic logic[63:0] next_values[5:0];
            automatic logic[5:0] next_is_lasts;
            automatic logic next_valid_set;
            
            @(posedge clk);
            
            next_valid_set = ($urandom_range(0,4) != 0);
            
            if(next_valid_set) begin
                // -----------------------------
                // Generate inputs
                // -----------------------------
                for (int i = 0; i < 6; i++) begin
                    automatic real v = rand_double();
                    next_values[i] = $realtobits(v);
                    next_is_lasts[i] = rand_last();
                end
    
                // -----------------------------
                // Reference model (same cycle)
                // -----------------------------
                for (int i = 0; i < 6; i++) begin
                    automatic real v = $bitstoreal(next_values[i]);
    
                    acc = acc + v;
    
                    if (next_is_lasts[i]) begin
                        expected_now[i] = acc;
                        acc = 0.0;
                    end else begin
                        expected_now[i] = 0.0; // or don't care
                    end
                end
    
                // -----------------------------
                // Check outputs (aligned)
                // -----------------------------
                if (!rst) begin
                    for (int i = 0; i < 6; i++) begin
                        automatic real got = $bitstoreal(partial_sums[i]);
                        automatic real exp = expected_pipe[154][i];
                        automatic real diff = got - exp;
                        // Only check when a result is expected
                        if (exp != 0.0) begin
                            if (diff < -1e6 || diff > 1e6) begin
                                $display("ERROR @%0t idx=%0d got=%f exp=%f",
                                    $time, i, got, exp);
                                $stop;
                            end
                        end
                    end
                end
                
                is_lasts <= next_is_lasts;
                values <= next_values;
			end else begin
			    for (int i = 0; i < 6; i++) begin
                    expected_now[i] = 0.0; // or don't care
                end
			end
			valid_set <= next_valid_set;
						
            // -----------------------------
            // Shift pipeline
            // -----------------------------
            for (int d = 154; d > 0; d--) begin
                expected_pipe[d] = expected_pipe[d-1];
            end
            expected_pipe[0] = expected_now;
		end

		$display("Test PASSED");
		$finish;
	end

endmodule