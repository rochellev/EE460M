module top(clk100Mhz, sw, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);
  input clk100Mhz;
  input[7:0] sw;
  
  output[3:0] vgaRed, vgaGreen, vgaBlue;
  output Hsync, Vsync;
  
  `define TOP_CLKDIV100_TO_25MHZ_DELAY 2
  wire clk25Mhz;
  
  complexDivider clkDiv100to25Mhz(clk100Mhz, `TOP_CLKDIV100_TO_25MHZ_DELAY, clk25Mhz);
  
  vga_ctlr top_vga_ctlr(clk25Mhz, sw, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);
endmodule