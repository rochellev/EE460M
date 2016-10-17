# module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk, q);

restart

force clk 0 0, 1 5 -repeat 10 ns

force pulse_btnu 0 0ns 
force pulse_btnl 0 0ns
force pulse_btnr 0 0ns
force pulse_btnd 0 0ns
force sw1 0 0ns
force sw0 1 0ns, 0 1500000

run 6 ms
