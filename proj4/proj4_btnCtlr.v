/*  
  
  button control for project 4
  Nico Cortes and Rochelle Roberts
  
  This module adds time to a decrementing timer, up to 9999 seconds
  and down to 0 seconds
  
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

module proj4_btnCtlr(btnu, btnl, btnr, btnd, clk, 
                     pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd);
  input btnu, btnl, btnr, btnd, clk;
  
  output pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd;
  wire deb_btnu, deb_btnl, deb_btnr, deb_btnd;
  
  wire debClk;
  localparam[27:0] debClkPeriod = 5500;
  complexDivider debClkDiv(clk, debClkPeriod, debClk);
  debouncer debu(debClk, btnu, deb_btnu);
  debouncer debl(debClk, btnl, deb_btnl);
  debouncer debr(debClk, btnr, deb_btnr);
  debouncer debd(debClk, btnd, deb_btnd);
  
  wire s_pClk;
  localparam[27:0] s_pClkPeriod = 100000;
  complexDivider s_pClkDiv(clk, s_pClkPeriod, s_pClk);
  single_pulse s_pu(s_pClk, deb_btnu, pulse_btnu);
  single_pulse s_pl(s_pClk, deb_btnl, pulse_btnl);
  single_pulse s_pr(s_pClk, deb_btnr, pulse_btnr);
  single_pulse s_pd(s_pClk, deb_btnd, pulse_btnd);
endmodule
