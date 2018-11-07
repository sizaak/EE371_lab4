module Datapath_RTL (data_A, reset_b, result, clock, load_A, rightshift_A, result_zero, incr_result, z, a0); 
	
	input logic [7:0] data_A;
	input logic clock, reset_b, load_A, rightshift_A, result_zero, incr_result;
	output logic [3:0] result;
	output logic z, a0;
	
	logic [7:0] A_reg;
	logic [3:0] B_reg;
	
	always_ff @(posedge clock) begin
		if(reset_b || result_zero)
			B_reg <= 0;
		else if(incr_result)
			B_reg <= B_reg + 4'b0001;
			
		if(reset_b || load_A) A_reg <= data_A;
		else if(rightshift_A) A_reg <= (A_reg >> 1);
	end
	
	assign result = B_reg;
	assign z = (A_reg == 0);
	assign a0 = A_reg[0];

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