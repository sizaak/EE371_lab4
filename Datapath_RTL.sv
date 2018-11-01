module Datapath_RTL (Data_A, Reset, Clock, Load_A, Update_L, Update_R, Found_True, Init_Bound, A, Ram_Data, L_Bound, R_Bound, Found, L); 
	
	input logic Reset, Clock;
	input logic Load_A, Update_L, Update_R, Found_True, Init_Bound;
	input logic [7:0] Data_A;
	output logic [7:0] A, Ram_Data;
	output logic [4:0] L_Bound, R_Bound, L;
	output logic Found;
	
	logic [4:0] L_reg;
	logic [7:0] Ram_Data_reg;
	
	// ram module size of 32 words 8 bit wide
	ram32x8 r1 (.address(L_reg), .clock(Clock), .data(Data_A), .wren(1'b0), .q(Ram_Data_reg));
	
	always_ff @(posedge Clock) begin
		if(Reset || Init_bound) begin
			L_Bound <= 0;
			R_Bound <= 2'h1F; // 31
			Found <= 0;
		end
		if(Load_A) A <= Data_A;
		if(Update_L) L_Bound = L_reg + 5'b00001;
		else if(Updata_R) R_Bound = L_reg - 5'b00001;
		
		L_reg <= (L_Bound + R_Bound) / 2;
	end
	
	
	assign Ram_Data = Ram_Data_reg;
	assign L = L_reg;
	assign Found = Found_True;

endmodule

/*
module tb_Datapath_RTL();
	logic [7:0] data_A;
	logic clock, reset_b, load_A, rightshift_A, result_zero, incr_result;
	logic [3:0] result;
	logic z, a0;
	
	parameter CLOCK_PERIOD = 100;
	
	Datapath_RTL dut (.data_A, .reset_b, .result, .clock, .load_A, .rightshift_A, .result_zero, .incr_result, .z, .a0);  

	initial begin
		clock <= 0;
		forever#(CLOCK_PERIOD/2) clock = ~clock;
	end


	initial begin
	
		$stop;
	end
endmodule
*/