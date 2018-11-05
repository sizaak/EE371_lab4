// Module that controls HEX display on FPGA
module seg7 (hex, leds);
 input logic [3:0] hex;
 output logic [0:6] leds;
 
 //logic [0:6] leds;

 always_comb begin
	 case (hex)
					  // Light: 6543210
		4'h0: leds = 7'b1000000; // 0
		4'h1: leds = 7'b1111001; // 1
		4'h2: leds = 7'b0100100; // 2
		4'h3: leds = 7'b0110000; // 3
		4'h4: leds = 7'b0011001; // 4
		4'h5: leds = 7'b0010010; // 5
		4'h6: leds = 7'b0000010; // 6
		4'h7: leds = 7'b1111000; // 7
		4'h8: leds = 7'b0000000; // 8
		4'h9: leds = 7'b0010000; // 9
		4'hA: leds = 7'b0001000; // A
		4'hB: leds = 7'b0000011; // b
		4'hC: leds = 7'b1000110; // C
		4'hD: leds = 7'b0100001; // d
		4'hE: leds = 7'b0000110; // E
		4'hF: leds = 7'b0001110; // F
		default:  leds = 7'b01111111; // -
	 endcase
 end
endmodule 
