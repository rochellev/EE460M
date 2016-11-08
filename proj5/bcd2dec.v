module bcd2dec(bcd, dec);
	input[15:0] bcd;
	output[15:0] dec;

	assign dec = bcd[15-:4] * 1000 + bcd[11-:4] * 100 + bcd[7-:4] * 10 + bcd[3-:4];
endmodule
