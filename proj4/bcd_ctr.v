module bcd_ctr(En, Ld, Up, Clr, Clk, D, Q, Co);
  input En, Ld, Up, Clr, Clk, D;
  wire [3:0] D;
  output Q, Co;
  reg [3:0] Q;
  reg Co;

  always@(posedge Clk, negedge Clr)
  begin
    if(~Clr) begin Q <= 4'b0000; end
    else if(Ld & En) begin
      if(D <= 4'b1001) begin
        Q <= D;
      end else begin
        Q <= 4'b1001;
      end
    end else if((~Ld) & En) begin
      if(~Up) begin
        Q <= (Q == 4'b0000)? 4'b1001: (Q - 1); 
      end else begin
        Q <= (Q == 4'b1001)? 4'b0000: (Q + 1); 
      end
    end else begin end
  end
  
  always@(*)
  begin
    if(Clr) begin
      if((En & Up) && (Q == 4'b1001)) begin Co <= 1'b1; end
      else if((En & (~Up)) && (Q == 4'b0000)) begin Co <= 1'b1; end
      else begin Co <= 1'b0; end
    end else begin Co <= 1'b0; end
  end
endmodule




