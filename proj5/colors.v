module colors(sw, Rout, Gout, Bout);
  input[7:0] sw;
  output[3:0] Rout, Gout, Bout;

  reg[3:0] R, G, B;

  reg colorsIndex;
  
  `define COLORS_BLACK 12'h000
  `define COLORS_DARKMAGENTA 12'hF0F
  `define COLORS_DARKGREEN 12'h040
  `define COLORS_BLUE 12'h00F
  `define COLORS_RED 12'hF00
  `define COLORS_ORANGE 12'hF60
  `define COLORS_YELLOW 12'hFF0
  `define COLORS_WHITE 12'hFFF
  
  assign {Rout, Gout, Bout} = {R, G, B};
  
  always@(*) begin 
    case(sw)
      1: begin {R, G, B} <= `COLORS_BLACK; end
      2: begin {R, G, B} <= `COLORS_DARKMAGENTA; end
      4: begin {R, G, B} <= `COLORS_DARKGREEN; end
      8: begin {R, G, B} <= `COLORS_BLUE; end
      16: begin {R, G, B} <= `COLORS_RED; end
      32: begin {R, G, B} <= `COLORS_ORANGE; end
      64: begin {R, G, B} <= `COLORS_YELLOW; end
      128: begin {R, G, B} <= `COLORS_WHITE; end
      default: begin {R, G, B} <= `COLORS_BLACK; end
    endcase
  end
endmodule
