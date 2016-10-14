
/* Lab 4 Input: Nico Cortes and Rochelle Roberts
Buttons and switches on board are inputs
The purpose of this module is to debounce: 
	- one press means one input
	- holding only causes one increment
	- checks for release before incrementing

btn_out: output, the debounced value of button in
*/
/*module single_Pulse(clk, bnt_U, bnt_L,btn_R, btn_D, sw_0, sw_1, btn_out);
input clk;
input [8:0] bnt_U, bnt_L,btn_R, btn_D, sw_0, sw_1;
output 


output 

endmodule 
*/
module debouncer(clk, btn_in, btn_out);
input clk;
input btn_in;
output reg btn_out;
reg [6:0] count; //used for masking the bouncing

always @(posedge clk) 
begin
count <= {count[5:0], btn_in};
if(&count) begin
btn_out <= 1; //btn was a high
end else if(~|count) begin
btn_out <= 0; // btn was low
end

end

endmodule 