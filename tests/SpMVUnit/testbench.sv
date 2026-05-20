// Testbench for module SpMVUnit #()
module SpMVUnit_tb;
	// Clocks
    logic clk = 0;
    initial #0 forever #5 clk = !clk;

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
    // {clk} input bool #() rst'1000
    logic rst;

    // DUT
    SpMVUnit dut(
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
    
	function automatic logic [255:0] pack_float6(
		input shortreal    weights [6],
		input logic [9:0]  x_idx   [6], // x_idx[0] = lowest index
		input logic [3:0]  mode
	);
		logic [255:0] data;
		data = '0;

		// --- Floats [0:192]
		for (int i = 0; i < 6; i++) begin
			data[i*32 +: 32] = $shortrealtobits(weights[i]);
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
		input shortreal    weights [5],
    	input logic [9:0]  x_idx   [5],
		input logic [7:0]  y_delta [5],
		input logic x_end,
		input logic y_end
	);
		logic [255:0] data;
		data = '0;

		// --- Floats [0:160]
		for (int i = 0; i < 5; i++) begin
			data[i*32 +: 32] = $shortrealtobits(weights[i]);
		end

		// --- Y deltas [160:200]
		for (int i = 0; i < 5; i++) begin
			data[160 + i*8 +: 8] = y_delta[i];
		end

		// --- [200:202] X and Y end
		data[200] = x_end;
		data[201] = y_end;

		// --- X indices [202:252] (reverse order)
		for (int i = 0; i < 5; i++) begin
			data[202 + i*10 +: 10] = x_idx[4 - i];
		end

		// --- Mode [252:256]
		data[252 +: 4] = 4'b1111;

		return data;
	endfunction
    
    localparam NUM_X_CHUNKS = 3;
    localparam NUM_Y_BUFFERS = 100;
	shortreal x_vec_values[1024][NUM_X_CHUNKS];
	int cur_write_x_buf_idx;
	int cur_read_x_buf_idx;

	real expected_y_values[16*2048][NUM_Y_BUFFERS];
	real current_accumulator;
	int cur_y_value_idx;
	int cur_y_buffer_idx;
	int cur_y_value_output_idx;
	int cur_y_buffer_output_idx;
	int last_y_values[NUM_Y_BUFFERS];

	initial begin
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
	    for(int chunk_i = 0; chunk_i < NUM_X_CHUNKS; chunk_i++) begin
	        for(int idx_in_chunk = 0; idx_in_chunk < 1024; idx_in_chunk++) begin
                automatic shortreal x_val = $urandom_range(1, 10) * 1.0;
                x_vec_values[idx_in_chunk][chunk_i] = x_val;
            end
	    end 
	    wait(!rst);
	    repeat(10) @(posedge clk);
        
        repeat(NUM_X_CHUNKS * NUM_Y_BUFFERS) begin
            automatic int cur_idx_in_x = 0;
            
            wait(x_in_use < 8);
            @(posedge clk);
            
            x_in_use++;
            repeat(64) begin
                @(posedge clk);
                write_x_values <= 1;
                for(int i = 0; i < 16; i++) begin
                    x_values[i] <= $shortrealtobits(x_vec_values[cur_idx_in_x++][cur_write_x_buf_idx]);
                end
                is_last_write <= 0;
            end
            is_last_write <= 1;
            @(posedge clk);
            write_x_values <= 0;
            is_last_write <= 0;

            cur_write_x_buf_idx = (cur_write_x_buf_idx + 1) % NUM_X_CHUNKS;
            @(posedge clk);
		end
    end
    
    // Sending matrix weights
	initial begin
	    wait(!rst);
	    repeat(10) @(posedge clk);
        
		for(int buf_i = 0; buf_i < NUM_Y_BUFFERS; buf_i++) begin
			for(int i = 0; i < 16*2048; i++) begin
				expected_y_values[i][buf_i] = 0.0;
			end
		end
        
		cur_y_value_idx = 0;
	    cur_y_buffer_idx = 0;
	    for(int i = 0; i < NUM_Y_BUFFERS; i++) begin
	        last_y_values[i] = 0;
	    end
		current_accumulator = 0.0;
		forever begin
			@(posedge clk);

			if(may_push/* && ($urandom_range(0, 10) != 1)*/) begin
				if($urandom_range(0, 1) == 1) begin
					// Give it a little room, so we can be sure the last y value has been processed before we arrive at it again
					automatic bit last_x = (cur_y_value_idx >= 100) && ($urandom_range(0, 200) == 0);
					automatic bit last_y = last_x && (cur_read_x_buf_idx == NUM_X_CHUNKS - 1);
					
					shortreal weights[5];
					logic[9:0] x_indices[5];
					logic[7:0] y_deltas[5];
					for(int i = 0; i < 5; i++) begin
						weights[i] = $urandom_range(1, 10) * 1.0;
						x_indices[i] = $urandom_range(0, 1 << 10);
						if($urandom_range(0, 10) == 0) begin
							y_deltas[i] = $urandom_range(1, 1 << 2);
						end else begin
							y_deltas[i] = 0;
						end
					end
					
					// Input sanitation, on a last_x value, all weights after the last value must be 0.0. We solve this by making the value[4] always "is_last"
					if(last_x) begin
					    y_deltas[4] = 1;
					end
					
					for(int i = 0; i < 5; i++) begin
						automatic shortreal this_term = weights[i] * x_vec_values[x_indices[i]][cur_read_x_buf_idx];
						current_accumulator += this_term;
						
						if(y_deltas[i] != 0) begin
                            automatic real prev_total_total = expected_y_values[cur_y_value_idx][cur_y_buffer_idx];
                            automatic real new_total_total = prev_total_total + current_accumulator;
							if(cur_y_value_idx == 160) begin
							    automatic logic x;
							    automatic real new_total = expected_y_values[cur_y_value_idx][cur_y_buffer_idx];
							    $display("Float5 Subtotal %d to add is %f    Current Running Total is %f => %f", cur_y_value_idx, current_accumulator, prev_total_total, new_total_total);
							    x = 0;
							end
							expected_y_values[cur_y_value_idx][cur_y_buffer_idx] = new_total_total;
							current_accumulator = 0.0;
							if(cur_y_value_idx > last_y_values[cur_y_buffer_idx]) begin
							    last_y_values[cur_y_buffer_idx] = cur_y_value_idx;
                            end
							cur_y_value_idx += y_deltas[i];
						end else begin
							//$display("Term %d is %f*[%d]%f=%f", i, weights[i], x_indices[i], x_vec_values[x_indices[i]], this_term);
						end
					end
					push <= 1;
					packed_matrix_data <= pack_float5(weights, x_indices, y_deltas, last_x, last_y);
					if(last_x) begin
						cur_read_x_buf_idx = (cur_read_x_buf_idx + 1) % NUM_X_CHUNKS;
						current_accumulator = 0.0;
						cur_y_value_idx = 0;
					end
					if(last_y) begin
						cur_y_buffer_idx = cur_y_buffer_idx + 1;
						if(cur_y_buffer_idx == NUM_Y_BUFFERS) begin
							break;
						end
					end
				end else begin
					shortreal weights[6];
					logic[9:0] x_indices[6];

					for(int i = 0; i < 6; i++) begin
						weights[i] = $urandom_range(1, 10) * 1.0;
						x_indices[i] = $urandom_range(0, 1 << 10);
				    end
				    
					for(int i = 0; i < 6; i++) begin
						automatic shortreal this_term = weights[i] * x_vec_values[x_indices[i]][cur_read_x_buf_idx];
						current_accumulator += this_term;

						if(i != 5 && x_indices[i+1] <= x_indices[i]) begin
                            automatic real prev_total_total = expected_y_values[cur_y_value_idx][cur_y_buffer_idx];
                            automatic real new_total_total = prev_total_total + current_accumulator;
							if(cur_y_value_idx == 160) begin
							    automatic logic x;
							    automatic real new_total = expected_y_values[cur_y_value_idx][cur_y_buffer_idx];
							    $display("Float6 Subtotal %d to add is %f    Current Running Total is %f => %f", cur_y_value_idx, current_accumulator, prev_total_total, new_total_total);
							    x = 0;
							end
							expected_y_values[cur_y_value_idx][cur_y_buffer_idx] = new_total_total;
							current_accumulator = 0.0;
							if(cur_y_value_idx > last_y_values[cur_y_buffer_idx]) begin
							    last_y_values[cur_y_buffer_idx] = cur_y_value_idx;
                            end
							cur_y_value_idx += 1;
						end else begin
							//$display("Term %d is %f*[%d]%f=%f", i, weights[i], x_indices[i], x_vec_values[x_indices[i]], this_term);
						end
					end
					push <= 1;
					packed_matrix_data <= pack_float6(weights, x_indices, 4'b0000);
				end
			end else begin
				push <= 0;
			end
		end
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
        cur_y_value_output_idx = 0;
		cur_y_buffer_output_idx = 0;
        
        start_y_burst <= 0;
	    wait(!rst);
	    repeat(10) @(posedge clk);
        
        #50000 // Wait a long time, to make sure the kernel has to stop once due to undelivered y values first. 
        
        @(posedge clk);
        start_y_burst <= 1;
        @(posedge clk);
        start_y_burst <= 0;

        forever @(posedge clk) begin
            if(_y_valid_D2) begin
                if(_is_last_y_D2) begin
                    automatic int found_total_ys = cur_y_value_output_idx + _num_y_valid_D2;
                    automatic int expected_num_ys = last_y_values[cur_y_buffer_output_idx] + 1;
                    
                    if(expected_num_ys != found_total_ys) begin
                        $fatal("NUMBER OF RESULTS: @%0t, Expected Y section %0d to be of length %0d, but actually was of length %0d",
                            $time, cur_y_buffer_output_idx, expected_num_ys, found_total_ys);
                    end
                end
                for(int i = 0; i < 16; i++) begin
                    automatic shortreal found = $bitstoshortreal(output_y_values[i]);
                    automatic real exp = expected_y_values[cur_y_value_output_idx][cur_y_buffer_output_idx];
                    automatic real diff = found - exp;
                    if((diff <= -1e-6) || (diff >= 1e-6)) begin
                        $fatal("WRONG RESULT: @%0t [%0d]: found=%f exp=%f diff=%f",
                            $time, cur_y_value_output_idx, found, exp, diff);
                        // $stop();
                    end/* else begin
                        $display("RIGHT @%0t [%0d]: found=%f exp=%f",
                            $time, cur_y_value_output_idx, found, exp);
                    end*/
                    $display("RESULT: @%0t [%0d]: found=%f exp=%f",
                            $time, cur_y_value_output_idx, found, exp);
                    cur_y_value_output_idx++;
                end
                if(_is_last_y_D2) begin
                    cur_y_buffer_output_idx++;
                    cur_y_value_output_idx = 0;
                    if(cur_y_buffer_output_idx == NUM_Y_BUFFERS) begin
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
