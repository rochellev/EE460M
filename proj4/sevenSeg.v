/*  
  
  7-segment display driver
  Nico Cortes and Rochelle Roberts
  
  
  This module drives a 7-segment display on the Basys board.
  
  INPUTS
    Ai: Enables the 7-segment display. Active LOW.
    
    [3:0]n: an unsigned number from 0 to 9
    If the value is >9, the value will be set to 9
    
    Di: decimal point. Active low.
    
    clk: clock signal - refreshes the anode and cathode values at the clk frequency
    if freq(clk) > 45 then the 7-segment display should illuminate continuously
    else the 7-segment display will noticeably pulse on and off.
    
  OUTPUTS
    Ao: The enable bit for each 7-segment display. Active LOW.
  
    [6:0]s: will set the corresponding segments
    on the 7-segment display. These signals are active LOW.
    In the actual hardware, segments are assigned [A:G]
    
    Do: decimal point. Active low.
    
   - Anode layout for each 7-segment display
    - A -
   |     |
   F     B
   |     |
    - G -
   |     | 
   E     C
   |     |
    - D -   - Do
  
*/

module sevenSeg(n, Di, s, Do);
  input n, Di;
  wire[3:0] n;
  
  output s, Do;
  wire[6:0] s;
  
  `define ss_ZERO 7'b0000001
  `define ss_ONE 7'b1001111
  `define ss_TWO 7'b0010010
  `define ss_THREE 7'b0000110
  `define ss_FOUR 7'b1001100
  `define ss_FIVE 7'b0100100
  `define ss_SIX 7'b0100000
  `define ss_SEVEN 7'b0001111
  `define ss_EIGHT 7'b0000000
  `define ss_NINE 7'b0000100
  
  reg[6:0] digits[0:9];
  
  initial begin
    digits[0] = `ss_ZERO;
    digits[1] = `ss_ONE;
    digits[2] = `ss_TWO;
    digits[3] = `ss_THREE;
    digits[4] = `ss_FOUR;
    digits[5] = `ss_FIVE;
    digits[6] = `ss_SIX;
    digits[7] = `ss_SEVEN;
    digits[8] = `ss_EIGHT;
    digits[9] = `ss_NINE;
  end
  
  assign {s, Do} = {digits[n > 1'h9 ? 1'h9: n], Di};
endmodule
