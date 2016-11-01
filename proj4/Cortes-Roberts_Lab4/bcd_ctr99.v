module bcd_ctr99(En, Ld, Up, Clr, Clk, D1, D2, Q1, Q2, Co);
  input En, Ld, Up, Clr, Clk, D1, D2;
  wire [3:0] D1;
  wire[3:0] D2;
  output Q1, Q2, Co;
  wire [3:0] Q1;
  wire [3:0] Q2;
  wire Co;
  

  wire Co1;
  wire Co10;
  reg En10;

  always@(En, Ld, Co1)
  begin
    if(En & Ld) begin En10 <= 1'b1; end
    else if(Co1 & En) begin En10 <= 1'b1; end
    else begin En10 <= 1'b0; end
  end

  bcd_ctr dig_1(En, Ld, Up, Clr, Clk, D1, Q1, Co1);
  bcd_ctr dig_10(En10, Ld, Up, Clr, Clk, D2, Q2, Co10);

  assign Co = Co1 & Co10;	
endmodule
