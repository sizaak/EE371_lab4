module controller_RTL (Start, Clock, Resetn, A, Ram_Data, L_Bound, R_Bound, 
								Load_A, Update_L, Update_R, Found_True, Init_Bound, Done); 
	
	input logic Start, Clock, Resetn;
	input logic [7:0] A, Ram_Data;
	input logic [4:0] L_Bound, R_Bound;
	output logic Load_A, Found_True, Init_Bound, Done, Update_L, Update_R;
	
	enum {S1, S2, S3, S4} present_state, next_state;

	// State transitions (edge sensitive) 
	always_ff @(posedge Clock) begin 
		if (Resetn) present_state <= S1; 
		else present_state <= next_state; 
	end

	// code next-state logic directly from ASMD chart 
	always_comb begin 
		case (present_state) 
			S1: begin
				if(Start) next_state = S2; 
				else next_state = S1; 
			end
			S2: begin
				 if(A == Ram_Data || L_Bound >= R_Bound) next_state = S4;
				 else next_state = S3;
			end
			S3: begin
				next_state = S2;
			end
			S4: begin
				if (Start) next_state = S4; 
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
	assign Done = (present_state == S4);
	
endmodule 

	
module tb_controller();
	logic Start, Clock, Resetn;
	logic [7:0] A, Ram_Data;
	logic [4:0] L_Bound, R_Bound;
	logic Load_A, Found_True, Init_Bound, Done, Update_L, Update_R;
	
	parameter CLOCK_PERIOD = 100;
	
	controller_RTL dut (.Start, .Clock, .Resetn, .A, .Ram_Data, .L_Bound, .R_Bound, 
								.Load_A, .Update_L, .Update_R, .Found_True, .Init_Bound, .Done);  

	initial begin
		Clock <= 0;
		forever#(CLOCK_PERIOD/2) Clock = ~Clock;
	end
	
	initial begin
		Resetn <= 1; Start <= 0;@(posedge Clock);
		Resetn <= 0; L_Bound <= 5'd0; R_Bound <= 5'd31; A <= 8'd0; @(posedge Clock);
		Start <= 1; Ram_Data <= 8'd32; @(posedge Clock);
		R_Bound <= 5'd14; Ram_Data <= 8'd16;@(posedge Clock);
		R_Bound <= 5'd6; Ram_Data <= 8'd8; @(posedge Clock);
		R_Bound <= 5'd2; Ram_Data <= 8'd4; @(posedge Clock);
		R_Bound <= 5'd0; Ram_Data <= 8'd2; @(posedge Clock);@(posedge Clock);
		Start <= 0; @(posedge Clock);
		L_Bound <= 5'd0; R_Bound <= 5'd31; A <= 8'd50; @(posedge Clock);
		Start <= 1; Ram_Data <= 8'd20; @(posedge Clock);
		L_Bound <= 5'd16; Ram_Data <= 8'd24;@(posedge Clock);
		L_Bound <= 5'd24; Ram_Data <= 8'd28; @(posedge Clock);
		L_Bound <= 5'd28; Ram_Data <= 8'd32; @(posedge Clock);
		L_Bound <= 5'd30; Ram_Data <= 8'd36; @(posedge Clock);
		L_Bound <= 5'd31; Ram_Data <= 8'd40; @(posedge Clock);@(posedge Clock);
		Start <= 0; @(posedge Clock);
		L_Bound <= 5'd0; R_Bound <= 5'd31; A <= 8'd42; @(posedge Clock);
		Start <= 1; Ram_Data <= 8'd36; @(posedge Clock);
		L_Bound <= 5'd16; Ram_Data <= 8'd40;@(posedge Clock);
		L_Bound <= 5'd24; Ram_Data <= 8'd46; @(posedge Clock);
		R_Bound <= 5'd26; Ram_Data <= 8'd42; @(posedge Clock);@(posedge Clock);
		Start <= 0; @(posedge Clock);
		$stop;
	end
	
endmodule
