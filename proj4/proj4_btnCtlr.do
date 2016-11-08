# proj4_btnCtlr p4bc(btnu, btnl, btnr, btnd, sw0, sw1, clk, anodes, segs, decimalPt);

restart

force btnu 0 0
force btnl 0 0
force btnr 0 0
force btnd 0 0
force sw1 0 0

force deb_btnu 0 0
force deb_btnl 0 0
force deb_btnr 0 0
force deb_btnd 0 0

force pulse_btnu 0 0
force pulse_btnl 0 0
force pulse_btnr 0 0
force pulse_btnd 0 0
force pulse_sw1 0 0


force clk 0 0ns, 1 5ns -repeat 10 ns

force sw0 0 0, 1 1000000 ns, 0 2500000 ns

run 8 ms
