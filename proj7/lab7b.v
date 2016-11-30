// You can use this skeleton testbench code, the textbook testbench code, or your own
module MIPS_Testbench ();
  reg CLK;
  reg RST;
  reg HALT;
  wire CS;
  wire WE;
  
  wire[7:0] reg1;
  
  wire [31:0] Mem_Bus;
  wire [6:0] Address;
  
  integer i;

  parameter N = 10; 
  reg[31:0] expected[N:1];  
  
  initial
  begin
    CLK = 0;
    
    expected[1] = 32'h00000006; // $1 content=6 decimal 
    expected[2] = 32'h00000012; // $2 content=18 decimal 
    expected[3] = 32'h00000018; // $3 content=24 decimal 
    expected[4] = 32'h0000000C; // $4 content=12 decimal 
    expected[5] = 32'h00000002; // $5 content=2 
    expected[6] = 32'h00000016; // $6 content=22 decimal
    expected[7] = 32'h00000001; // $7 content=1 
    expected[8] = 32'h00000120; // $8 content=288 decimal 
    expected[9] = 32'h00000003; // $9 content=3 
    expected[10] = 32'h00412022; // $10 content=5th instr
  end

  MIPS CPU(CLK, RST, HALT, CS, WE, Address, Mem_Bus, reg1);
  Memory MEM(CS, WE, CLK, Address, Mem_Bus);

  always
  begin
    #5 CLK = !CLK;
  end

  always
  begin
    RST <= 1'b1; //reset the processor
    HALT <= 0;

    //Notice that the memory is initialize in the in the memory module not here

    /* add your testing code here */
    // you can add in a 'Halt' signal here as well to test Halt operation
    // you will be verifying your program operation using the
    // waveform viewer and/or self-checking operations
    $display("TEST BEGIN");
    // @(posedge CLK); //wait until posedge CLK 
      // //Initialize the instructions from the testbench 
      // init <= 1; CS_TB <= 1; WE_TB <= 1; 
    // @(posedge CLK); 
      // CS_TB <= 0; WE_TB <= 0; init <= 0;
    @(posedge CLK); 
      RST <= 0;
      for(i = 1; i <= N; i = i+1) begin 
        @(posedge WE); // When a store word is executed 
        @(negedge CLK);   
          if (Mem_Bus != expected[i])
            $display("Output mismatch: got %d, expect %d", Mem_Bus, expected[i]);
          else
            $display("Output match: got %d, expect %d", Mem_Bus, expected[i]);
      end
      
    $display("TEST COMPLETE");
    $stop;
  end

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Complete_MIPS(CLK, sw2, sw1, sw0, btnl, btnr, an, segs);
  // Will need to be modified to add functionality
  input CLK;
  input sw2, sw1, sw0, btnl, btnr;
  output[3:0] an;
  output[6:0] segs;
  wire decimalPt;

  wire debBtnl, debBtnr;

  `define COMPLETE_MIPS_CLK_DIV_DELAY_100MHZ_TO_550HZ 275000
  localparam[27:0] debClkDivDelay = `COMPLETE_MIPS_CLK_DIV_DELAY_100MHZ_TO_550HZ;
  wire debClk;
  
  `define COMPLETE_MIPS_CLK_DIV_DELAY_100MHZ_TO_50MHZ 1
  localparam[27:0] mipsClkDivDelay = `COMPLETE_MIPS_CLK_DIV_DELAY_100MHZ_TO_50MHZ;
  wire mipsClk;
  
  wire CS, WE;
  wire [6:0] ADDR;
  wire [31:0] mem_bus;
  
  wire[3:0] hex0, hex1, hex2, hex3;
  
  complexDivider clkDivDeb(CLK, debClkDivDelay, debClk);
  complexDivider clkDivMips(CLK, mipsClkDivDelay, mipsClk);
  
  debouncer deb_btnl(debClk, btnl, debBtnl);
  debouncer deb_btnr(debClk, btnr, debBtnr);
  
  //module proj4_7seg4(en7Seg, bcd0, bcd1, bcd2, bcd3, clk, anodes, segs, decimalPt);
  proj4_7seg4 sevenSeg4(1'b1, hex0, hex1, hex2, hex3, CLK, an, segs, decimalPt);
  MIPS CPU(mipsClk, sw0, sw1, sw2, debBtnl, debBtnr, CS, WE, ADDR, mem_bus, hex0, hex1, hex2, hex3);
  Memory MEM(CS, WE, CLK, ADDR, mem_bus);

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Memory(CS, WE, CLK, ADDR, Mem_Bus);
  input CS;
  input WE;
  input CLK;
  input [6:0] ADDR;
  inout [31:0] Mem_Bus;

  reg [31:0] data_out;
  reg [31:0] RAM [0:127];


  initial
  begin
    $readmemh("c:/Users/Neeks/Desktop/EE460M/proj7/lab7b.hex", RAM);
  end

  assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out;

  always @(negedge CLK)
  begin

    if((CS == 1'b1) && (WE == 1'b1))
      RAM[ADDR] <= Mem_Bus[31:0];

    data_out <= RAM[ADDR];
  end
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

//REG Register(CLK, regw, dr, `sr1, `sr2, reg_in, {29'h0, sw2, sw1, sw0}, reg2, upper, readreg1, readreg2, displayReg);
module REG(CLK, RegW, DR, SR1, SR2, Reg_In, reg1, reg2, upper, ReadReg1, ReadReg2, displayReg);
  input CLK;
  input RegW;
  input [4:0] DR;
  input [4:0] SR1;
  input [4:0] SR2;
  input [31:0] Reg_In;
  output reg [31:0] ReadReg1;
  output reg [31:0] ReadReg2;

  input[31:0] reg1;
  
  input reg2, upper;
  
  output reg[15:0] displayReg;
  
  //reg reg2Reg, upperReg;
  
  reg [31:0] REG [0:31];
  integer i;

  initial begin
    ReadReg1 = 0;
    ReadReg2 = 0;
  end
  
  always@(posedge CLK) begin
    case({reg2, upper}) 
      0: begin 
        displayReg <= REG[3][15:0];
      end
      
      1: begin 
        displayReg <= REG[3][31:16];
      end
      
      2: begin 
        displayReg <= REG[2][15:0];
      end
      
      3: begin 
        displayReg <= REG[2][31:16];
      end
    endcase
  end
  
  always @(posedge CLK)
  begin
    REG[1] <= reg1[31:0];
    if(RegW == 1'b1) begin
      REG[DR] <= Reg_In[31:0];
    end 

    ReadReg1 <= REG[SR1];
    ReadReg2 <= REG[SR2];
  end
endmodule


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`define opcode instr[31:26]
`define sr1 instr[25:21]
`define sr2 instr[20:16]
`define f_code instr[5:0]
`define numshift instr[10:6]

module MIPS(CLK, sw0, sw1, sw2, btnl, btnr, CS, WE, ADDR, Mem_Bus, hex0, hex1, hex2, hex3);
  input CLK;
  input sw0, sw1, sw2;
  input btnl, btnr;
  output reg CS, WE;
  output [6:0] ADDR;
  output[3:0] hex0, hex1, hex2, hex3;
  inout [31:0] Mem_Bus;

  reg sw0Reg = 0, sw1Reg = 0, sw2Reg = 0;
  reg btnlReg = 0, btnrReg = 0;
  
  //special instructions (opcode == 000000), values of F code (bits 5-0):
  parameter add = 6'b100000;
  parameter sub = 6'b100010;
  parameter xor1 = 6'b100110;
  parameter and1 = 6'b100100;
  parameter or1 = 6'b100101;
  parameter slt = 6'b101010;
  parameter srl = 6'b000010;
  parameter sll = 6'b000000;
  parameter jr = 6'b001000;
  //additional special instructions
  parameter add8 = 6'b101101;
  parameter mult = 6'b011000;
  parameter mfhi = 6'b010000;
  parameter mflo = 6'b010010;
  parameter rbit = 6'b101111;
  parameter rev  = 6'b110000;
  parameter sadd = 6'b110001;
  parameter ssub = 6'b110010;
  
  //non-special instructions, values of opcodes:
  parameter addi = 6'b001000;
  parameter andi = 6'b001100;
  parameter ori = 6'b001101;
  parameter lw = 6'b100011;
  parameter sw = 6'b101011;
  parameter beq = 6'b000100;
  parameter bne = 6'b000101;
  parameter j = 6'b000010;

  //additional instructions  
  //non-special
  parameter jal = 6'b000011;
  parameter lui = 6'b001111;

  
  //instruction format
  parameter R = 2'd0;
  parameter I = 2'd1;
  parameter J = 2'd2;

  //internal signals
  reg [5:0] op, opsave;
  wire [1:0] format;
  reg [31:0] instr, alu_result;
  reg [6:0] pc, npc, savePc, incPc;
  wire [31:0] imm_ext, alu_in_A, alu_in_B, reg_in, readreg1, readreg2;
  reg [31:0] alu_result_save;
  reg alu_or_mem, alu_or_mem_save, regw, writing, reg_or_imm, reg_or_imm_save;
  reg fetchDorI;
  wire [4:0] dr;
  reg [2:0] state, nstate;
  reg wMult;
  reg[31:0] HI, LO, saveHI, saveLO;
  reg[5:0] index;
  
  reg reg2, upper;
  wire[15:0] displayReg;
  wire[31:0] reg1;
  always@(posedge CLK) begin 
    sw0Reg <= sw0;
    sw1Reg <= sw1;
    sw2Reg <= sw2;
    btnlReg <= btnl;
    btnrReg <= btnr;
    if(!(sw0Reg || sw1Reg || sw2Reg)) begin 
      case({btnlReg, btnrReg})
        0: begin 
          reg2 <= 1;
          upper <= 0;
        end
        
        1: begin 
          reg2 <= 1;
          upper <= 1;
        end
        
        2: begin 
          reg2 <= 0;
          upper <= 0;
        end
          
        3: begin 
          reg2 <= 0;
          upper <= 1;
        end
      endcase
    end else begin 
      reg2 <= 1;
      if(btnrReg) begin 
        upper <= 1;
      end else begin 
        upper <= 0;
      end
    end
  end
  
  assign {hex3, hex2, hex1, hex0} = displayReg;
  
  //combinational
  assign imm_ext = (instr[15] == 1)? {16'hFFFF, instr[15:0]} : {16'h0000, instr[15:0]};//Sign extend immediate field
  assign dr = (format == R)? ((`f_code == rev)||(`f_code == rbit) ? `sr1 : instr[15:11]) : ((`opcode == jal) ? 5'd31 : instr[20:16]); //Destination Register MUX (MUX1)
  assign alu_in_A = readreg1;
  assign alu_in_B = (reg_or_imm_save)? imm_ext : readreg2; //ALU MUX (MUX2)
  assign reg_in = (alu_or_mem_save)? Mem_Bus : ((`opcode == jal) ? {25'b0, pc}: alu_result_save); //Data MUX
  assign format = (`opcode == 6'd0)? R : (((`opcode == 6'd2) || (`opcode == jal))? J : I);
  assign Mem_Bus = (writing)? readreg2 : 32'bZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ; 
  
  //drive memory bus only during writes
  assign ADDR = (fetchDorI)? pc : alu_result_save[6:0]; //ADDR Mux
  
  assign reg1 = {29'b0, sw2, sw1, sw0};
  REG Register(CLK, regw, dr, `sr1, `sr2, reg_in, reg1, reg2, upper, readreg1, readreg2, displayReg);

  initial begin
    op = and1; opsave = and1;
    state = 3'b0; nstate = 3'b0;
    alu_or_mem = 0;
    regw = 0;
    fetchDorI = 0;
    writing = 0;
    reg_or_imm = 0; reg_or_imm_save = 0;
    alu_or_mem_save = 0;
  end

  always @(*)
  begin
    fetchDorI = 0; CS = 0; WE = 0; regw = 0; writing = 0; alu_result = 32'd0;
    npc = pc; op = jr; reg_or_imm = 0; alu_or_mem = 0; nstate = 3'd0; HI = 0; LO = 0; wMult = 0;
    case (state)
      0: begin //fetch
        npc = pc + 7'd1; CS = 1; nstate = 3'd1;
        fetchDorI = 1;
      end
      1: begin //decode
        nstate = 3'd2; reg_or_imm = 0; alu_or_mem = 0;
        if (format == J) begin //jump, and finish
          npc = instr[6:0];
          nstate = 3'd0;
          if(`opcode == jal)
            regw = 1; 
        end
        else if (format == R) //register instructions
          op = `f_code;
        else if (format == I) begin //immediate instructions
          reg_or_imm = 1;
          if(`opcode == lw) begin
            op = add;
            alu_or_mem = 1;
          end
          else if ((`opcode == lw)||(`opcode == sw)||(`opcode == addi)) op = add;
          else if ((`opcode == beq)||(`opcode == bne)) begin
            op = sub;
            reg_or_imm = 0;
          end
          else if (`opcode == andi) op = and1;
          else if (`opcode == ori) op = or1;
        end
      end
      2: begin //execute
        nstate = 3'd3;
        if (opsave == and1) alu_result = alu_in_A & alu_in_B;
        else if (opsave == or1) alu_result = alu_in_A | alu_in_B;
        else if (opsave == add) alu_result = alu_in_A + alu_in_B;
        else if (opsave == sub) alu_result = alu_in_A - alu_in_B;
        else if (opsave == srl) alu_result = alu_in_B >> `numshift;
        else if (opsave == sll) alu_result = alu_in_B << `numshift;
        else if (opsave == slt) alu_result = (alu_in_A < alu_in_B)? 32'd1 : 32'd0;
        else if (opsave == xor1) alu_result = alu_in_A ^ alu_in_B;        
        else if(opsave == mult) begin 
          {HI,LO} = alu_in_A * alu_in_B;
          wMult = 1;
        end
        else if(opsave == mfhi) alu_result = saveHI;
        else if(opsave == mflo) alu_result = saveLO;
        else if(opsave == add8) alu_result = {alu_in_A[31:24] + alu_in_B[31:24],
                                              alu_in_A[23:16] + alu_in_B[23:16],
                                              alu_in_A[15:8] + alu_in_B[15:8],
                                              alu_in_A[7:0] + alu_in_B[7:0]};
        else if(opsave == rbit) begin 
          for(index = 0; index < 32; index = index + 1) begin
            alu_result[index] = alu_in_B[31 - index];
          end
        end
        else if(opsave == rev) alu_result = {alu_in_B[7:0], alu_in_B[15:8],
                                             alu_in_B[23:16], alu_in_B[31:24]};
        else if(opsave == sadd) alu_result = ({1'b0, alu_in_A + alu_in_B} > 33'h0ffffffff) ? 32'hffffffff : alu_in_A + alu_in_B;
        else if(opsave == ssub) alu_result = ((alu_in_A - alu_in_B > 0) && (alu_in_B > alu_in_A)) ? 0 : alu_in_A - alu_in_B;
        
        if (((alu_in_A == alu_in_B)&&(`opcode == beq)) || ((alu_in_A != alu_in_B)&&(`opcode == bne))) begin
          npc = pc + imm_ext[6:0];
          nstate = 3'd0;
        end
        else if ((`opcode == bne)||(`opcode == beq)) nstate = 3'd0;
        else if(`opcode == lui)
          alu_result = {alu_in_B[15:0], 16'b0};
        else if (opsave == jr) begin  
          npc = alu_in_A[6:0];
          nstate = 3'd0;
        end
      end
      3: begin //prepare to write to mem
        nstate = 3'd0;
        if ((format == R)||(`opcode == addi)||(`opcode == andi)||(`opcode == ori)||(`opcode == lui)) regw = 1;
        else if (`opcode == sw) begin
          CS = 1;
          WE = 1;
          writing = 1;
        end
        else if (`opcode == lw) begin
          CS = 1;
          nstate = 3'd4;
        end
      end
      4: begin
        nstate = 3'd0;
        CS = 1;
        if (`opcode == lw) regw = 1;
      end
    endcase
  end //always

  always @(posedge CLK) begin
    state <= nstate;
    pc <= npc;
    
    if(wMult)
      {saveHI, saveLO} <= {HI, LO};
    
    if (state == 3'd0) instr <= Mem_Bus;
    else if (state == 3'd1) begin
      opsave <= op;
      reg_or_imm_save <= reg_or_imm;
      alu_or_mem_save <= alu_or_mem;
    end
    else if (state == 3'd2) alu_result_save <= alu_result;

  end //always

endmodule
