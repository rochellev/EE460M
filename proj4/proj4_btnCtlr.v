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
  
  reg pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, pulse_sw0, pulse_sw1;
  wire deb_btnu, deb_btnl, deb_btnr, deb_btnd;
  
  wire en7Seg;
  wire[15:0] qDec;
  wire[3:0] q7Seg0;
  wire[3:0] q7Seg1;
  wire[3:0] q7Seg2;
  wire[3:0] q7Seg3;
  
  assign {q7Seg3, q7Seg2, q7Seg1, q7Seg0} = qDec;
  
  wire debClk;
  localparam[27:0] debClkPeriod = 5500;
  complexDivider debClkDiv(clk, debClkPeriod, debClk);
  debouncer debu(debClk, btnu, deb_btnu);
  debouncer debl(debClk, btnl, deb_btnl);
  debouncer debr(debClk, btnr, deb_btnr);
  debouncer debd(debClk, btnd, deb_btnd);
  
  always@(posedge clk) begin 
    if(sw0) begin 
      pulse_sw0 <= 1;
    end else if(sw1) begin 
      pulse_sw1 <= 1;
    end else begin
      if(deb_btnu) begin 
        pulse_btnu <= 1;
      end else if(deb_btnl) begin 
        pulse_btnl <= 1;
      end else if(deb_btnr) begin 
        pulse_btnr <= 1;
      end else if(deb_btnd) begin 
        pulse_btnd <= 1;
      end else begin end
    end
  end
  
  wire s_pClk;
  wire s_pSlowClk;
  localparam[27:0] s_pClkPeriod = 47500; //45000000 + 2500000
  localparam[27:0] s_pSlowClkPeriod = 1; //45000000 + 2500000
  complexDivider s_pClkDiv(clk, s_pClkPeriod, s_pClk);
  complexDivider s_pSlowClkDiv(s_pClk, s_pSlowClkPeriod, s_pSlowClk);
  
  always@(posedge s_pSlowClk) begin 
    pulse_sw0 <= sw0;
    pulse_sw1 <= sw1;
    pulse_btnu <= 0;
    pulse_btnl <= 0;
    pulse_btnr <= 0;
    pulse_btnd <= 0;
  end
  
  proj4_counter p4c(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, 
                    pulse_sw0, pulse_sw1, s_pClk, s_pSlowClk, qDec, en7Seg);
  
  proj4_7seg4 p47s4(en7Seg, q7Seg0, q7Seg1, q7Seg2, q7Seg3,
                    clk, anodes, segs, decimalPt);
endmodule
