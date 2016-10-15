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
  wire deb_btnu, deb_btnl, deb_btnr, deb_btnd;
 
  //en = 0 (always enabled)
  reg ld;
  //up = 0 (decrementer)
  //w = 0 (always loading data)
  //clr = 1 (never clear)
  wire clkDec;
  complexDivider cdDec(fastclk, 100000000, clkDec); //1-second period
  wire[15:0] q;
  wire Co; //not used
  
  reg en7Seg;
  wire clk7Seg;
  complexDivider cd7Seg(fastclk, 1666666, clk7Seg); // ~ 1/60-second period
  output Ao, s, Do;
  wire[3:0] Ao;
  wire[6:0] s;
  reg[15:0] q7Seg;
  
  initial begin 
    en7Seg <= 1'b0; //NEED TO CHANGE
    ld <= 1'b1;
  end
  
  wire clkDeb;
  complexDivider cdDeb(fastclk, 5500000, clkDeb); //55ms period to avoid button noise
  single_pulse debu(clkDeb, btnu, 10, deb_btnu);
  single_pulse debl(clkDeb, btnl, 10, deb_btnl);
  single_pulse debr(clkDeb, btnr, 10, deb_btnr);
  single_pulse debd(clkDeb, btnd, 10, deb_btnd);
  
  `define top_FIVE {1'h0, 1'h0, 1'h0, 1'h5}
  `define top_TEN {1'h0, 1'h0, 1'h1, 1'h0}
  `define top_ONE_HUNDRED {1'h0, 1'h1, 1'h0, 1'h0}
  
  `define top_NINE999 {1'h9, 1'h9, 1'h9, 1'h9}
  
  always@(*) begin
    ld <= 1'b0;
    if(q == `top_NINE999) begin
      q7Seg <= `top_NINE999;
    end else if(q == 0) begin
      q7Seg <= 0;
    end else begin
      if(deb_btnu) begin
        q7Seg <= q + (`top_TEN << 1) + `top_TEN;
      end else if(deb_btnl) begin
        q7Seg <= q + `top_ONE_HUNDRED | `top_TEN << 1;
      end else if(deb_btnr) begin
        q7Seg <= q + `top_ONE_HUNDRED | `top_TEN << 3;
      end else if(deb_btnd) begin
        q7Seg <= q + ((`top_ONE_HUNDRED << 1) | `top_ONE_HUNDRED);
      end else if(sw0) begin
        q7Seg <= `top_TEN | `top_FIVE;
      end else if(sw1) begin
        q7Seg <= `top_ONE_HUNDRED | (`top_TEN << 3) | `top_FIVE;
      end else begin
        ld <= 1'b1;
        q7Seg <= q;
      end
    end
  end
  
  //module bcd_ctr9999(en, ld, up, w, clr, clk, d, q, co);
  bcd_ctr9999 bc9999(1'b0, ld, 1'b0, 1'b1, clkDec, q7Seg, q, Co);
  
  //module proj4_7seg4(En, bcd0, bcd1, bcd2, bcd3, clk, Ao, Co, Do);
  proj4_7seg4 p47s4(en7Seg, q7Seg[3-:4], q7Seg[7-:4], q7Seg[11-:4], q7Seg[15-:4],
                    clk7Seg, Ao[3-:4], s[6-:7], Do);
endmodule