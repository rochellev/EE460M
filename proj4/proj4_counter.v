module proj4_counter(pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk, d);
  input pulse_btnu, pulse_btnl, pulse_btnr, pulse_btnd, sw0, sw1, clk;
  
  reg[15:0] sum;
  output[15:0] d;
  dec2bcd d2b(sum, d);
  
  wire[15:0] q;
  wire[15:0] n;
  bcd2dec b2d(q, n);
  
  localparam enDec = 1'b1;
  reg ld;
  wire ldDec;
  localparam upDec = 1'b0;
  reg clrDec;
  wire clkDec;
  localparam[27:0] clkDecPeriod = 100000;
  complexDivider clkDivDec(clk, clkDecPeriod, clkDec); //1-second period
  wire carryOut; //not used
  
  initial begin 
    clrDec = 1'b0;
    clrDec <= 1'b1;
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
        ld <= 0;
        sum <= n;
      end
    end
  end
  
  assign ldDec = ld && (sum <= 9999);
  
  //module bcd_ctr9999(en, ld, up, clr, clk, d, q, co);
  bcd_ctr9999 bc9999(enDec, ldDec, upDec, clrDec, clkDec, d, q, carryOut);
endmodule
