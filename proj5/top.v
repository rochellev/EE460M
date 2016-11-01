module top(PS2Clk, clk100Mhz, sw, PS2Data, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync, segs, anodes, decimalPt, strobe);
  input PS2Clk, clk100Mhz;
  input[7:0] sw;
  input PS2Data;
  
  output[3:0] vgaRed, vgaGreen, vgaBlue;
  output Hsync, Vsync;
  output[6:0] segs;
  output[3:0] anodes;
  output decimalPt; 
  output strobe;
  
  wire[3:0] key_code1, key_code0;
  wire en7Seg;
  
  `define TOP_CLKDIV100_TO_25MHZ_DELAY 2
  wire clk25Mhz;
  
  complexDivider clkDiv100to25Mhz(clk100Mhz, `TOP_CLKDIV100_TO_25MHZ_DELAY, clk25Mhz);
  
  vga_ctlr top_vga_ctlr(clk25Mhz, sw, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);
  //module ps2(clk100Mhz, PS2Clk, PS2Data, key_code1, key_code0, key_code_en, strobe);
  ps2 keyb(clk100Mhz, PS2Clk, PS2Data, key_code1, key_code0, en7Seg, strobe);
  //module proj4_7seg4(en7Seg, bcd0, bcd1, bcd2, bcd3, clk, anodes, segs, decimalPt);
  proj4_7seg4 keyCodeOut(en7Seg, key_code1, key_code0, clk100Mhz, anodes, segs, decimalPt);
  
  
endmodule