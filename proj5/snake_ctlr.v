module snake_ctlr(u, d, l, r, start, pause, resume, stop, sw, x, y, clk100Mhz, pxlClk25Mhz, pxl_color);
  input u, d, l, r, start, pause, resume, stop, clk100Mhz, pxlClk25Mhz;
  input[7:0] sw;
  input[9:0] x, y;
  
  output reg pxl_color;
  
  reg[4:0] iUpdate, iDraw, iGameOver;
  
  reg gameOver;
  
  `define S 8'h1B
  `define P 8'h4D
  `define R 8'h2D
  `define ESC 8'h76
  `define Rt 8'h74
  `define Lf 8'h6B
  `define Up 8'h75
  `define Dn 8'h72
  
  reg[7:0] dir = `Rt;
  
  `define SNAKE_CTLR_SNAKE_HEAD 0
  
  `define SNAKE_CTLR_NUM_SNAKE_PIECES_INIT 5
  `define SNAKE_CTLR_NUM_SNAKE_PIECES_MAX 20
  
  `define SNAKE_CTLR_DISPLAY_WIDTH 640
  `define SNAKE_CTLR_DISPLAY_HEIGHT 480
  
  `define SNAKE_CTLR_SNAKE_PIECE_WIDTH 10
  `define SNAKE_CTLR_SNAKE_PIECE_HEIGHT 10
  
  //refer to colors.v and vga_ctlr.v to explain these values
  `define SNAKE_CTLR_RED 16
  
  reg[9:0] snakeX[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1];
  reg[9:0] snakeY[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1];
  
  reg drawSnake;
  reg snakeSize = `SNAKE_CTLR_NUM_SNAKE_PIECES_INIT;
  
  `define SNAKE_CTLR_CLKDIV100MHZ_TO_60HZ_DELAY 833333
  `define SNAKE_CTLR_CLKDIV100MHZ_TO_10KHZ_DELAY 500
  wire clk60Hz, clk10Khz;
  
  complexDivider snakeGameLogicDiv(clk100Mhz, `SNAKE_CTLR_CLKDIV100MHZ_TO_60HZ_DELAY, clk60Hz);
  complexDivider gameOverDiv(clk100Mhz, `SNAKE_CTLR_CLKDIV100MHZ_TO_10KHZ_DELAY, clk10Khz);
  
  // `define Rt 8'h74
  // `define Lf 8'h6B
  // `define Up 8'h75
  // `define Dn 8'h72
  
  always@(posedge clk60Hz) begin
    if(!pause && !stop && !gameOver) begin
      if(u && (dir != `Dn)) begin 
        snakeY[`SNAKE_CTLR_SNAKE_HEAD] <= snakeY[`SNAKE_CTLR_SNAKE_HEAD]
                                        + `SNAKE_CTLR_SNAKE_PIECE_HEIGHT;
        dir <= `Up;
      end if(r && (dir != `Lf)) begin 
        snakeX[`SNAKE_CTLR_SNAKE_HEAD] <= snakeY[`SNAKE_CTLR_SNAKE_HEAD]
                                        + `SNAKE_CTLR_SNAKE_PIECE_WIDTH;
        dir <= `Rt;
      end if(l && (dir != `Rt)) begin 
        snakeX[`SNAKE_CTLR_SNAKE_HEAD] <= snakeY[`SNAKE_CTLR_SNAKE_HEAD]
                                        - `SNAKE_CTLR_SNAKE_PIECE_WIDTH;
        dir <= `Lf;
      end if(d && (dir != `Up)) begin 
        snakeY[`SNAKE_CTLR_SNAKE_HEAD] <= snakeY[`SNAKE_CTLR_SNAKE_HEAD]
                                        - `SNAKE_CTLR_SNAKE_PIECE_HEIGHT;
        dir <= `Dn;
      end
      
      for(iUpdate = 1; iUpdate < `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX; iUpdate = iUpdate + 1) begin 
        snakeX[iUpdate] <= snakeX[iUpdate - 1];
        snakeY[iUpdate] <= snakeY[iUpdate - 1];
      end
    end
  end
  
  always@(*) begin 
    drawSnake <= 0;
    if(!stop && (x < `SNAKE_CTLR_DISPLAY_WIDTH)
       && (y < `SNAKE_CTLR_DISPLAY_HEIGHT)) begin
      for(iDraw = 1; iDraw < `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX; iDraw = iDraw + 1) begin 
        if(iDraw <= snakeSize) begin
          drawSnake <= drawSnake || ((x < (snakeX[iDraw] + `SNAKE_CTLR_SNAKE_PIECE_WIDTH)
                                     && x > snakeX[iDraw]) &&
                                     (y < (snakeY[iDraw] + `SNAKE_CTLR_SNAKE_PIECE_HEIGHT)
                                     && y > snakeY[iDraw]));
        end                           
      end 
    end
  end
  
  always@(posedge clk10Khz) begin 
    gameOver <= ((snakeX[`SNAKE_CTLR_SNAKE_HEAD] > `SNAKE_CTLR_DISPLAY_WIDTH)
                 || (snakeY[`SNAKE_CTLR_SNAKE_HEAD] > `SNAKE_CTLR_DISPLAY_HEIGHT));
                 
    for(iGameOver = 1; iGameOver < `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX; iGameOver = iGameOver + 1) begin 
      if(iDraw <= snakeSize) begin
        gameOver <= gameOver || ((snakeX[`SNAKE_CTLR_SNAKE_HEAD] < (snakeX[iGameOver] + `SNAKE_CTLR_SNAKE_PIECE_WIDTH)
                                 && snakeX[`SNAKE_CTLR_SNAKE_HEAD] > snakeX[iGameOver]) &&
                                 (snakeY[`SNAKE_CTLR_SNAKE_HEAD] < (snakeY[iGameOver] + `SNAKE_CTLR_SNAKE_PIECE_HEIGHT)
                                 && snakeY[`SNAKE_CTLR_SNAKE_HEAD] > snakeY[iGameOver]));
      end
    end 
  end
  
  always@(posedge pxlClk25Mhz) begin 
    if(drawSnake) begin 
      pxl_color <= `SNAKE_CTLR_RED;
    end else begin 
      pxl_color <= sw;
    end
  end
endmodule