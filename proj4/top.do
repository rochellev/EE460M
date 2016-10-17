# module top(btnu, btnl, btnr, btnd, sw0, sw1, fastclk, anodes, segs, decimalPt);

restart

force btnl 0 0
force btnu 0 0, 1 1
force btnr 0 0
force btnd 0 0 
force sw0 0 0
force sw1 0 0

force fastclk 0 0ns, 1 5ns -repeat 10 ns 

run 6 ms
