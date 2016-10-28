module colors(sw, R, G, B);
  input[7:0] sw;
  output[7:0] R, G, B;

  reg colorsIndex;
  
  `define COLORS_BLACK 24'h000000
  `define COLORS_DARKMAGENTA 24'h8B008B
  `define COLORS_DARKGREEN 24'h006400
  `define COLORS_BLUE 24'h0000FF
  `define COLORS_RED 24'hFF0000
  `define COLORS_ORANGE 24'hFFA500
  `define COLORS_YELLOW 24'hFFFF00
  `define COLORS_WHITE 24'hFFFFFF
  
  always@(*) begin 
    case(sw)
      1: begin colorsIndex <= 0; end
      2: begin colorsIndex <= 1; end
      4: begin colorsIndex <= 2; end
      8: begin colorsIndex <= 3; end
      16: begin colorsIndex <= 4; end
      32: begin colorsIndex <= 5; end
      64: begin colorsIndex <= 6; end
      128: begin colorsIndex <= 7; end
      default: begin colorsIndex <= 7; end
    endcase
  end
  
  localparam[23:0] colorsRGB[0:7] = '{`COLORS_BLACK, `COLORS_DARKMAGENTA,
                                     `COLORS_DARKGREEN, `COLORS_BLUE, `COLORS_RED,
                                     `COLORS_ORANGE, `COLORS_YELLOW, `COLORS_WHITE};
  
  assign {R, G, B} = colorsRGB[colorsIndex];
endmodule
