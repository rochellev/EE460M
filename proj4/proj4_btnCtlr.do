# module proj4_btnCtlr(btnu, btnl, btnr, btnd, sw0, sw1, clk, bcdIn, bcdOut, ld);

restart

add wave btnu
add wave btnl
add wave btnr
add wave btnd
add wave sw0
add wave sw1
add wave clk
add wave debClk
add wave s_pClk
add wave bcdIn
add wave bcdOut
add wave ld

force clk 0 0ns, 1 5ns -repeat 10 ns

force bcdIn 16'h1000

force sw0 1 1000000 ns, 0 1010000 ns

force btnu 1 1100000 ns, 0 1300000 ns

run 6 ms
