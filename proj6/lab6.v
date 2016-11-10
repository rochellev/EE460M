module top(clk, mode, btns, sw, led, segs, an);
  input clk;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] sw;
  output[7:0] led;
  output[6:0] segs;
  output[3:0] an;

  //might need to change some of these from wires to regs
  `define Z 8'bZZZZZZZZ
  wire cs;
  wire we;
  wire[6:0] addr;
  wire[7:0] data_out_mem;
  wire[7:0] data_out_ctrl;
  wire[7:0] data_bus;
  

  //MODIFY THE RIGHT HAND SIDE OF THESE TWO STATEMENTS ONLY
  assign data_bus = (we) ? data_out_ctrl : `Z; // 1st driver of the data bus -- tri state switches,
                       // logical function of we and data_out_ctrl

  assign data_bus = (!we) ? data_out_mem : `Z; // 2nd driver of the data bus -- tri state switches,
                       // logical function of we and data_out_mem


  controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, mode,
    btns, sw, led, segs, an);

  memory mem(clk, cs, we, addr, data_bus, data_out_mem);

  //add any other functions you need
  //(e.g. debouncing, multiplexing, clock-division, etc)

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module controller(clk, cs, we, address, data_in, data_out, mode, btns, sw, leds, segs, an);
  input clk;
  output reg cs;
  output reg we;
  output reg[6:0] address;
  input[7:0] data_in;
  output reg[7:0] data_out;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] sw;
  output[7:0] leds;
  output[6:0] segs;
  output[3:0] an;
  wire decimalPt;

  wire debClk, singlePulseClk;
  wire btnLDeb, btnRDeb;
  wire btnLDebouncedSP, btnRDebouncedSP;
  
  reg[6:0] spr, dar;
  reg[7:0] dvr;
  wire empty; 
  
  reg[9:0] ctlrState = 0;
  
  `define MASTER_CTLR_CLK_DIV_100MHZ_TO_550HZ 2750000 //the segs are flashing 
  `define MASTER_CTLR_CLK_DIV_100MHZ_TO_1KHZ 50000 //not reading buttons
  
  localparam[27:0] debClkDivDelay = `MASTER_CTLR_CLK_DIV_100MHZ_TO_550HZ;
  localparam[27:0] singlePulseClkDivDelay = `MASTER_CTLR_CLK_DIV_100MHZ_TO_1KHZ;
  
  complexDivider debounceClk(clk, debClkDivDelay, debClk);
  complexDivider pulseClk(clk, singlePulseClkDivDelay, singlePulseClk);
  
  debouncer btnLDebouncer(debClk, btns[1], btnLDeb);
  debouncer btnRDebouncer(debClk, btns[0], btnRDeb);
  
  single_pulse btnLSinglePulser(singlePulseClk, btnLDeb, btnLDebouncedSP);
  single_pulse btnRSinglePulser(singlePulseClk, btnRDeb, btnRDebouncedSP);
   //proj5_7seg2(en7Seg, hex1, hex0, clk, anodes, segs, decimalPt);
  proj5_7seg2 dvrContents(1'b1, dvr[7-:4], dvr[3-:4], clk, an, segs, decimalPt);
  
  assign empty = (dar)? 0: 1;
  
  assign leds = {empty, dar};
  
  `define CTLR_POP_PUSH_MODE 0
  `define CTLR_ADD_SUB_MODE 1
  `define CTLR_RST_TOP_MODE 2
  `define CTLR_DEC_INC_MODE 3
  
  always@(negedge singlePulseClk) begin 
    we <= 0;
    cs <= 0;
    
    case(ctlrState)
      0: begin 
        case(sw)
          `CTLR_POP_PUSH_MODE: begin 
            if(btnLDebouncedSP) begin 
              ctlrState <= 1;
            end else if(btnRDebouncedSP) begin 
              ctlrState <= 4;
            end
          end
        endcase  
      end
      
      //POP
      1: begin 
        spr <= spr + 1;
        dar <= spr + 2;
        ctlrState <= 2;
      end
      
      //DVR UPDATE
      2: begin 
        address <= dar;
        ctlrState <= 3;
      end
      
      3: begin 
        dvr <= data_in;
        ctlrState <= 0;
      end
      
      //PUSH
      4: begin 
        we <= 1;
        address <= spr;
        data_out <= sw;
        ctlrState <= 5;
      end
      
      5: begin
        we <= 0;
        spr <= spr - 1;
        dar <= spr;
        ctlrState <= 2;
      end
    endcase
  end
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module memory(clock, cs, we, address, data_in, data_out);
  //DO NOT MODIFY THIS MODULE
  input clock;
  input cs;
  input we;
  input[6:0] address;
  input[7:0] data_in;
  output[7:0] data_out;

  reg[7:0] data_out;

  reg[7:0] RAM[0:127];

  always @ (negedge clock)
  begin
    if((we == 1) && (cs == 1))
      RAM[address] <= data_in[7:0];

    data_out <= RAM[address];
  end
endmodule
