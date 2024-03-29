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

module proj4_btnCtlr(btnu, btnl, btnr, btnd, sw0, sw1, clk, anodes, segs, decimalPt);
  input btnu, btnl, btnr, btnd, sw0, sw1, clk;
  
  output[3:0] anodes;
  output[6:0] segs;
  output decimalPt;
  
  wire pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd;
  wire deb_btnu, deb_btnl, deb_btnr, deb_btnd;
  
  wire en7Seg;
  wire[15:0] qDec;
  wire[3:0] q7Seg0;
  wire[3:0] q7Seg1;
  wire[3:0] q7Seg2;
  wire[3:0] q7Seg3;
  
  assign {q7Seg3, q7Seg2, q7Seg1, q7Seg0} = qDec;
  
  wire debClk;
  wire fastClk;
  //wire decCtrlClk;
  wire halfClk;
  wire slowClk;
    
  localparam[27:0] debClkPeriod = 5500000;
  complexDivider debClkDiv(clk, debClkPeriod, debClk);
  debouncer debu(debClk, btnu, deb_btnu);
  debouncer debl(debClk, btnl, deb_btnl);
  debouncer debr(debClk, btnr, deb_btnr);
  debouncer debd(debClk, btnd, deb_btnd);
  
//  wire s_pClk;
//  localparam[27:0] s_pClkPeriod = 100000;
//  complexDivider s_pClkDiv(clk, s_pClkPeriod, s_pClk); //~1/60-second period
  single_pulse s_pu(fastClk, deb_btnu, pulse_btnu);
  single_pulse s_pl(fastClk, deb_btnl, pulse_btnl);
  single_pulse s_pr(fastClk, deb_btnr, pulse_btnr);
  single_pulse s_pd(fastClk, deb_btnd, pulse_btnd);
  
  localparam[27:0] fastClkPeriod = 100000; //45000000 + 2500000
  //localparam[27:0] decCtrlClkPeriod = 1; //45000000 + 2500000
  localparam[27:0] halfClkPeriod = 45000000; //45000000 + 2500000
  localparam[27:0] slowClkPeriod = 1; //45000000 + 2500000
  
  complexDivider fastClkDiv(clk, fastClkPeriod, fastClk);
  //complexDivider decCtrlClkDiv(fastClk, fastClkPeriod, fastClk);
  complexDivider halfClkDiv(clk, halfClkPeriod, halfClk);
  complexDivider slowClkDiv(halfClk, slowClkPeriod, slowClk);
  
  proj4_counter p4c(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, 
                    sw0, sw1, fastClk, halfClk, slowClk, qDec, en7Seg);
  
  proj4_7seg4 p47s4(en7Seg, q7Seg0, q7Seg1, q7Seg2, q7Seg3,
                    clk, anodes, segs, decimalPt);
endmodule
