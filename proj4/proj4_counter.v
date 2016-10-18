module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk, d, en7Seg);
  input pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk;
  
  reg[15:0] sum;
  localparam[15:0] MAX = 9999;
  output[15:0] d;
  output reg en7Seg;
  reg[15:0] dSynch;
  dec2bcd d2b((sum > MAX)? MAX: sum, d);
  
  wire[15:0] q;
  wire[15:0] n;
  bcd2dec b2d(q, n);
  
  reg enDec;
  reg ld;
  reg ldDec;
  localparam upDec = 1'b0;
  reg clrDec;
  wire carryOut; //not used
  
  initial begin 
    en7Seg <= 1;
    clrDec = 1'b0;
    clrDec <= 1'b1;
    enDec <= 1;
  end
  
  always@(*) begin
    if(sw0) begin
      ld <= 1;
      sum <= 15;
    end else if(sw1) begin 
      ld <= 1;
      sum <= 185;
    end else begin
      if(pulse_btnu) begin 
        ld <= 1;
        sum <= n + 30;
      end else if(pulse_btnl) begin 
        ld <= 1;
        sum <= n + 120;
      end else if(pulse_btnr) begin 
        ld <= 1;
        sum <= n + 180;
      end else if(pulse_btnd) begin 
        ld <= 1;
        sum <= n + 300;
      end else begin
        if(q != 0) begin
          ld <= 0;
          sum <= n;
        end else begin 
          ld <= 1;
          sum <= 0;
        end
      end
    end 
  end
  
  always@(posedge clk) begin 
    ldDec <= ld;
    dSynch <= d;
    if(d < 16'h0181) begin 
      if(d & 1) begin 
        en7Seg <= 1;
      end else begin 
        en7Seg <= 0;
      end
    end else begin 
      en7Seg <= 1;
    end
  end
  
  //module bcd_ctr9999(en, ld, up, clr, clk, d, q, co);
  bcd_ctr9999 bc9999(enDec, ld, upDec, clrDec, clk, d, q, carryOut);
endmodule
