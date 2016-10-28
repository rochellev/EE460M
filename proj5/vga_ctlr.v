/*  
  
  VGA controller for lab 5
  Nico Cortes and Rochelle Roberts
  
  This module outputs a pixel color and synchronization signals to the VGA adapter
  of a monitor. The color will fill the entire screen.
  
  INPUTS
    pxlClk25Mhz: A 25MHz clock for generating a vsync and an hsync signal
    
    [2:0]pxl_color: A 3-bit encoding of the color to be displayed
    
  OUTPUTS
    [7:0]R, G , B: The red, green, and blue color saturation levels for the output color
  
    hSync, vSync: signals that synchronize with a VGA monitor's horizontal and vertical scanning
    
    Do: decimal point. Active low.
*/

module vga_ctlr(pxlClk25Mhz, pxl_color, R, G, B, hSync, vSync);
  input pxlClk25Mhz;
  input[2:0] pxl_color;
  output reg[7:0] R, G, B;
  output reg hSync, vSync;
  
  wire[7:0] RInternal, GInternal, BInternal; 
  
  `define VGA_CTLR_HSYNC_BLANK_START 639
  `define VGA_CTLR_HSYNC_DOWN 659
  `define VGA_CTLR_HSYNC_UP 755
  `define VGA_CTLR_HSYNC_MAX 799
  reg[9:0] hSyncCtr;

  `define VGA_CTLR_VSYNC_DOWN 493
  //`define VGA_CTLR_VSYNC_UP 494 - don't need
  `define VGA_CTLR_VSYNC_MAX 524
  reg[9:0] vSyncCtr;  
  
  initial begin 
    hSyncCtr <= 0;
    vSyncCtr <= 0;
  end
  
  colors vga_color(pxl_color, RInternal, GInternal, BInternal);
  
  always@(posedge pxlClk25Mhz) begin
    //hSync
    hSyncCtr <= (hSyncCtr == `VGA_CTLR_HSYNC_MAX)? 0: hSyncCtr + 1;
    hSync <= (hSyncCtr > `VGA_CTLR_HSYNC_DOWN
              && hSyncCtr < `VGA_CTLR_HSYNC_UP)? 0: 1;
    
    //vSync
    if(hSyncCtr == `VGA_CTLR_HSYNC_MAX) begin 
      vSyncCtr <= (vSyncCtr == `VGA_CTLR_VSYNC_MAX)? 0: vSyncCtr + 1;
    end
    vSync <= (vSyncCtr == `VGA_CTLR_VSYNC_DOWN)? 0: 1;
    
    //pxlSync
    {R, G, B} <= (hSyncCtr > `VGA_CTLR_HSYNC_BLANK_START)? {8'h0, 8'h0, 8'h0}
                  : {RInternal, GInternal, BInternal};
  end
endmodule
