module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, fastclk, clk, slowClk, d, en7Seg);
  input pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, fastclk, clk, slowClk;
  
  reg[15:0] sum;
  localparam[15:0] MAX = 9999;
  output[15:0] d;
  output en7Seg;
  reg en7SegOdd;
  reg en7SegZero;
  
  assign en7Seg = en7SegOdd && en7SegZero;
  
  dec2bcd d2b((sum > MAX)? MAX: sum, d);
  
  wire[15:0] q;
  wire[15:0] n;
  bcd2dec b2d(q, n);
  
  reg enDec;
  reg ld;
  localparam upDec = 0;
  localparam clrDec = 1;
  wire carryOut; //not used
  
  initial begin
    en7SegOdd <= 1;
    en7SegZero <= 1;
    enDec <= 1;
  end
  
//  localparam[27:0] s_pClkPeriod = 1000;
//  reg[9:0] s_pCtr = 1;
  always@(posedge fastclk) begin
//    ld <= 0;
//    if(s_pCtr == s_pClkPeriod) begin
//      s_pCtr <= 1;
//    end else begin 
//      s_pCtr <= s_pCtr + 1;
//    end
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
        if(d != 0) begin
          ld <= 0;
          sum <= n;
        end else begin 
          ld <= 1;
          sum <= 0;
        end
      end
    end 
  end
  
  always@(posedge slowClk) begin
    if(d <= 16'h0181) begin 
      if(!(d & 1)) begin 
        en7SegOdd <= 1;
      end else begin 
        if(d == 0) begin
          en7SegOdd <= 1;
        end else begin
          en7SegOdd <= 0;
        end
      end
    end else begin 
      en7SegOdd <= 1;
    end
  end
  
  always@(posedge clk) begin
    if(d == 0) begin 
      en7SegZero <= en7SegZero ^ 1;
    end else begin
      en7SegZero <= 1;
    end
  end
  
  //module bcd_ctr9999(en, ld, up, clr, clk, d, q, co);
  bcd_ctr9999 bc9999(enDec, ld, upDec, clrDec, slowClk, d, q, carryOut);
endmodule
