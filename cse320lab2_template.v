//Template for CSE320 Lab 2, written initially by TA King and modified by TA Ebrahim and Prof. Arora
//You are free to use this, or implement your own solutions for the problems

//Problem 1
module lab2fsm_behavioral(X, CLK, RST, S, V);
    input X, CLK, RST;
    output reg S, V;
    
    //intermediate register for states
    reg [2:0] Q;
    
	parameter S0 = 3'd0;  // Initial state
    parameter S1 = 3'd1;  
    parameter S2 = 3'd2;  
    parameter S3 = 3'd3;  
    parameter S4 = 3'd4;  
    parameter S5 = 3'd5; 
    parameter S6 = 3'd6; 
    parameter S7 = 3'd7;  // Received '1011' (valid sequence)
	
    always @ (negedge CLK)
    begin
      
        if(RST)
        begin
             Q <= S0;
        end

        //finite state machine, can do if/else or switch case
        //both output and state assignment should be done in here, output assignment outside this always block is considered asynchronous
        else
        begin
            case(Q)
                S0: begin  // Present State S0
                    if(X) Q <= S2;  // X=1 -> Next State S2
                    else Q <= S1;   // X=0 -> Next State S1
                end
                
                S1: begin  // Present State S1
                    if(X) Q <= S4;  // X=1 -> Next State S4
                    else Q <= S3;   // X=0 -> Next State S3
                end
                
                S2: begin  // Present State S2
                    if(X) Q <= S4;  // X=1 -> Next State S4
                    else Q <= S4;   // X=0 -> Next State S4
                end
                
                S3: begin  // Present State S3
                    if(X) Q <= S5;  // X=1 -> Next State S5
                    else Q <= S5;   // X=0 -> Next State S5
                end
                
                S4: begin  // Present State S4
                    if(X) Q <= S6;  // X=1 -> Next State S6
                    else Q <= S5;   // X=0 -> Next State S5
                end
                
                S5: begin  // Present State S5
                    if(X) Q <= S0;  // X=1 -> Next State S0
                    else Q <= S0;   // X=0 -> Next State S0
                end
                
                S6: begin  // Present State S6
                    if(X) Q <= S0;  // X=1 -> Next State S0
                    else Q <= S0;   // X=0 -> Next State S0
                end
                
                default: Q <= S0;  // Default case
            endcase
        end
    
	//procedural block for output
     always @ (*)
    begin      
        case(Q)
            S0: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            S1: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            S2: begin S = 0; V = 1; end  // Output (S,V) = (0,1)
            S3: begin S = 0; V = 1; end  // Output (S,V) = (0,1)
            S4: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            S5: begin S = 0; V = 1; end  // Output (S,V) = (0,1)
            S6: begin S = 1; V = 0; end  // Output (S,V) = (1,0) - Note: Last bit has V=1 according to table
            default: begin S = 0; V = 0; end
        endcase        
    end  
endmodule


module lab2fsm_tb();
    //inputs
    reg X, CLK, RST;
    
    //outputs
    wire S, V;
    
    //instantiate module under test
    lab2fsm_behavioral DUT (
        .X(X),
        .CLK(CLK),
        .RST(RST),
        .S(S),
        .V(V)
    );
    
    //clock generation
    initial
    begin
        CLK = 0;
        forever 
        begin
            #5 CLK = ~CLK; //Clock period is 10 ns
        end
    end
    
    //initialization/reset and perform test cases
    initial
    begin
        // Monitor outputs
        $monitor("Time: %0t, RST: %b, X: %b, State: %d, S: %b, V: %b", 
                 $time, RST, X, UUT.Q, S, V);
        
        //Reset sequence
        RST = 0; #10; RST = 1; #35; RST = 0; #2.5;
        
        // Test sequence X = 1011 1100 1101 (from problem description)
        // This represents: 11 (binary) -> 14 (decimal) -> should output Excess-3
        X = 1; #10; X = 0; #10; X = 1; #10; X = 1; #10; // 1011
        
        // Test sequence 1100 
        X = 1; #10; X = 1; #10; X = 0; #10; X = 0; #10; // 1100
        
        // Test sequence 1101
        X = 1; #10; X = 1; #10; X = 0; #10; X = 1; #10; // 1101
        
        #50;
        $finish;
    end
endmodule
		
//Problem 2a
module lab2bcd_1digit(D, ENABLE, LOAD, UP, CLK, CLR, Q, CO);
	input [3:0] D;
    input ENABLE, LOAD, UP, CLK, CLR;
    
	output reg [3:0] Q;
    output reg CO;
    
    //Synchronous counter
    //This implementation assumes it will be used in a 2-digit BCD
    //Additional logic will be implemented in the top-level module (2-digit BCD) to prevent it from going below 0 or above 99
	always @(posedge CLK)
    begin
        //Asynchronous active-low clear
        if(~CLR)
        begin
            Q <= 4'd0;
        end
        //Implement the behavioral requirements for Q here
        else if(ENABLE)
        begin
			if (LOAD) 
			begin
				Q <= D;
			end
			else if(UP)
			begin
				case(Q):
					4'd9: Q <= 4'd0;
					default: Q <= Q + 4'd1;
				endcase
			end
			else
			begin
				case(Q)
					4'd0: Q <= 4'd9;
					default: Q <= Q - 4'd1;
				endcase
			end
        end
    end
    
    //To model correct behavior for 2-digit BCD, CO can be asynchronous with respect to clock
    //This is just one way to do it, there's other ways to implement the CO logic
    always @(*)
    begin    
        //Asynchronous active-low clear
        if(~CLR)
        begin
            CO = 1'b0;
        end
        //Implement the behavioral requirements for CO here
        else if(ENABLE)
        begin
			if(UP && (Q == 4'd9))	// about to roll over 9->0
				CO = 1'b1;
			else if(!UP && (Q == 4'd0)) 	// about to roll over 0->9
				CO = 1'b1;
			else
				CO = 1'b0;
        end
		else
		begin
			CO = 1'b0;
		end
    end
endmodule

		
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
	
		
//Problem 2b
//Let D2 and Q2 be defined as the ten's place, or 2nd digit, so for 98, D2 = 9
module lab2bcd_2digit(D1, D2, ENABLE, LOAD, UP, CLK, CLR, Q1, Q2, CO);
    input [3:0] D1, D2;
    input ENABLE, LOAD, UP, CLK, CLR;
    
    output [3:0] Q1, Q2;
    output reg CO;
    
    //Intermediate logic variable(s)
    reg ENABLE_1, ENABLE_2, ENABLE_OVERRIDE, UP_2;
    // Internal wires from digit modules
    wire [3:0] q1_w, q2_w;
    wire co1_w, co2_w;
    
    //module instantiations
   lab2bcd_1digit U_DIGIT1 ( // ones digit
        .D(D1),
        .ENABLE(ENABLE_1),
        .LOAD(LOAD),
        .UP(UP),
        .CLK(CLK),
        .CLR(CLR),
        .Q(q1_w),
        .CO(co1_w)
    );

	 lab2bcd_1digit U_DIGIT2 ( // tens digit
        .D(D2),
        .ENABLE(ENABLE_2),
        .LOAD(LOAD),
        .UP(UP_2),
        .CLK(CLK),
        .CLR(CLR),
        .Q(q2_w),
        .CO(co2_w)
    );

	// Drive top-level Qs from internal wires
    assign Q1 = q1_w;
    assign Q2 = q2_w;

    //Intermediate logic procedural block
    //This is just one way to do it, there's other ways to implement the intermediate logic
    //Cases to consider include:
    //Stopping the counter when Q = 0 and UP = 0 or Q = 99 and UP = 1
    //Enabling the 2nd digit counter during load
    //Setting the UP for the 2nd digit depending if its going from 0 -> 9 or 9 -> 0 
    always @(*)
    begin
        if(((Q2 == 4'd0 & Q1 == 4'd0) & UP == 1'd0) || 
		((Q2 == 4'd9 && Q1 == 4'd9) && (UP == 1'd1))) begin
            ENABLE_OVERRIDE = 1'd0;
            CO = 1'd1;
        end		
		else begin
			ENABLE_OVERRIDE = 1'd1;
            CO = 1'd0;
		end

	ENABLE_1 = (ENABLE & ENABLE_OVERRIDE) | (ENABLE & LOAD); //ENABLE for 1st digit
	ENABLE_2 = (( (UP && (Q1 == 4'd9)) || (!UP && (Q1 == 4'd0)) ) & ENABLE_OVERRIDE)
    | (ENABLE & LOAD); //ENABLE for 2nd digit
	UP_2 = (UP && 1'b1); //UP for 2nd digit
    end
    
endmodule

//Clock divider
module simpleDivider(clk100Mhz, slowClk, CLR);
    input clk100Mhz; //fast clock
    output slowClk; //slow clock
	input CLR;
    reg [27:0] counter;
    
    assign slowClk = counter[27]; //(2^27 / 100E6) = 1.34seconds
       
    always @ (posedge clk100Mhz or negedge CLR)
    begin
	    if (~CLR) begin
		    counter <= 0;
		end else begin
            counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
		end
    end
endmodule

//TestBench 2b
		always @(*) begin
    // Only consider CO (and saturation hold) while actively counting (not loading)
    // counting = ENABLE & !LOAD
    if ( (ENABLE & !LOAD) &&
         ( ((Q2 == 4'd0) && (Q1 == 4'd0) && (UP == 1'b0)) ||
           ((Q2 == 4'd9) && (Q1 == 4'd9) && (UP == 1'b1)) ) ) begin
        ENABLE_OVERRIDE = 1'b0;   // stop at 00 or 99
        CO = 1'b1;                // indicate saturation attempt
    end else begin
        ENABLE_OVERRIDE = 1'b1;
        CO = 1'b0;
    end

    // Ones digit: count when enabled and not saturating, or load when ENABLE&LOAD
    ENABLE_1 = (ENABLE & ENABLE_OVERRIDE) | (ENABLE & LOAD);

    // Tens digit: load with ENABLE&LOAD, OR step only on a ones-roll event,
    // and only when globally ENABLED and not saturating.
    //  - UP: step tens when ones is 9 (will roll 9->0)
    //  - DOWN: step tens when ones is 0 (will roll 0->9)
    // IMPORTANT: include ENABLE in the roll term to avoid stepping while disabled.
    ENABLE_2 = (ENABLE & LOAD) |
               (ENABLE & ENABLE_OVERRIDE &
                 ( (UP  && (Q1 == 4'd9)) ||
                   (!UP && (Q1 == 4'd0)) ));

    // Tens direction: same as UP (ENABLE_2 gating ensures it only applies on roll)
    UP_2 = UP;
end

		

//Problem 3
module lab2bcd_1digit_top(D, ENABLE, LOAD, UP, CLK100MHZ, CLR, Q, CO);
    input [3:0] ???;
    input ???;
    
    output [3:0] ???;
    output ???;
    
    wire CLK;
    
    //module instantiation
    simpleDivider clkdiv(???, CLK, CLR); //Read the simpleDivider module to see what it takes as an input
    lab2bcd_1digit BCD1(???);
endmodule









