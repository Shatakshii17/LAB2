//Problem 2a Testbench
module lab2bcd_1digit_tb();
	// DUT ports
	reg [3:0] D;
	reg ENABLE, LOAD, UP, CLK, CLR;	//CLR is active-low
	wire [3:0] Q;
	wire CO;

	// Instantiate the DUT
	lab2bcd_1digit DUT (
		.D(D),
		.ENABLE(ENABLE),
		.LOAD(LOAD),
		.UP(UP),
		.CLK(CLK),
		.CLR(CLR),
		.Q(Q),
		.CO(CO)
	);

	// 10ns clock
	initial CLK = 0;
	always #5 CLK = ~CLK;

	initial begin
		D = 0; ENABLE = 0; LOAD = 0; UP = 1; CLR = 0;

		#20; CLR = 1;

		// Load 6
		ENABLE = 1; LOAD = 1; D = 4'd6;
		#10; LOAD = 0;	//Q = 6

		// Increment 4 times -> 7, 8, 9, 0 (CO = 1 at 9->0)
		UP = 1;
		#40;

		// Decrement 2 times -> 9, 8 (CO = 1 at 0->9)
		UP = 0;
		#20;

		// Clear
		CLR = 0; #10; CLR = 1;

		#20; $finish;
	end

	// Simple display
	initial begin
		$monitor("t = %0t  |  Q = %d  |  CO = %b  |  EN = %b LOAD = %b UP = %b CLR = %b",
				 $time, Q, CO, ENABLE, LOAD, UP, CLR);
	end
endmodule