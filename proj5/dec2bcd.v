module dec2bcd(dec, bcd);
	input[15:0] dec;
	output[15:0] bcd;

	assign bcd[15-:4] = dec / 1000;
	assign bcd[11-:4] = (dec % 1000) / 100;
	assign bcd[7-:4] = (dec % 100) / 10;
	assign bcd[3-:4] = (dec % 10);
endmodule
