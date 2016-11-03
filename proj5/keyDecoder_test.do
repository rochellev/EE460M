
#module keyDecoder(clk, key_code1, key_code0, s, p, r, esc, rt, lf, up, dn);

restart

force clk 0 0ns, 1 5ns -repeat 10ns

force key_code1 4'h1 5ns, 4'h4 15ns, 4'h2 25ns, 4'h7 35ns, 4'h7 45ns, 4'h6 55ns, 4'h7 65ns, 4'h7 75ns, 4'h1 85ns

force key_code0 4'hB 5ns, 4'hD 15ns, 4'hD 25ns, 4'h6 35ns, 4'h5 45ns, 4'hB 55ns, 4'h5 65ns, 4'h2 75ns, 4'h1 85ns

run 100ns