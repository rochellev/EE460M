# module proj4_7seg4(en, bcd0, bcd1, bcd2, bcd3, clk, anodes, segs, decimalPt);

restart

add wave en
add wave bcd0
add wave bcd1
add wave bcd2
add wave bcd3
add wave clk
add wave anodes
add wave segs
add wave decimalPt

force clk 0 0ns, 1 1ns -repeat 2 ns 

force en 1 0

force bcd0 4'h0 0
force bcd1 4'h0 0
force bcd2 4'h0 0
force bcd3 4'h0 0

run 60 ms
