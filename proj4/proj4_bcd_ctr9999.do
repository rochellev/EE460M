restart
add wave en
add wave ld
add wave up
add wave clr
add wave clk
add wave d
add wave q
add wave co

force clk 0 0 ns, 1 5 ns -repeat 10 ns

force en 1 0 ns
force ld 1 0 ns
force up 0 0 ns
force clr 1 0 ns
force d 4'h9999 0 ns

force ld 0 7 ns

force clr 0 120 ns, 1 130 ns

run 150 ns