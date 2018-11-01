module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR);

 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
 output logic [9:0] LEDR;
 input logic [3:0] KEY;
 input logic [9:0] SW;
 input logic CLOCK_50;
 
 logic Load_A, Update_L, Update_R, Found_True, Init_Bound, Found, Done, Start;
 logic [7:0] A, A_reg, Ram_Data;
 logic [4:0] L, L_Bound, R_Bound;
 
 D_FF d (.q(Start), .d(SW[9]), .reset(Reset), .clk(CLOCK_50));
 
 assign Reset = ~KEY[0];
 assign LEDR[9] = Found;
 assign A = SW[7:0];
 
 
 assign HEX5 = 7'b1111111;
 assign HEX4 = 7'b1111111;
 assign HEX3 = 7'b1111111;
 assign HEX2 = 7'b1111111;
 assign HEX1 = 7'b1111111;
 
 controller_RTL c_unit (.Start, .Clock(Clock_50), .Reset, .A(A_reg), .Ram_Data, .L_Bound, .R_Bound, .Load_A, .Update_L, 
								.Update_R, .Found_True, .Init_Bound, .Done); 
							
 Datapath_RTL d_unit (.Data_A(A), .Reset, .Clock(Clock_50), .Load_A, .Update_L, .Update_R, .Found_True, .Init_Bound, 
								.A(A_reg), .Ram_Data, .L_Bound, .R_Bound, .Found, .L); 
						
 seg7 seg1 (.hex({3'b0, L[4]}), .leds(HEX1));
 seg7 seg2 (.hex(L[3:0]), .leds(HEX0));
 
endmodule


module clock_divider (reset, clock, divided_clocks); 
  input logic clock, reset; 
  output logic [31:0] divided_clocks;

  always_ff @(posedge clock) begin 
    if(reset) begin
      divided_clocks <= 0;
    end else begin
      divided_clocks <= divided_clocks + 1;
    end
  end 
endmodule


module tb_DE1_SoC();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
   logic [9:0] SW;
	logic CLOCK_50;
	
	
	parameter CLOCK_PERIOD = 100;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR); 
	
	initial begin
		CLOCK_50 <= 0;
		forever#(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50;
	end


	initial begin
		KEY[0] <= 0; SW[9] <= 0;@(posedge CLOCK_50);@(posedge CLOCK_50);
		KEY[0] <= 1; SW[7:0] <= 8'b00000000;@(posedge CLOCK_50);@(posedge CLOCK_50);
		SW[9] <= 1; 
		for(int i = 0; i < 9; i++) @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
		SW[7:0] <= 8'b11111111;@(posedge CLOCK_50);@(posedge CLOCK_50);
		SW[9] <= 1; 
		for(int i = 0; i < 9; i++) @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
		SW[7:0] <= 8'b10101010;@(posedge CLOCK_50);@(posedge CLOCK_50);
		SW[9] <= 1; 
		for(int i = 0; i < 9; i++) @(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);@(posedge CLOCK_50);
		$stop;
	end
endmodule