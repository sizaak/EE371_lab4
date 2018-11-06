`timescale 1 ps / 1 ps
module Datapath_RTL (Data_A, Resetn, Clock, Load_A, Update_L, Update_R, Found_True, Init_Bound, 
							A, Ram_Data, L_Bound, R_Bound, Found, L); 
	
	input logic Resetn, Clock;
	input logic Load_A, Update_L, Update_R, Found_True, Init_Bound;
	input logic [7:0] Data_A;
	output logic [7:0] A, Ram_Data;
	output logic [4:0] L_Bound, R_Bound, L;
	output logic Found;
	
	logic [4:0] L_reg;
	logic [7:0] Ram_Data_reg;
	logic [5:0] L_sum;
	
	// ram module size of 32 words 8 bit wide
	ram32x8 r1 (.address(L_reg), .clock(Clock), .data(0), .wren(1'b0), .q(Ram_Data_reg));
	
	always_ff @(posedge Clock) begin
		if(Resetn || Init_Bound) begin
			L_Bound <= 0;
			R_Bound <= 5'd31; // 31
			Found <= 0;
		end
		if (Found_True) Found <= 1;
		if(Load_A) A <= Data_A;
		if(Update_L) L_Bound <= L_reg + 5'b00001;
		else if(Update_R) R_Bound <= L_reg - 5'b00001;
	end
	
	always_comb begin
		L_sum = L_Bound + R_Bound;
		L_reg = L_sum / 2;
	end
	
	//assign L = {L_Bound[4], L_B[15:1]};
	assign Ram_Data = Ram_Data_reg;
	assign L = L_reg;

endmodule

`timescale 1 ps / 1 ps
module tb_Datapath_RTL();
	logic Resetn, Clock;
	logic Load_A, Update_L, Update_R, Found_True, Init_Bound;
	logic [7:0] Data_A;
	logic [7:0] A, Ram_Data;
	logic [4:0] L_Bound, R_Bound, L;
	logic Found;
	
	parameter CLOCK_PERIOD = 100;
	
	Datapath_RTL dut (.Data_A, .Resetn, .Clock, .Load_A, .Update_L, .Update_R, .Found_True, .Init_Bound, 
							.A, .Ram_Data, .L_Bound, .R_Bound, .Found, .L); 

	initial begin
		Clock <= 0;
		forever#(CLOCK_PERIOD/2) Clock = ~Clock;
	end

	initial begin
		Resetn <= 1; Load_A <= 0; Update_L <= 0; Update_R <= 0; 
		Found_True <= 0; Init_Bound <= 0; Data_A <= 8'b00110000;@(posedge Clock);
		Resetn <= 0; Init_Bound <= 1;@(posedge Clock);
		Load_A <= 1; Init_Bound <= 0;@(posedge Clock);
		Load_A <= 0; @(posedge Clock);
		Update_L <= 1; Update_R <= 0; @(posedge Clock);
		Update_L <= 1; Update_R <= 0; @(posedge Clock);
		Update_L <= 1; Update_R <= 0; @(posedge Clock);
		Update_L <= 1; Update_R <= 0; @(posedge Clock);
		Update_L <= 1; Update_R <= 0; @(posedge Clock);
		Update_L <= 0; Update_R <= 0; Found_True <= 1;@(posedge Clock);
		Init_Bound <= 1; Found_True <= 0; @(posedge Clock);
		Init_Bound <= 0;
		Update_L <= 0; Update_R <= 1; @(posedge Clock);
		Update_L <= 0; Update_R <= 1; @(posedge Clock);
		Update_L <= 0; Update_R <= 1; @(posedge Clock);
		Update_L <= 0; Update_R <= 1; @(posedge Clock);
		Update_L <= 0; Update_R <= 1; @(posedge Clock);
		Update_L <= 0; Update_R <= 0; Found_True <= 1;@(posedge Clock);
		Init_Bound <= 1; Found_True <= 0; @(posedge Clock);
		$stop;
	end
endmodule
