# proj4_btnCtlr p4bc(btnu, btnl, btnr, btnd, sw0, sw1, clk, anodes, segs, decimalPt);

restart

add wave btnu
add wave btnl
add wave btnr
add wave btnd
add wave sw0
add wave sw1
add wave clk
add wave anodes
add wave segs
add wave decimalPt

force clk 0 0ns, 1 5ns -repeat 10 ns

force sw0 1 1000000 ns, 0 2000000 ns

run 6 ms
