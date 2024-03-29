module snake_ctlr(start, pause, resume, stop, u, d, l, r, sw, x, y, clk100Mhz, Rout, Gout, Bout);
  input start, pause, resume, stop, u, d, l, r, clk100Mhz;
  input[7:0] sw;
  input[9:0] x, y;
  
  output[3:0] Rout, Gout, Bout;

  integer i;
  
  wire[7:0] pxl_color;
  
  `define S 8'h1B
  `define P 8'h4D
  `define R 8'h2D
  `define ESC 8'h76
  `define Rt 8'h74
  `define Lf 8'h6B
  `define Up 8'h75
  `define Dn 8'h72
  
  `define SNAKE_CTLR_CLKDIV100MHZ_TO_40HZ_DELAY 1250000
    wire clk40Hz;
    
    complexDivider snakeGameLogicDiv(clk100Mhz, `SNAKE_CTLR_CLKDIV100MHZ_TO_40HZ_DELAY, clk40Hz);
  
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
  
  reg[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1] drawSnake;
  reg[2:0] snakeSize = `SNAKE_CTLR_NUM_SNAKE_PIECES_INIT;
  
  reg[1:0] gameState = 0;
  reg paused = 0;
  reg gameOverState = 0;
  reg stopped = 1;
  reg[7:0] dir = `Rt;
  reg[0:`SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1] gameOver;
  
  reg[1:0] frameCtr = 0;
  always@(posedge clk40Hz) begin
    frameCtr <= (frameCtr == 3)? 0: frameCtr + 1;
    case(gameState)
      0: begin
        if(paused) begin 
          if(resume) begin 
            paused <= 0;
            gameState <= 1;
          end
        end else if(gameOverState) begin 
            if(start) begin 
              gameOverState <= 0;  
            end
        end else if(stopped) begin
            if(start) begin 
                stopped <= 0;
            end
        end else begin
            dir <= `Rt;
            for(i = `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX - 1; i >= 0; i = i - 1) begin 
              if(i < snakeSize) begin
                  snakeX[(snakeSize - 1) - i] <= i * `SNAKE_CTLR_SNAKE_PIECE_WIDTH;
                  snakeY[(snakeSize - 1) - i] <= 0;
              end
            end
            
            gameState <= 1;
        end    
      end
      
      1: begin
        if(start) begin 
            gameState <= 0;
        end else if(stop) begin 
          stopped <= 1;
          gameState <= 0;
        end else if(pause) begin 
          paused <= 1;
          gameState <= 0;
        end else if(|gameOver) begin
          gameOverState <= 1;
          gameState <= 0;
        end else begin
          if(u && (dir != `Dn)) begin
            dir <= `Up;
          end if(r && (dir != `Lf)) begin 
            dir <= `Rt;
          end if(l && (dir != `Rt)) begin 
            dir <= `Lf;
          end if(d && (dir != `Up)) begin
            dir <= `Dn;
          end
          
          if(frameCtr == 0) begin
              if(dir == `Up) begin 
                  snakeY[`SNAKE_CTLR_SNAKE_HEAD] <= snakeY[`SNAKE_CTLR_SNAKE_HEAD]
                                                  - `SNAKE_CTLR_SNAKE_PIECE_HEIGHT;
                end if(dir == `Rt) begin 
                  snakeX[`SNAKE_CTLR_SNAKE_HEAD] <= snakeX[`SNAKE_CTLR_SNAKE_HEAD]
                                                  + `SNAKE_CTLR_SNAKE_PIECE_WIDTH;
                end if(dir == `Lf) begin 
                  snakeX[`SNAKE_CTLR_SNAKE_HEAD] <= snakeX[`SNAKE_CTLR_SNAKE_HEAD]
                                                  - `SNAKE_CTLR_SNAKE_PIECE_WIDTH;
                end if(dir == `Dn) begin 
                  snakeY[`SNAKE_CTLR_SNAKE_HEAD] <= snakeY[`SNAKE_CTLR_SNAKE_HEAD]
                                                  + `SNAKE_CTLR_SNAKE_PIECE_HEIGHT;
                end
              
              for(i = 1; i < `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX; i = i + 1) begin 
                if(i < snakeSize) begin
                    snakeX[i] <= snakeX[i - 1];
                    snakeY[i] <= snakeY[i - 1];
                end
              end
          end
        end
      end
    endcase
  end
  
  always@(*) begin 
    drawSnake <= 0;
    if(!stopped && (x < `SNAKE_CTLR_DISPLAY_WIDTH)
       && (y < `SNAKE_CTLR_DISPLAY_HEIGHT)) begin
      for(i = 0; i < `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX; i = i + 1) begin 
        if(i < snakeSize) begin
          drawSnake[i] <= ((x < (snakeX[i] + `SNAKE_CTLR_SNAKE_PIECE_WIDTH)
                                 && x > snakeX[i]) &&
                                 (y < (snakeY[i] + `SNAKE_CTLR_SNAKE_PIECE_HEIGHT)
                                 && y > snakeY[i]));
        end                           
      end 
    end
  end
  
  assign pxl_color = (|drawSnake)? `SNAKE_CTLR_RED: sw;
  colors vga_color(pxl_color, Rout, Gout, Bout);
  
  always@(*) begin 
    gameOver <= ((snakeX[`SNAKE_CTLR_SNAKE_HEAD] > `SNAKE_CTLR_DISPLAY_WIDTH)
                 || (snakeY[`SNAKE_CTLR_SNAKE_HEAD] > `SNAKE_CTLR_DISPLAY_HEIGHT));
                 
    for(i = 1; i < `SNAKE_CTLR_NUM_SNAKE_PIECES_MAX; i = i + 1) begin 
      if(i < snakeSize) begin
        gameOver[i] <= ((snakeX[`SNAKE_CTLR_SNAKE_HEAD] < (snakeX[i] + `SNAKE_CTLR_SNAKE_PIECE_WIDTH)
                     && snakeX[`SNAKE_CTLR_SNAKE_HEAD] > snakeX[i]) &&
                     (snakeY[`SNAKE_CTLR_SNAKE_HEAD] < (snakeY[i] + `SNAKE_CTLR_SNAKE_PIECE_HEIGHT)
                     && snakeY[`SNAKE_CTLR_SNAKE_HEAD] > snakeY[i]));
      end
    end 
  end
endmodule