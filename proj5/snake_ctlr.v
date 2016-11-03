module snake_ctlr(u, d, l, r, start, pause, resume, stop, pxlClk25Mhz, pxl_color);
  input reg u, d, l, r, pause, resume, stop, pxlClk25Mhz;
  output pxl_color;
  
  reg game_over;
  
  `define SNAKE_CTLR_NUM_SNAKE_PIECES_MAX 20
  
  `define SNAKE_CTLR_DISPLAY_WIDTH 640
  `define SNAKE_CTLR_DISPLAY_HEIGHT 480
  
  `define SNAKE_CTLR_SNAKE_PIECE_WIDTH 10
  `define SNAKE_CTLR_SNAKE_PIECE_HEIGHT 10
  
  //refer to colors.v and vga_ctlr.v to explain these values
  `define SNAKE_CTLR_BLACK 1
  `define SNAKE_CTLR_RED 16
  
  reg[9:0] snakeXCur[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1];
  reg[9:0] snakeYCur[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1];
  reg[9:0] snakeXNext[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1];
  reg[9:0] snakeYNext[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1];
  
  reg drawSnake;
  
  always@(pxlClk25Mhz) begin 
    if(drawSnake) begin 
      pxl_color <= SNAKE_CTLR_RED;
    end else begin 
      pxl_color <= SNAKE_CTLR_BLACK;
    end
  end
endmodule