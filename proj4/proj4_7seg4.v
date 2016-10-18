/*  
  
  4-digit 7-segment display driver
  Nico Cortes and Rochelle Roberts
  
  
  This module drives the 4-digit 7-segment display on the Basys board.
  
  INPUTS
    en: Enables the 7-segment display. Active high.
    
    [all 3:0]bcd0, bcd1, bcd2, bcd3: binary coded decimal digits to be displayed
    
    clk: clock signal; its frequency sets the refresh rate for the 4 7-segment displays
    
  OUTPUTS
    [3:0]anodes: The enable bit for each 7-segment display. Active low.
  
    [6:0]segs: cathodes for a 7-segment displays. Active low.
    
    [3:0] decimalPt: decimal point for each of the 4 7-segment displays. Active low.
    
   - Anode layout for each 7-segment display
    - A -
   |     |
   F     B
   |     |
    - G -
   |     | 
   E     C
   |     |
    - D -   - P
  
*/

module proj4_7seg4(bcd0, bcd1, bcd2, bcd3, clk, anodes, segs, decimalPt);
  input[3:0] bcd0, bcd1, bcd2, bcd3;
  input clk;

  wire[15:0] bcd3210;
  assign bcd3210 = {bcd3, bcd2, bcd1, bcd0};
  
  
  output reg[3:0] anodes;
  output[6:0] segs;
  output  decimalPt;
  
  reg en7Seg;
  wire clk7Seg;
  localparam[27:0] clk7SegPeriod = 166666;
  complexDivider clkDiv7Seg(clk, clk7SegPeriod, clk7Seg); //~1/60-second period
  
  
  wire clkBlink;
  wire clkSlowBlink;
  localparam[27:0] clkBlinkPeriod = 50000000;
  complexDivider clkDivBlink(clk, clkBlinkPeriod, clkBlink); //~1/60-second period
  
  reg[1:0] blinkCtr;
  reg[1:0] anodeCtr;
  reg[3:0] bcdCur;
  
  assign clkSlowBlink = blinkCtr[1];
  
  `define proj4_7seg4_FIRST_DIG 4'he
  `define proj4_7seg4_SECOND_DIG 4'hd
  `define proj4_7seg4_THIRD_DIG 4'hb
  `define proj4_7seg4_FOURTH_DIG 4'h7
  
  initial begin
    en7Seg <= 1'b1;
    blinkCtr <= 2'b00;
    anodeCtr <= 2'b00;
  end
  
  localparam di = 1'b1; //decimal points should all be disabled
  sevenSeg ss(bcdCur, di, segs, decimalPt); 
  
  always@(posedge clkBlink) begin
    blinkCtr <= blinkCtr + 1;
    if(clkSlowBlink) begin 
      if(bcd0 % 2) begin
        en7Seg <= 1;
      end else begin 
        en7Seg <= 0;
      end
    end else if(bcd3210 == 0) begin 
      en7Seg <= en7Seg ^ 1;
    end else begin 
      en7Seg <= 1;
    end
  end
  
  always@(posedge clk7Seg) begin
    anodeCtr <= anodeCtr + 2'b01;
    if(!en7Seg) begin 
      anodes <= 4'hf;
      bcdCur <= bcd0;
    end else begin
      case(anodeCtr)
        2'b00: begin
          anodes <= `proj4_7seg4_FIRST_DIG;
          bcdCur <= bcd0;
        end
        2'b01: begin
          anodes <= `proj4_7seg4_SECOND_DIG;
          bcdCur <= bcd1;
        end
        2'b10: begin
          anodes <= `proj4_7seg4_THIRD_DIG;
          bcdCur <= bcd2;
        end
        2'b11: begin
          anodes <= `proj4_7seg4_FOURTH_DIG;
          bcdCur <= bcd3;
        end
      endcase  
    end
  end
endmodule
