module controller_RTL (Start, Clock, Reset, A, Ram_Data, L_Bound, R_Bound, Load_A, Update_L, Update_R, Found_True, Init_Bound, Done); 
	
	input logic Start, Clock, Reset;
	input logic [7:0] A, Ram_Data;
	input logic [4:0] L_Bound, R_Bound;
	output logic Load_A, Found_True, Init_Bound, Done, Update_L, Update_R;
	
	
	enum {S1, S2, S3} present_state, next_state;
	

	// State transitions (edge sensitive) 
	always_ff @(posedge Clock) begin 
		if (Reset) present_state <= S1; 
		else present_state <= next_state; 
	end

	// code next-state logic directly from ASMD chart 
	always_comb begin 
		case (present_state) 
			S1: begin
				if (Start) next_state = S2; 
				else next_state = S1; 
			end
			S2: begin
				 if(A == Ram_Data || L_Bound == R_Bound) next_state = S3;
				 else next_state = S2;
			end
			S3: begin
				if (Start) next_state = S3; 
				else next_state = S1; 
			end
			default: next_state = S1; 
		endcase 
	end 
	
	
	assign Load_A = (present_state == S1) && ~Start;
	assign Found_True = (present_state == S2) && (A == Ram_Data);
	assign Update_L = (present_state == S2) && (L_Bound != R_Bound) && (A > Ram_Data);
	assign Update_R = (present_state == S2) && (L_Bound != R_Bound) && (A < Ram_Data);
	assign Init_Bound = (present_state == S1);
	assign Done = (present_state == S3);
	
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