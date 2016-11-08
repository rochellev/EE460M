
/* Lab 4 Input: Nico Cortes and Rochelle Roberts
Buttons and switches on board are inputs
The purpose of this module is to debounce.
btn_out: output, the debounced value of button in
 ----> clk has to be slow
*/

module bcd2dec(bcd, dec);
	input[15:0] bcd;
	output[15:0] dec;

	assign dec = bcd[15-:4] * 1000 + bcd[11-:4] * 100 + bcd[7-:4] * 10 + bcd[3-:4];
endmodule
