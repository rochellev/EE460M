module top(clk, mode, btns, swtchs, leds, segs, an);
  input clk;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] swtchs;
  output[7:0] leds;
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
  assign data_bus = (we) ? `Z : data_out_ctrl ; // 1st driver of the data bus -- tri state switches,
                       // logical function of we and data_out_ctrl

  assign data_bus = (we) ? data_out_mem: `Z  ; // 2nd driver of the data bus -- tri state switches,
                       // logical function of we and data_out_mem


  controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, mode,
    btns, swtchs, leds, segs, an);

  memory mem(clk, cs, we, addr, data_bus, data_out_mem);

  //add any other functions you need
  //(e.g. debouncing, multiplexing, clock-division, etc)

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module controller(clk, cs, we, address, data_in, data_out, mode, btns, swtchs, leds, segs, an);
  input clk;
  output cs;
  output we;
  output[6:0] address;
  input[7:0] data_in;
  output[7:0] data_out;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] swtchs;
  output[7:0] leds;
  output[6:0] segs;
  output[3:0] an;

  wire debClk, singlePulseClk;
  reg btnLDeb, btnRDeb;
  reg btnLDebouncedSP, btnRDebouncedSP;
  
  reg[6:0] spr, dar;
  reg[7:0] dvr;
  wire empty;
  
  `define MASTER_CTLR_CLK_DIV_100MHZ_TO_550HZ 2750000
  `define MASTER_CTLR_CLK_DIV_100MHZ_TO_1KHZ 50000
  
  localparam[27:0] debClkDivDelay = `MASTER_CTLR_CLK_DIV_100MHZ_TO_550HZ;
  localparam[27:0] singlePulseClkDivDelay = `MASTER_CTLR_CLK_DIV_100MHZ_TO_1KHZ;
  
  complexDivider(clk, debClkDivDelay, debClk);
  complexDivider(clk, singlePulseClkDivDelay, singlePulseClk);
  
  debouncer btnLDebouncer(clkDeb, btns[1], btnLDeb);
  debouncer btnRDebouncer(clkDeb, btns[0], btnRDeb);
  
  single_pulse btnLSinglePulser(singlePulseClk, btnLDeb, btnLDebouncedSP);
  single_pulsebtnRSinglePulser(singlePulseClk, btnRDeb, btnRDebouncedSP);
  
  proj5_7seg2 dvrContents(1'b1, dvr[7-:4], dvr[3-:4], clk, an, segs, 4'hf);
  
  assign leds = {empty, dar};
  
  always@() begin 
    case(mode)
      case 0: begin 
        //TODO
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
