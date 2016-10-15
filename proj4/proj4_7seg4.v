/*  
  
  4-digit 7-segment display driver
  Nico Cortes and Rochelle Roberts
  
  
  This module drives the 4-digit 7-segment display on the Basys board.
  
  INPUTS
    En: Enables the 7-segment display. Active low.
    
    
    [3:0]Ai: Which 7-segment displays will be enabled. Active LOW.
    
    [15:0]bcd: a binary-coded, 16-bit number that contains each
    digit of the 7-segment display.
    The bit layout is as follows: - 15:12 7seg 3 - 11:8 7seg 2 - 7:4 7seg 1 - 3:0 7seg 0 -
    
    clk: clock signal; its frequency sets the refresh rate for the 7-segment displays
    
  OUTPUTS
    [3:0]Ao: The enable bit for each 7-segment display. Active LOW.
  
    [6:0]Co: cathodes for a 7-segment displays. Active low.
    
    [3:0] Do: decimal point for each of the 4 7-segment displays. Active LOW.
    
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

module proj4_7seg4(En, bcd0, bcd1, bcd2, bcd3, clk, Ao, Co, Do);
  input En, bcd0, bcd1, bcd2, bcd3, clk;
  wire[3:0] bcd0, bcd1, bcd2, bcd3;
  reg[3:0] bcd;

  output Ao, Co, Do;
  wire[3:0] Ao;
  wire[6:0] Co;
  
  reg Aint;
  reg[6:0] Cint;
  
  wire[6:0] s;
  
  `define FIRST_DIG 1'he
  `define SECOND_DIG 1'hd
  `define THIRD_DIG 1'hb
  `define FOURTH_DIG 1'h7
  
  reg[1:0] ctr;
  
  initial begin
    ctr <= 2'b00;
    bcd <= bcd0;
  end
  
  //decimal points should all be disabled
  sevenSeg ss(bcd, 1'b1, s, Do);
  
  assign Ao = Aint;
  assign Co = Cint;
  always@(posedge clk) begin
    ctr <= ctr + 1;
    Cint <= s;
    if(En) begin 
      Aint <= 1'hf;
      bcd <= bcd0;
    end else begin
      case(ctr)
        2'b00: begin
          Aint <= `FIRST_DIG;
          bcd <= bcd0;
        end
        2'b01: begin
          Aint <= `SECOND_DIG;
          bcd <= bcd1;
        end
        2'b10: begin
          Aint <= `THIRD_DIG;
          bcd <= bcd2;
        end
        2'b10: begin
          Aint <= `FOURTH_DIG;
          bcd <= bcd3;
        end
      endcase  
    end
  end
endmodule
