# proj4_counter p4c(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, s_pClk, s_pSlowClk, qDec, en7Seg);

restart

force clk 0 0, 1 237500 -repeat 475000 ns
force slowClk 0 0, 1 475000 -repeat 950000 ns

force pulse_btnu 0 0ns 
force pulse_btnl 0 0ns
force pulse_btnr 0 0ns
force pulse_btnd 0 0ns
force sw1 0 0ns
force sw0 1 0ns, 0 1500000

run 6 ms
