/*  
  
  Testbench for the sevenSeg module
  Nico Cortes and Rochelle Roberts
  
  
  This module tests the 7-segment display driver for the Basys board.
  
  INPUTS
    fastclk - undivided clock signal
    
  OUTPUTS
    ao: anode signal out
    
    [6:0]s: cathode signals for each segment of the 7-segment display
    
    p: decimal point signal out
*/
module test_sevenSeg(fastclk, ao, s, p);
  input fastclk;
  
  wire clk;
  
  clk_div_sevenSeg cd(fastclk, clk);
  
  output ao, s, p;
  reg[6:0] s;

  sevenSeg ss0(1'b0, 1'h1, 1'b1, clk, ao, s, p); //should set digit zero to a 1
endmodule