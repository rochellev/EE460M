# module proj4_7seg4(en, bcd0, bcd1, bcd2, bcd3, clk, anodes, segs, decimalPt);

restart

force clk 0 0ns, 1 1ns -repeat 10 ns 

force bcd0 4'h0 0
force bcd1 4'h0 0
force bcd2 4'h0 0
force bcd3 4'h0 0

run 3 ms
