module clk_div_sevenSeg(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output slowClk; //slow clock

  reg[21:0] counter;
  assign slowClk = counter[21];  //(2^21 / 100E6) = .0104 seconds

  initial begin
    counter = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
  end
endmodule
