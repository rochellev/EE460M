# module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk, q);


force btnu 0 0ns, 1 6ns, 0 23ns
force btnl 0 0ns, 1 84ns, 0 150ns
force btnr 0 0ns, 1 195ns, 0 230ns
force btnd 0 0ns, 1 289ns, 0 356ns
force sw0 0 0ns, 1 404ns, 0 462ns
force sw1 0 0ns, 1 535ns, 0 679ns

run 900ns
=======
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

