//`include "spi_defines.v"
`define SPI_DIVIDER_LEN      5  // Can be set from 1 to 8
module spi_clgen_tb;

  // Define the signals for the clock generator module
  reg wb_clk_in;
  reg wb_rst;
  reg go;
  reg tip;
  reg last_clk;
  wire sclk_out;
  wire cpol_0;
  wire cpol_1;
//  reg [`SPI_DIVIDER_LEN-1:0]    divider;
  real divider;
  real cnt;

  // Instantiate the Device Under Test (DUT)
  spi_clgen dut (
    .wb_clk_in(wb_clk_in),
    .wb_rst(wb_rst),
    .go(go),
    .tip(tip),
    .last_clk(last_clk),
    .divider(divider),
    .sclk_out(sclk_out),
    .cpol_0(cpol_0),
    .cpol_1(cpol_1)
  );

  // Clock generation
  always begin
    #5 wb_clk_in = ~wb_clk_in; // Toggle the clock every 5 time units
  end

  // Initialize signals
  initial begin
    wb_clk_in <= 0; wb_rst <= 1;
    #13;
    wb_rst <= 0; divider <= 0.5; tip <= 0; go <= 0;
    //div freq       T.P
    //1   25MHz      40  4
    //2   16.66MHz   60  6
    //3   12.5 MHz   80  8
    //4   10MHz     100  10
    //5   8.33MHz   120
    //6   7.14MHz   140
    //7   6.25MHz   160
    //
    //1/(T.P) *nS
    
    
    // f = 1/[[(2* Divider) + 2] *nS]
    // 33MHz 
    #17;
    go <= 1;
    #10;
    tip <= 1;last_clk <= 0;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
    #2000 $finish;
  end

endmodule
