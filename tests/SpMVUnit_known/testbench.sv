`include "matrix_params.vh"

// Testbench for module SpMVUnit #()
module SpMVUnit_tb;
	// Clocks
    logic clk = 0;
    initial #0 forever #5 clk = !clk;
    // {clk} input bool #() rst'1000
    logic rst;

    // Ports
    // {clk} output bool #() may_push'-200
    wire may_push;
    // {clk} input bool #() push'0
    logic push;
    // {clk} input bool #()[256] packed_matrix_data'0
    logic[255:0] packed_matrix_data;
    // {clk} output bool #() release_x_buffer'2000
    wire release_x_buffer;
    // {clk} input bool #() write_x_values'0
    logic write_x_values;
    // {clk} input float #()[16] x_values'0
    logic[31:0] x_values[0:15];
    // {clk} input bool #() is_last_write'0
    logic is_last_write;
    // {clk} input bool #() start_y_burst'0
    logic start_y_burst;
    // {clk} input bool #() may_y_valid'0
    logic may_y_valid;
    // {clk} output bool #() y_valid'0
    wire y_valid;
    // {clk} output float #()[16] output_y_values'2
    wire[31:0] output_y_values[0:15];
    // {clk} output int #(FROM: 0, TO: 17) num_y_valid'0
    wire[4:0] num_y_valid;
    // {clk} output bool #() is_last_y'0
    wire is_last_y;

    // DUT
    SpMVUnit_MAY_PUSH_LATENCY_229 dut(
        .clk(clk),
		// matrix data domain
        .may_push(may_push),
        .push(push),
        .packed_matrix_data(packed_matrix_data),
		// Release a single x buffer. If all Units release an X buffer, the X reader will read in another X buffer. 
        .release_x_buffer(release_x_buffer),
		// x data
        .write_x_values(write_x_values),
        .x_values(x_values),
        .is_last_write(is_last_write),
		// Grant the shared y bus token to this SpMVUnit
        .start_y_burst(start_y_burst),
		// y data
        .may_y_valid(may_y_valid),
        .y_valid(y_valid),
        .output_y_values(output_y_values),
        .num_y_valid(num_y_valid),
        .is_last_y(is_last_y),
		// reset domain
        .rst(rst)
    );
    
    localparam NUM_X_CHUNKS = `X_TILES * 64;
    localparam NUM_HBM_ELEMS = `HBM01_LEN;
    
    // HBM00
    //localparam int Y_BLOCK_START[`Y_REPEATS] = '{0, 1103};
	// HBM01
    localparam int Y_BLOCK_START[`Y_REPEATS] = '{36, 1104};
	logic[255:0] hbm_mem[NUM_HBM_ELEMS];
	logic[511:0] x_vec_values_mem[NUM_X_CHUNKS];
	logic[511:0] expected_buffer[(`Y_VEC_LEN + 15) / 16];
	int cur_x_tile;

	shortreal expected_y_values[`Y_VEC_LEN];
	int cur_y_value_idx;
	int cur_y_buffer_idx;

	initial begin
		$readmemh("hbm01.mem", hbm_mem);
		$readmemh("x_vec.mem", x_vec_values_mem);
		$readmemh("expected.mem", expected_buffer);
		for(int i = 0; i < `Y_VEC_LEN; i++) begin
			expected_y_values[i] = $bitstoshortreal(expected_buffer[i / 16][(i % 16) * 32 +: 32]);
		end

		rst <= 1;
		push <= 0;
		write_x_values <= 0;

		repeat(10) @(posedge clk);

		rst <= 0;
	end
	
	// Release x buffers, which lets new x values be streamed in
    int x_in_use = 0;
	initial begin
		wait(!rst);
	    repeat(10) @(posedge clk);
        
        forever @(posedge clk) begin
            if(release_x_buffer) begin
                x_in_use--;
            end
		end
	end

	// Loading of the X vector
	initial begin
	    wait(!rst);
	    repeat(10) @(posedge clk);
        
        repeat(`X_TILES * `Y_REPEATS) begin
            wait(x_in_use < 8);
            @(posedge clk);
            
            x_in_use++;
            for(int transfer = 0; transfer < 64; transfer++) begin
                @(posedge clk);
                write_x_values <= 1;
                for(int i = 0; i < 16; i++) begin
                    x_values[i] <= x_vec_values_mem[cur_x_tile * 64 + transfer][i * 32 +: 32];
                end
                is_last_write <= 0;
            end
            is_last_write <= 1;
            @(posedge clk);
            write_x_values <= 0;
            is_last_write <= 0;

            cur_x_tile = (cur_x_tile + 1) % `X_TILES;
            @(posedge clk);
		end
    end
    
    // Sending matrix weights
	initial begin
	    wait(!rst);
	    repeat(10) @(posedge clk);
        
		for(int i = 0; i < NUM_HBM_ELEMS; ) begin
			@(posedge clk);

			if(may_push) begin
				push <= 1;
				packed_matrix_data <= hbm_mem[i];
				i++;
			end else begin
				push <= 0;
			end
		end
        @(posedge clk);
        push <= 0;
	end
	
	always @(posedge clk) begin
        may_y_valid <= $urandom_range(0, 10) < 8;
	end
	
    /*latency*/ logic _y_valid_D1; always_ff @(posedge clk) begin _y_valid_D1 <= y_valid; end
    /*latency*/ logic _y_valid_D2; always_ff @(posedge clk) begin _y_valid_D2 <= _y_valid_D1; end
    /*latency*/ logic[4:0] _num_y_valid_D1; always_ff @(posedge clk) begin _num_y_valid_D1 <= num_y_valid; end
    /*latency*/ logic[4:0] _num_y_valid_D2; always_ff @(posedge clk) begin _num_y_valid_D2 <= _num_y_valid_D1; end
    /*latency*/ logic _is_last_y_D1; always_ff @(posedge clk) begin _is_last_y_D1 <= is_last_y; end
    /*latency*/ logic _is_last_y_D2; always_ff @(posedge clk) begin _is_last_y_D2 <= _is_last_y_D1; end
    
	// Receiving totals
	initial begin
		cur_y_value_idx <= Y_BLOCK_START[0];
		cur_y_buffer_idx <= 0;
        
        start_y_burst <= 0;
	    wait(!rst);
	    repeat(10) @(posedge clk);
        
        // #50000 // Wait a long time, to make sure the kernel has to stop once due to undelivered y values first. 
        
        @(posedge clk);
        start_y_burst <= 1;
        @(posedge clk);
        start_y_burst <= 0;

        forever @(posedge clk) begin
            if(_y_valid_D2) begin
                for(int i = 0; i < _num_y_valid_D2; i++) begin
                    automatic shortreal found = $bitstoshortreal(output_y_values[i]);
                    automatic shortreal exp = expected_y_values[cur_y_value_idx];
                    automatic shortreal diff = found - exp;
                    if((diff <= -1e-6) || (diff >= 1e-6)) begin
                        //$fatal("WRONG RESULT: @%0t [%0d]: found=%f exp=%f diff=%f",
                        //    $time, cur_y_value_idx, found, exp, diff);
                        // $stop();
                    end/* else begin
                        $display("RIGHT @%0t [%0d]: found=%f exp=%f",
                            $time, cur_y_value_idx, found, exp);
                    end*/
                    $display("RESULT: @%0t [%0d]: found=%f exp=%f",
                            $time, cur_y_value_idx, found, exp);
                    cur_y_value_idx++;
                end
                if(_is_last_y_D2) begin
                    cur_y_buffer_idx++;
                    cur_y_value_idx = Y_BLOCK_START[cur_y_buffer_idx];
                    if(cur_y_buffer_idx == `Y_REPEATS) begin
                        repeat(50) @(posedge clk);
                        $finish();
                    end
                    
                    @(posedge clk);
                    start_y_burst <= 1;
                    @(posedge clk);
                    start_y_burst <= 0;
                end
            end
        end
	end
endmodule // SpMVUnit_tb
