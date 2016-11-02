module top_testBench;
  reg clk;

  parameter clkCycles = 400000;
  
  `define TOP_TESTBENCH_STOP_SIG 8'hf0
  `define TOP_TESTBENCH_A_KEY 8'h1c
  
  parameter[32:0] PS2Data = {2'b01, TOP_TESTBENCH_A_KEY, 1'b0, 
                             2'b00, TOP_TESTBENCH_STOP_SIG, 1'b0,
                             2'b01, TOP_TESTBENCH_A_KEY, 1'b0};
  
  parameter ps2ClkCycles = 3333;
  parameter ps2DataStart = 0;
  parameter ps2DataStart = ;
  
endmodule