//Template for CSE320 Lab 2, written initially by TA King and modified by TA Ebrahim and Prof. Arora
//You are free to use this, or implement your own solutions for the problems

//Problem 1
module lab2fsm_behavioral(X, CLK, RST, S, V);
    input X, CLK, RST;
    output reg S, V;
    
    //intermediate register for states
    reg [2:0] Q;
    
	//this code uses the second style of FSM modeling discussed in the lecture.
	//you are welcome to use any other style you prefer.
    //procedural block for next state
    always @ (negedge CLK)
    begin
        //synchronous reset
        if(RST)
        begin
            Q <= ???;
        end

        //finite state machine, can do if/else or switch case
        //both output and state assignment should be done in here, output assignment outside this always block is considered asynchronous
        else
        begin
            case(Q) //Fill in fsm table
                3'd0: ??? //S0
		???
            endcase
        end
    end  
	
	//procedural block for output
    always @ (*)
    begin      
        //finite state machine, can do if/else or switch case
        case(Q) //Fill in fsm table
            3'd0: ??? 
		???
        endcase        
    end  
endmodule


//Problem 1 testbench
module lab2fsm_tb();
    //inputs
    reg X, CLK, RST;
    
    //outputs
    wire S, V;
    
    //instantiate module(s) under test
    ???
    
    //clock generation, provided from lecture slides
    initial
    begin
        CLK = 0;
        forever 
        begin
            #5 CLK = ~CLK; //Clock period is 10 ns, so it "flips" every 5 ns
        end
    end
    
    //intiialization/reset and perform test cases
    initial
    begin //Due to negedge RST, start with RST = 1 first
        RST = 0; #10; RST = 1; #35; RST = 0; #2.5; //Perform reset, wait at least 3 cycles (#35), add some delay padding to align X after rising edge
        X = 1; #10; X= 0; #10; X=1; #10; X=1; #10; //1101
     	//??? Do the same for 1100 and 1011, no need to reset
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
    always @(???)
    begin
        //Asynchronous active-low clear
        if(~CLR)
        begin
            Q <= ???;
        end
        //Implement the behavioral requirements for Q here
        else if(ENABLE)
        begin
            ???
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

