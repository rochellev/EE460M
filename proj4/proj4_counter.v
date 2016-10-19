module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, fastclk, clk, slowClk, d, en7Seg);
  input pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, fastclk, clk, slowClk;
  
  reg[15:0] sum;
  localparam[15:0] MAX = 9999;
  output[15:0] d;
  output en7Seg;
  reg en7SegOdd;
  reg en7SegZero;
  
  wire reset;
  reg resetSum = 1;
  reg resetDec = 0;
  
  assign reset = resetSum ^ resetDec;
  
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
  
  always@(posedge fastclk) begin
    ld <= 1;
    if(sw0) begin
      ld <= 1;
      sum <= 15;
    end else if(sw1) begin 
      ld <= 1;
      sum <= 185;
    end else begin
      if(pulse_btnu) begin 
        ld <= 1;
        sum <= sum + 30;
      end else if(pulse_btnl) begin 
        ld <= 1;
        sum <= sum + 120;
      end else if(pulse_btnr) begin 
        ld <= 1;
        sum <= sum + 180;
      end else if(pulse_btnd) begin 
        ld <= 1;
        sum <= sum + 300;
      end else begin
        if(d != 0) begin
            if(reset) begin 
              ld <= 0;
              sum <= n;
              resetSum <= !resetSum;
            end else begin
              ld <= ld;
              sum <= sum;
            end
        end else begin 
          ld <= 1;
          sum <= 0;
        end
      end
    end 
  end
  
  always@(posedge slowClk) begin
    resetDec <= !resetDec;
    if(!(sw0 || sw1)) begin
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
