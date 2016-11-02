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

module proj4_7seg4(en7Seg, hex1, hex0, clk, anodes, segs, decimalPt);
  input en7Seg;
  input[3:0] hex1, hex0;
  input clk;
  
  output reg[3:0] anodes;
  output[6:0] segs;
  output  decimalPt;
  
  wire clk7Seg;
  reg anodeCtr;
  localparam[27:0] clk7SegPeriod = 166666;
  complexDivider clkDiv7Seg(clk, clk7SegPeriod, clk7Seg); //~1/60-second period
  reg[3:0] hexCur;
  
  `define proj4_7seg4_FIRST_DIG 4'he
  `define proj4_7seg4_SECOND_DIG 4'hd
  
  localparam di = 1'b1; //decimal points should all be disabled
  sevenSeg ss(hexCur, di, segs, decimalPt); 
  
  always@(posedge clk7Seg) begin    
    anodeCtr <= ~anodeCtr;
    if(!en7Seg) begin 
      anodes <= 4'hf;
      hexCur <= hex0;
    end else begin
      case(anodeCtr)
        0: begin
          anodes <= `proj4_7seg4_FIRST_DIG;
          hexCur <= hex0;
        end
        1: begin
          anodes <= `proj4_7seg4_SECOND_DIG;
          hexCur <= hex1;
        end
      endcase  
    end
  end
endmodule
