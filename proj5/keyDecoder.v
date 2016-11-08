/*
Nico and Rochelle

This module decodes the user input from ps2 module that ouputs the key code
The output indicates the movement the snake will do: 
8 single bit registers
s, p, r, esc, rt, lf, up, dn,

*/


module keyDecoder(clk100Mhz, key_code1, key_code0, strobe, s, p, r, esc, up, dn, lf, rt, plus, minus);
  input clk100Mhz;
  input [3:0] key_code1, key_code0;
  input strobe;
  
  output reg s, p, r, esc, up, dn, lf, rt, plus, minus; 
  
  wire[7:0]code; 
  reg[7:0] prevCode = 0;

  `define S 8'h1B
  `define P 8'h4D
  `define R 8'h2D
  `define ESC 8'h76
  `define Rt 8'h74
  `define Lf 8'h6B
  `define Up 8'h75
  `define Dn 8'h72
  `define PLUS 8'h55
  `define MINUS 8'h4e

  `define KEY_DECODER_CLKDIV100MHZ_TO_10KHZ_DELAY 5000
  `define KEY_DECODER_KEY_PULSE_DELAY 249
  
  wire clk10Khz;
  
  complexDivider keyDecoderDiv(clk100Mhz, `KEY_DECODER_CLKDIV100MHZ_TO_10KHZ_DELAY, clk10Khz);

  assign code = {key_code1, key_code0}; 
  
  reg decoderState = 0;
  
  reg[7:0] pulseCtr = 0;
  always @(posedge clk10Khz) begin 
    case(decoderState)
        0: begin
            if(strobe) begin 
                pulseCtr <= 0;
                decoderState <= 1;
                prevCode <= code;
            end
        end
        
        1: begin
          pulseCtr <= pulseCtr + 1;
          if(pulseCtr == 0) begin
              if(prevCode == `S )begin
                s <= 1;
              end else if(prevCode == `P )begin
                p <= 1;
              end else if(prevCode == `R )begin
                r <= 1;
              end else if(prevCode == `ESC )begin
                esc <= 1;
              end else if(prevCode == `Up )begin
                up <= 1;
              end else if(prevCode == `Dn )begin
                dn <= 1;
              end else if(prevCode == `Lf )begin
                lf <= 1;
              end else if(prevCode == `Rt )begin
                rt <= 1;
              end else if(prevCode == `PLUS) begin 
                plus <= 1;
              end else if(prevCode == `MINUS) begin 
                minus <= 1;
              end
          end else if(pulseCtr == `KEY_DECODER_KEY_PULSE_DELAY) begin 
            // defaults, so don't have to assign in each if statement
            s <= 0;   p <= 0; r <= 0;   esc <= 0;
            rt <= 0;  lf <=0;  up <= 0;  dn <= 0; plus <= 0; minus <= 0;
            decoderState <= 0;
          end 
        end
    endcase
  end
endmodule 
