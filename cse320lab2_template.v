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
    lab2fsm_behavioral UUT (
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
            CO = ???;
        end
        //Implement the behavioral requirements for CO here
        else if(ENABLE)
        begin
            ???
        end
    end
endmodule

//Problem 2b
//Let D2 and Q2 be defined as the ten's place, or 2nd digit, so for 98, D2 = 9
module lab2bcd_2digit(D1, D2, ENABLE, LOAD, UP, CLK, CLR, Q1, Q2, CO);
    input [3:0] ???;
    input ???;
    
    output [3:0] ???;
    output reg ???;
    
    //Intermediate logic variable(s)
    reg ENABLE_1, ENABLE_2, ENABLE_OVERRIDE, UP_2;
    ???
    
    //module instantiations
    ???
    
    //Intermediate logic procedural block
    //This is just one way to do it, there's other ways to implement the intermediate logic
    //Cases to consider include:
    //Stopping the counter when Q = 0 and UP = 0 or Q = 99 and UP = 1
    //Enabling the 2nd digit counter during load
    //Setting the UP for the 2nd digit depending if its going from 0 -> 9 or 9 -> 0 
    always @(*)
    begin
        if(((Q2 == 4'd0 & Q1 == 4'd0) & UP == 1'd0) || (????????)) begin
            ENABLE_OVERRIDE = 1'd0;
            CO = 1'd1;
        end		
		else begin
			ENABLE_OVERRIDE = 1'd1;
            CO = 1'd0;
		end

	ENABLE_1 = (ENABLE & ENABLE_OVERRIDE) | (??? & ???); //ENABLE for 1st digit
	ENABLE_2 = (??? & ENABLE_OVERRIDE) | (ENABLE & ???); //ENABLE for 2nd digit
	UP_2 = (??? && ???); //UP for 2nd digit
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





