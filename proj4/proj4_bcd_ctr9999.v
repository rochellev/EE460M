/*  
  
  9999 decade counter
  Nico Cortes and Rochelle Roberts
  
  
  This module outputs a number between 0 - 9999,
  incrementing (or decrementing) its current value on the positive clock edge
  
  INPUTS
    en: active high. Enables the counter to be loaded with a new value.
    
    ld: active high. Loads d into the counter
    
    up: 1 will increment the counter every clock cycle.
    0 will decrement the counter ever clock cycle.
    
    clr: asynchronous clear. Sets the counter to 0000 and co to 0.
    
    clk: clock input signal
    
    [15:0]d: a 16-bit, bcd unsigned number that can be loaded into the counter.
    if any 4-bit digit in the number >9, it will be reduced to 9.
    
  OUTPUTS
  
    [15:0]q: will set the corresponding segments
    on the 7-segment display. These signals are active LOW.
    In the actual hardware, segments are assigned [A:G]
    
    co: carry out will be a 1 if:
      the counter is 9999 and up==1
      the counter is 0000 and up==0,
      0 otherwise.
*/

module bcd_ctr9999(en, ld, up, clr, clk, d, q, co);
  input en, ld, up, clr, clk, d;
  wire[15:0] d;
  
  output q, co;
  wire[15:0] q;
  
  wire cols99;
  wire coms99;
  wire enms99;
  wire clrInternal;
  
  assign enms99 = (en & (ld | cols99));
  assign clrInternal = ((q == 0) && ~(ld || up))? 1'b0: clr;
  
  //module bcd_ctr99(En, Ld, Up, Clr, Clk, D1, D2, Q1, Q2, Co);
  bcd_ctr99 ls99(en, ld, up, clrInternal, clk, d[3-:4], d[7-:4], 
                 q[3-:4], q[7-:4], cols99);
  bcd_ctr99 ms99(enms99, ld, up, clrInternal, clk, d[11-:4], d[15-:4],
                 q[11-:4], q[15-:4], coms99);
                 
  assign co = cols99 & coms99;
endmodule