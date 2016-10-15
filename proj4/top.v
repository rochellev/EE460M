/*  
  
  7-segment display controller
  Nico Cortes and Rochelle Roberts
  
  
  This controller sets the 7-segment display based on user input
  
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

module top(btnu, btnl, btnr, btnd, sw0, sw1, fastclk, Ao, s, Do);
  input btnu, btnl, btnr, btnd, sw0, sw1, fastclk;
  wire deb_btnu, deb_btnl, deb_btnr, deb_bntd;
 
  //en = 0 (always enabled)
  reg ld;
  //up = 0 (decrementer)
  reg[1:0] w;
  reg clrDec;
  wire clkDec;
  complexDivider(clk, 100000000, clkDec); //1-second period
  reg[15:0] d; 
  reg[15:0] q;
  reg Co; //not used
  
  wire en_7seg4;
  wire clk7Seg;
  complexDivider(clk, 1666666, clkDec); // ~ 1/60-second period
  output Ao, s, Do;
  wire[3:0] Ao;
  wire[6:0] s;
  reg[15:0] q7seg;
  
  initial begin
    q <= 1'h0;
  end
  
  wire clkDeb;
  complexDivider(fastclk, 5500000, clkDeb); //55ms period to avoid button noise
  single_pulse debu(clkDeb, btnu, 10, deb_btnu);
  single_pulse debl(clkDeb, btnl, 10, deb_btnl);
  single_pulse debr(clkDeb, btnr, 10, deb_btnr);
  single_pulse debd(clkDeb, btnd, 10, deb_btnd);
  
  `define FIVE {1'h0, 1'h0, 1'h0, 1'h5}
  `define TEN {1'h0, 1'h0, 1'h1, 1'h0}
  `define ONE_HUNDRED {1'h0, 1'h1, 1'h0, 1'h0}
  
  `define NINE999 {1'h9, 1'h9, 1'h9, 1'h9}
  
  initial begin 
    w <= 2'b00; //load value into decrementer
  end
  
  always@(*) begin
    ld <= 1'b0;
    if(q == `NINE999) begin
      q7seg <= `NINE999;
    end else if(q == 0) begin
      q7seg <= 0;
    end else begin
      if(deb_btnu) begin
        q7seg <= q + (`TEN << 1) + `TEN;
      end else if(deb_btnl) begin
        q7seg <= q + `ONE_HUNDRED | `TEN << 1;
      end else if(deb_btnr) begin
        d <= `ONE_HUNDRED | `TEN << 3;
      end else if(deb_btnd) begin
        q7seg <= q + ((`ONE_HUNDRED << 1) | `ONE_HUNDRED);
      end else if(sw0) begin
        q7seg <= `TEN | `FIVE;
      end else if(sw1) begin
        q7seg <= `ONE_HUNDRED | (`TEN << 3) | `FIVE;
      end else begin
        ld <= 1'b1;
      end
    end
  end
  
  //module bcd_ctr9999(en, ld, up, w, clr, clk, d, q, co);
  bcd_ctr9999 bc9999(1'b0, ld, 1'b0, clrDec, clkDec, q7seg, q, Co);
  
  //module proj4_7seg4(En, bcd0, bcd1, bcd2, bcd3, clk, Ao, Co, Do);
  proj4_7seg4 p47s4(en_7seg4, q7seg[3-:4], q7seg[7-:4], q7seg[11-:8], q7seg[15-:12], clk7Seg, Ao, Co, Do);
endmodule