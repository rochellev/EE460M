/*  
  
  top module for project 4
  Nico Cortes and Rochelle Roberts
  
  
  this module processes button presses and simulates adding time to a decrementing timer
  
  INPUTS
    btnu, btnl, btnr, btnd: button inputs from the Basys 3 board.
    These signals are not debounced, so they will be fed into a debouncer circuit.
    
    sw0, sw1: switch 0 resets the time to 15. Active high.
    switch 1 resets the time to 185 seconds. Active high.
    
    [3:0]n: an unsigned number from 0 to 9
    If the value is >9, the value will be set to 9
    
    fastclk: 100Mhz clock signal
    
  OUTPUTS
    [3:0]Ao: The enable bit for each 7-segment display. Active LOW.
  
    [6:0]s: will set the corresponding segments
    on the 7-segment display. These signals are active LOW.
    In the actual hardware, segments are assigned [A:G]
    
    Do: decimal point. Active low.
*/

module top(btnu, btnl, btnr, btnd, sw0, sw1, fastclk, anodes, segs, decimalPt);
  input btnu, btnl, btnr, btnd, sw0, sw1, fastclk;
  wire pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd;
 
  output[3:0] anodes;
  output[6:0] segs;
  output decimalPt;
 
  //module proj4_btnCtlr(btnu, btnl, btnr, btnd, sw0, sw1, clk, bcdIn, bcdOut, ld);
  proj4_btnCtlr p4bc(btnu, btnl, btnr, btnd, fastclk, anodes, segs, decimalPt);
endmodule
