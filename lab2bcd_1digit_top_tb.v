
module lab2bcd_1digit_top_tb;
  reg  [3:0] D;
  reg        ENABLE, LOAD, UP, CLK100MHZ, CLR;   // CLR is active-LOW
  wire [3:0] Q;
  wire       CO;

  // DUT (your Problem 3 top)
  lab2bcd_1digit_top UUT (
    .D(D), .ENABLE(ENABLE), .LOAD(LOAD), .UP(UP),
    .CLK100MHZ(CLK100MHZ), .CLR(CLR),
    .Q(Q), .CO(CO)
  );

  // Board clock: 100 MHz
  initial begin
    CLK100MHZ = 0;
    forever #5 CLK100MHZ = ~CLK100MHZ;
  end

  // Fast "fake slow clock" for simulation (e.g., ~12.5 MHz)
  reg simSlowClk;
  initial begin
    simSlowClk = 0;
    forever #40 simSlowClk = ~simSlowClk;  // 80 ns period
  end

  initial begin
    // Init (hold reset low first)
    D = 4'd0; ENABLE = 1'b0; LOAD = 1'b0; UP = 1'b1; CLR = 1'b0;

    // For simulation ONLY: override the internal slow clock so we don't wait seconds
    force UUT.CLK = simSlowClk;

    // Now release reset and enable
    @(posedge simSlowClk);
    CLR    = 1'b1;
    ENABLE = 1'b1;

    // LOAD 3 for one slow tick
    LOAD = 1'b1; D = 4'd3; @(posedge simSlowClk);
    LOAD = 1'b0;

    // Count UP 3 ticks: 3->4->5->6
    repeat (3) @(posedge simSlowClk);

    // Count DOWN 4 ticks: 6->5->4->3->2
    UP = 1'b0;
    repeat (4) @(posedge simSlowClk);

    // Hold for 2 ticks
    ENABLE = 1'b0; repeat (2) @(posedge simSlowClk); ENABLE = 1'b1;

    // Back to UP a few ticks
    UP = 1'b1; repeat (5) @(posedge simSlowClk);

    // (Optional) stop forcing before finish
    release UUT.CLK;

    $finish;
  end

  initial
    $monitor("t=%0t ns  CLR=%b EN=%b LD=%b UP=%b  D=%0d | Q=%0d CO=%b",
             $time, CLR, ENABLE, LOAD, UP, D, Q, CO);
endmodule
