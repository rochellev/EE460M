# module ps2(clk100Mhz, PS2Clk, PS2Data, key_code1, key_code0, key_code_en, strobe);

restart

force PS2Clk 0 100 ns, 1 1766 ns -repeat 3332 ns
force clk100Mhz 0 0 ns, 1 5 ns -repeat 10 ns

force PS2Data 0 0 ns, 0 3332 ns, 0 6664 ns, 1 9996 ns, 1 13328 ns, 1 16660 ns, 0 19991 ns, 0 23324 ns, 0 26656 ns, 1 29988 ns, 0 33320 ns, 0 36652 ns, 0 39984 ns, 0 43316 ns, 0 46648 ns, 0 49980 ns, 1 53312 ns, 1 56644 ns, 1 59976 ns, 1 63308 ns, 0 66640 ns, 0 69972 ns, 0 73304 ns, 0 76636 ns, 0 79968 ns, 1 83300 ns, 1 86632 ns, 1 89964 ns, 0 93296 ns, 0 96628 ns, 0 99960 ns, 1 103292 ns, 0 106624 ns

run 200000 ns 