/*
Nico and Rochelle

This module decodes the user input from ps2 module that ouputs the key code
The output indicates the movement the snake will do: 
8 single bit registers
s, p, r, esc, rt, lf, up, dn,

*/


module keyDecoder(clk, key_code1, key_code0, s, p, r, esc, rt, lf, up, dn);
input clk;
input [3:0] key_code1, key_code0;
output reg  s, p, r, esc, rt, lf, up, dn; 
reg[7:0]code=0; 

`define S 8'h1B
`define P 8'h4D
`define R 8'h2D
`define ESC 8'h76
`define Rt 8'h74
`define Lf 8'h6B
`define Up 8'h75
`define Dn 8'h72


always @(posedge clk)begin 
// defaults, so don't have to assign in each if statement
s <= 0;   p <= 0; r <= 0;   esc <= 0;
rt <= 0;  lf <=0;  up <= 0;  dn <= 0;
code = {key_code1, key_code0}; 
if(code == `S )begin
	s <= 1;
	rt <= 1;
end else if(code == `P )begin
	p <= 1;
end else if(code == `R )begin
	r <= 1;
end else if(code == `ESC )begin
	esc <= 1;
end else if(code == `Lf )begin
	lf <= 1;
end else if(code == `Up )begin
	up <= 1;
end else if(code == `Dn )begin
	dn <= 1;
end else begin //a key not supported was hit, do nothing
	s <= 0;   p <= 0; r <= 0;   esc <= 0;
	rt <= 0;  lf <=0;  up <= 0;  dn <= 0;
     end 
  end

endmodule 
