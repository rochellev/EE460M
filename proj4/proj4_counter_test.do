# module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk, q);

restart

force clk 0 0ns, 1 5ns -repeat 10 ns 

force clrDec 0 0, 1 100000

force pulse_btnu 0 0
force pulse_btnl 0 0
force pulse_btnr 0 0
force pulse_btnd 0 0
force sw0 0 0, 1 500000, 0 1500000
force sw1 0 0

run 6 ms
