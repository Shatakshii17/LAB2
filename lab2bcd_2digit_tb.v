`timescale 1ns/1ps

module tb_lab2bcd_2digit;
    // DUT I/O
    reg  [3:0] D1, D2;          // ones, tens (BCD)
    reg        ENABLE, LOAD, UP;
    reg        CLK, CLR;        // CLR is active-low
    wire [3:0] Q1, Q2;          // ones, tens (BCD)
    wire       CO;

    // Instantiate DUT
    lab2bcd_2digit dut (
        .D1(D1),
        .D2(D2),
        .ENABLE(ENABLE),
        .LOAD(LOAD),
        .UP(UP),
        .CLK(CLK),
        .CLR(CLR),
        .Q1(Q1),
        .Q2(Q2),
        .CO(CO)
    );

    // 10 ns clock
    initial CLK = 1'b0;
    always #5 CLK = ~CLK;

    // --- Helpers: drive inputs on negedge for clean timing ---
    task tb_load(input [3:0] tens, input [3:0] ones);
    begin
        @(negedge CLK);
        ENABLE <= 1'b1;
        LOAD   <= 1'b1;
        D2     <= tens;
        D1     <= ones;
        // capture on next posedge
        @(posedge CLK);
        @(negedge CLK);
        LOAD   <= 1'b0; // exit load mode
        D2     <= 4'd0; // D* don't matter when LOAD=0
        D1     <= 4'd0;
    end
    endtask

    // step N clocks with direction up/down (UP=1/0)
    task tb_step(input integer n_steps, input bit up_dir);
        integer i;
    begin
        @(negedge CLK);
        ENABLE <= 1'b1;
        LOAD   <= 1'b0;
        UP     <= up_dir;
        for (i = 0; i < n_steps; i = i + 1) begin
            @(posedge CLK);
        end
    end
    endtask

    // idle for N clocks (no counting)
    task tb_idle(input integer n_cycles);
        integer i;
    begin
        @(negedge CLK);
        ENABLE <= 1'b0;
        LOAD   <= 1'b0;
        for (i = 0; i < n_cycles; i = i + 1) begin
            @(posedge CLK);
        end
    end
    endtask

    // async clear pulse (active-low)
    task tb_clear_min3cycles;
    begin
        @(negedge CLK);
        CLR <= 1'b0;
        // >= 3 cycles per lab
        repeat (3) @(posedge CLK);
        @(negedge CLK);
        CLR <= 1'b1;
    end
    endtask

    // --- Monitor / pretty print ---
    function [7:0] as_decimal; // returns 8-bit decimal 00..99 for display (not used in logic)
        input [3:0] t;
        input [3:0] o;
        begin
            as_decimal = (t * 8'd10) + o;
        end
    endfunction

    initial begin
        $display(" time | CLR EN LD UP | D2 D1 | Q2 Q1 |  CO | dec(Q)");
        $monitor("%5t |  %b   %b  %b  %b |  %1d  %1d |  %1d  %1d |  %b  |   %0d",
                 $time, CLR, ENABLE, LOAD, UP, D2, D1, Q2, Q1, CO, as_decimal(Q2, Q1));
    end

    // --- Stimulus ---
    initial begin
        // defaults
        D1=0; D2=0; ENABLE=0; LOAD=0; UP=1; CLR=0;

        // Global reset (>=3 cycles)
        repeat (4) @(posedge CLK);
        CLR = 1'b1;
        @(posedge CLK);

        // -------------------------------------------------------
        // Sequence 1:
        // 1) Load 97
        // 2) Increment 3 times
        // 3) Decrement 4 times
        // 4) Idle 2 cycles
        // Expect Q*: 98 -> 99 -> 99 -> 98 -> 97 -> 96 -> 95 -> 95 -> 95
        // -------------------------------------------------------
        tb_load(4'd9, 4'd7);           // 97
        tb_step(3, /*UP=*/1);          // +3
        tb_step(4, /*UP=*/0);          // -4
        tb_idle(2);                    // hold

        // Clear
        tb_clear_min3cycles;

        // -------------------------------------------------------
        // Sequence 2:
        // 1) Load 02
        // 2) Decrement 3 times
        // 3) Increment 4 times
        // 4) Idle 2 cycles
        // Expect Q*: 01 -> 00 -> 00 -> 01 -> 02 -> 03 -> 04 -> 04 -> 04
        // -------------------------------------------------------
        tb_load(4'd0, 4'd2);           // 02
        tb_step(3, /*UP=*/0);          // -3
        tb_step(4, /*UP=*/1);          // +4
        tb_idle(2);                    // hold

        // Clear
        tb_clear_min3cycles;

        // -------------------------------------------------------
        // Sequence 3:
        // 1) Load 42
        // 2) Decrement 3 times
        // 3) Increment 4 times
        // 4) Idle 2 cycles
        // Expect Q*: 41 -> 40 -> 39 -> 40 -> 41 -> 42 -> 43 -> 43 -> 43
        // -------------------------------------------------------
        tb_load(4'd4, 4'd2);           // 42
        tb_step(3, /*UP=*/0);          // -3
        tb_step(4, /*UP=*/1);          // +4
        tb_idle(2);                    // hold

        // Done
        @(posedge CLK);
        $finish;
    end
endmodule
