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