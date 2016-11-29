# module Complete_MIPS(CLK, sw2, sw1, sw0, btnl, btnr, an, segs);

restart

force CLK 0 0 ns, 1 5 ns -repeat 10 ns 

force sw0 0 0, 1 2000000
force sw1 0 0
force sw2 0 0
force btnl 0 0
force btnr 0 0  


run 5000000