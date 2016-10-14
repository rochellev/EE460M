/*  
  
  4-digit 7-segment display driver
  Nico Cortes and Rochelle Roberts
  
  
  This module drives the 4-digit 7-segment display on the Basys board.
  
  INPUTS
    
    [3:0]Ai: Which 7-segment displays will be enabled. Active LOW.
    
    [15:0]bcd: a binary-coded, 16-bit number that contains each
    digit of the 7-segment display.
    The bit layout is as follows: - 15:12 7seg 3 - 11:8 7seg 2 - 7:4 7seg 1 - 3:0 7seg 0 -
    
    clk: clock signal; its frequency sets the refresh rate for the 7-segment displays
  OUTPUTS
    [3:0]Ao: The enable bit for each 7-segment display. Active LOW.
  
    [all 3:0]ca, cb, cc, cd, ce, cf, cg, : cathodes for 4 7-segment displays
    
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

module proj4_7seg4(En, bcd0, bcd1, bcd2, bcd3, clk, Ao, ca, cb, cc, cd, ce, cf, cg, Do);
  input En, bcd0, bcd1, bcd2, bcd3, clk;
  wire[3:0] bcd0, bcd1, bcd2, bcd3;

  output ca, cb, cc, cd, ce, cf, cg, Do;
  
  wire[6:0] s[0:3];

  reg ai;
  
  `define FIRST_DIG 1'he
  `define SECOND_DIG 1'hd
  `define THIRD_DIG 1'hb
  `define FOURTH_DIG 1'h7
  
  reg[3:0] dig[0:3];
  reg[1:0] ctr;
  
  initial begin
    dig[0] <= `FIRST_DIG;
    dig[1] <= `SECOND_DIG;
    dig[2] <= `THIRD_DIG;
    dig[3] <= `FOURTH_DIG;
    
    ctr <= 2'b00;
  end
  
  //decimal points should all be disabled
  sevenSeg ss0(Ai[0], bcd0, 1'b1, Ao[0], s[0], Do[0]);
  sevenSeg ss1(Ai[1], bcd1, 1'b1, Ao[1], s[1], Do[1]);
  sevenSeg ss2(Ai[2], bcd2, 1'b1, Ao[2], s[2], Do[2]);
  sevenSeg ss3(Ai[3], bcd3, 1'b1, Ao[3], s[3], Do[3]);

  always@(posedge clk) begin
    ctr <= ctr + 1;
    Ao <= dig[ctr] & En;
    {ca, cb, cc, cd, ce, cf, cg} <= s[ctr];
  end
endmodule
