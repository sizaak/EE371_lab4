module controller_RTL (s, clock, reset_b, load_A, rightshift_A, result_zero, incr_result, done, z, a0); 
	output logic load_A, rightshift_A, result_zero, incr_result, done; 
	input logic s, clock, reset_b, z, a0; 
	
	logic [1: 0] present_state, next_state; 
	parameter s1 = 2'b00, s2 = 2'b01, s3 = 2'b11; // state codes 
	

	// State transitions (edge sensitive) 
	always_ff @(posedge clock) begin 
		if (reset_b) present_state <= s1; 
		else present_state <= next_state; 
	end

	// code next-state logic directly from ASMD chart 
	always_comb begin 
		case (present_state) 
			s1: begin
				if (s) next_state = s2; 
				else next_state = s1; 
			end
			s2: begin
				if(z) next_state = s3;
				else next_state = s2; 
			end
			s3: begin
				if (s) next_state = s3; 
				else next_state = s1; 
			end
			default: next_state = s1; 
		endcase 
	end 
	
	assign load_A = (present_state == s1) && ~s;
	assign result_zero = (present_state == s1);
	assign rightshift_A = (present_state == s2) && ~z;
	assign incr_result = a0 && ~z && (present_state == s2);
	assign done = (present_state == s3);
	
endmodule 
	
	
	/*
	
module tb_controller();
	logic LA, EA, EB, LB, done; 
	logic start, clock, reset_b; 
	//logic [7:0] A;
	
	parameter CLOCK_PERIOD = 100;
	
	controller_RTL dut (.start, .clock, .reset_b, .LA, .EA, .EB, .LB, .done); 
	

	initial begin
		clock <= 0;
		forever#(CLOCK_PERIOD/2) clock = ~clock;
	end
	
	initial begin
		reset_b <= 1; @(posedge clock);
		reset_b <= 0; start <= 0; A <= 8'b10101010;@(posedge clock);
		start <= 1; @(posedge clock);
		A <= 8'b01010101;@(posedge clock);
		A <= 8'b00101010;@(posedge clock);
		A <= 8'b00010101;@(posedge clock);
		A <= 8'b00001010;@(posedge clock);
		A <= 8'b00000101;@(posedge clock);
		A <= 8'b00000010;@(posedge clock);
		A <= 8'b00000001;@(posedge clock);
		A <= 8'b00000000;@(posedge clock);
		start <= 0;@(posedge clock);
		@(posedge clock);
		$stop;
	end
	
endmodule
*/