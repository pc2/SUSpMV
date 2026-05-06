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
    // {clk} input bool #() end_of_x_chunk'0
    logic end_of_x_chunk;
    // {clk} input bool #() full_end'0
    logic full_end;
    // {clk} input bool #() write_x_values'0
    logic write_x_values;
    // {clk} input float #()[16] x_values'0
    logic[31:0] x_values[0:15];
    // {clk} input bool #() is_last_write'0
    logic is_last_write;
    // {clk} output bool #() may_request_y'-5
    wire may_request_y;
    // {clk} input bool #() request_y'0
    logic request_y;
    // {clk} input int #(FROM: 0, TO: 32768) y_index'0
    logic[14:0] y_index;
    // {clk} input bool #() is_last_y_req'0
    logic is_last_y_req;
    // {clk} input bool #() try_get_y'-2
    logic try_get_y;
    // {clk} output bool #() y_valid'0
    wire y_valid;
    // {clk} output double #() y'0
    wire[63:0] y;
    // {clk} output bool #() last_y'0
    wire last_y;
    // {clk} input bool #() rst'1000
    logic rst;

    logic[31:0] matrix_data_as_floats[7:0];
    always @(*) begin
        for(int i = 0; i < 8; i++) begin
            matrix_data_as_floats[i] = packed_matrix_data[i*32 +: 32];
        end
    end
    
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
		input logic [7:0]  y_delta [5]
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
        .end_of_x_chunk(end_of_x_chunk),
        .full_end(full_end),
        .write_x_values(write_x_values),
        .x_values(x_values),
        .is_last_write(is_last_write),
        .may_request_y(may_request_y),
        .request_y(request_y),
        .y_index(y_index),
        .is_last_y_req(is_last_y_req),
        .try_get_y(try_get_y),
        .y_valid(y_valid),
        .y(y),
        .last_y(last_y),
        .rst(rst)
    );
    
	shortreal x_vec_values[1024];

	task automatic load_x_vector();
		int cur_idx = 0;
		repeat(64) begin
			@(posedge clk);
			write_x_values <= 1;
			for(int i = 0; i < 16; i++) begin
				shortreal x_val = $urandom_range(1, 10) * 1.0;
				x_values[i] <= $shortrealtobits(x_val);
				x_vec_values[cur_idx++] = x_val;
			end
			is_last_write <= 0;
		end
		is_last_write <= 1;
		@(posedge clk);
		write_x_values <= 0;
		is_last_write <= 0;
	endtask

	real expected_y_values[16*2048];
	real current_total;
	int cur_y_value_idx;
	int cur_output_idx;

	initial begin
		rst <= 1;
		push <= 0;
		write_x_values <= 0;
        
        // 4096 cycles of reset required to clear out the Y vector RAM
		repeat(4100) @(posedge clk);

		rst <= 0;
		repeat(10) @(posedge clk);

		load_x_vector();

		repeat(10) @(posedge clk);

		cur_y_value_idx = 0;
		current_total = 0.0;
		for(int i = 0; i < 16*2048; i++) begin
			expected_y_values[i] = 0.0;
		end
        
        
        
		repeat(100) begin
			@(posedge clk);

			push <= 1;
			end_of_x_chunk <= 0;
			full_end <= 0;
			if($urandom_range(0, 1) == 1) begin
			    shortreal weights[5];
			    logic[9:0] x_indices[5];
			    logic[7:0] y_deltas[5];
			    for(int i = 0; i < 5; i++) begin
			        shortreal this_term;
			        
                    weights[i] = $urandom_range(1, 10) * 1.0;
                    x_indices[i] = $urandom_range(0, 1 << 10);
                    if($urandom_range(0, 10) == 0) begin
                        y_deltas[i] = $urandom_range(1, 1 << 8);
                    end else begin
                        y_deltas[i] = 0;
                    end
                    
                    this_term = weights[i] * x_vec_values[x_indices[i]];
					current_total += this_term;
					
					if(y_deltas[i] != 0) begin
					    //$display("Term %d is %f*[%d]%f=%f LAST   Total for Y:%d is %f", i, weights[i], x_indices[i], x_vec_values[x_indices[i]], this_term, cur_y_value_idx, current_total);
						expected_y_values[cur_y_value_idx] += current_total;
						current_total = 0.0;
						cur_y_value_idx += y_deltas[i];
					end else begin
					    //$display("Term %d is %f*[%d]%f=%f", i, weights[i], x_indices[i], x_vec_values[x_indices[i]], this_term);
					end
			    end
				packed_matrix_data <= pack_float5(weights, x_indices, y_deltas);
			end else begin
			    shortreal weights[6];
			    logic[9:0] x_indices[6];

				automatic logic[31:0] prev_x_index = 0;
			    for(int i = 0; i < 6; i++) begin
			        shortreal this_term;
			        
                    weights[i] = $urandom_range(1, 10) * 1.0;
                    x_indices[i] = $urandom_range(0, 1 << 10);
					
                    this_term = weights[i] * x_vec_values[x_indices[i]];
					current_total += this_term;

					if(i != 0 && x_indices[i] <= prev_x_index) begin
					    //$display("Term %d is %f*[%d]%f=%f LAST   Total for Y:%d is %f", i, weights[i], x_indices[i], x_vec_values[x_indices[i]], this_term, cur_y_value_idx, current_total);
						expected_y_values[cur_y_value_idx] += current_total;
						current_total = 0.0;
						cur_y_value_idx += 1;
					end else begin
					    //$display("Term %d is %f*[%d]%f=%f", i, weights[i], x_indices[i], x_vec_values[x_indices[i]], this_term);
					end
					prev_x_index = x_indices[i];
			    end
				packed_matrix_data <= pack_float6(weights, x_indices, 4'b0000);
			end
		end
		end_of_x_chunk <= 1;
        full_end <= 1;
		@(posedge clk);
		push <= 0;
		end_of_x_chunk <= 0;
        full_end <= 0;
	end
	
	// Gathering of totals
	initial begin
	    try_get_y <= 0;
	    wait(!rst);
	    repeat(10) @(posedge clk);
	    
	    fork
	        begin
	            automatic int cur_y_request_idx = 0;
	            forever @(posedge clk) begin
	                if(may_request_y) begin
	                    request_y <= 1;
	                    y_index <= cur_y_request_idx;
	                    is_last_y_req <= cur_y_request_idx == 1000;
	                    cur_y_request_idx += 1;
	                end else begin
	                    request_y <= 0;
	                end
	            end
	        end
	        begin
	            automatic int cur_output_idx = 0;
	            try_get_y <= 1;
	            forever @(posedge clk) begin
                    if(y_valid) begin
                        automatic real found = $bitstoreal(y);
                        automatic real exp = expected_y_values[cur_output_idx];
                        automatic real diff = found - exp;
                        if(diff < -1e6 || diff > 1e6) begin
                            $fatal("FATAL @%0t [%0d]: found=%f exp=%f",
                                $time, cur_output_idx, found, exp);
                        end/* else begin
                            $display("RIGHT @%0t [%0d]: found=%f exp=%f",
                                $time, cur_output_idx, found, exp);
                        end*/
                        cur_output_idx++;
                        
                        if(last_y) begin
                            repeat(50) @(posedge clk);
                            $finish();
                        end
                    end
	            end
	        end
	    join
	end
endmodule // SpMVUnit_tb
