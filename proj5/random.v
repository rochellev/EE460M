module random(clk, seed, randNum);
  input clk;
  input[9:0] seed;
  
  output[9:0] randNum;
  
  reg[9:0] randNumInternal;
  
  assign randNum = randNumInternal;
  
  always@(posedge clk) begin 
    randNumInternal <= {randNumInternal + seed, randNum[9] ^ randNum[8]};
  end
endmodule