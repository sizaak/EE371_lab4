module DE1_SoC(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	always_comb begin
		if (SW[0]) HEX0 = 7'b1111001;
		else HEX0 = 7'b1000000;
	end
endmodule
