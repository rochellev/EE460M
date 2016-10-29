# module top(clk100Mhz, sw, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);

restart

force clk100Mhz 0 0 ns, 1 5 ns -repeat 10 ns 

force sw 16'h 0 ns

run 200000 ns