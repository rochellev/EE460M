
/* Button Input: Nico Cortes and Rochelle Roberts
Buttons and switches on board are inputs
The purpose of this module is to debounce.
btn_out: output, the debounced value of button in
 ----> clk has to be slow
*/

module debouncer(clk, btn_in, btn_out);
  input clk;
  input btn_in;
  output btn_out;
  wire btn_outi; //intermediate btn out

  //module d_ff(clk, d, q);
  d_ff d1(clk, btn_in, btn_outi);
  d_ff d2(clk, btn_outi, btn_out); 
endmodule 

/* 
d flip flop to be used for debouncing the buttons 
d = data in, from button
q = output  (no reset)
*/
module d_ff(clk, d, q);
  input clk, d;
  output reg q;

  always @(posedge clk) begin
    q <= d;
  end
endmodule


/*
uses debouncer to make sure one press == one change
btn_in= input from board
btn_sync = result from debounced input, intermediate output
pulse = single result from pressing a button
delay = pulse delay, 
*/
module single_pulse(clk, btn_in, pulse);
  input clk;
  input btn_in;

  output pulse;
  wire s;
  
  d_ff dff1(clk, btn_in, s); 
  assign pulse = btn_in & (~s);
endmodule