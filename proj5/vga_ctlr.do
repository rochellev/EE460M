# module module vga_ctlr(pxlClk25Mhz, pxl_color, R, G, B, hSync, vSync);

restart

force pxlClk25Mhz 0 0 ns, 1 20 ns -repeat 40 ns 

force pxl_color 1 0 ns

run 200000 ns