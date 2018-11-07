module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR);

 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
 output logic [9:0] LEDR;
 input logic [3:0] KEY;
 input logic [9:0] SW;
 input logic CLOCK_50;
 
 logic load_A, rightshift_A, result_zero, incr_result, done, z, a0;
 logic [7:0] A;
 logic [3:0] result;
 logic s;
 
 D_FF d (.q(s), .d(SW[9]), .reset(reset_b), .clk(CLOCK_50));
 
 assign reset_b = ~KEY[0];
 assign LEDR[9] = done;
 assign A = SW[7:0];
 
 assign LEDR[8] = z;
 assign LEDR[7] = a0;
 assign LEDR[6] = incr_result;
 assign LEDR[5] = load_A;
 assign LEDR[4] = rightshift_A;
 assign LEDR[3] = result_zero;
 assign LEDR[2] = s;
 
 
 assign HEX5 = 7'b1111111;
 assign HEX4 = 7'b1111111;
 assign HEX3 = 7'b1111111;
 assign HEX2 = 7'b1111111;
 assign HEX1 = 7'b1111111;
 
 logic [31:0] clk;
 parameter whichClock = 25;

 logic clockchoose;
 clock_divider cdiv (.reset(reset), .clock(CLOCK_50), .divided_clocks(clk)); 
 
 assign clockchoose = CLOCK_50;
 //assign clockchoose = clk[whichClock];
 
 
 controller_RTL c_unit (.s, .clock(clockchoose), .reset_b, .load_A, .rightshift_A, 
							.result_zero, .incr_result, .done, .z, .a0); 
							
 Datapath_RTL d_unit (.data_A(A), .reset_b, .result, .clock(clockchoose), .load_A, 
						.rightshift_A, .result_zero, .incr_result, .z, .a0);  
						
 seg7 seg (.hex(result), .leds(HEX0));
 
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