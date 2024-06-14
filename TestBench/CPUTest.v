module CPUTest();
    reg clk;
    reg reset;
    reg [7:0] instruction;
    wire LR;

    reg [7:0] memory [15:0];
    integer i=0;
    
    initial begin
        //Enter all the instrucitons wish to execute in a sequence.
	//first 4-bit is the Opcode. Reference the Controller to
	//locate the Opcode of the list of instructions we can run.
        memory[0] = 8'b11010001;
        memory[1] = 8'b01010001;
        memory[2] = 8'b11010010;
        memory[3] = 8'b00010001;
        //memory[4] = 8'b01000001;
        
        for (i = 5; i < 16; i = i + 1) begin
            memory[i] = 8'b00000000; // Initializing the remaining memory elements to zero
        end
    end
    
    CPU test(.clk(clk), .reset(reset), .instruction(instruction), .LoadIRSig(LR));
   
    
    initial begin
        clk=0;
	      forever #50 clk=~clk;
    end

    initial begin
	    reset=1;
	    #10 reset=0;
    end

  integer k=0;
  always @(posedge LR) begin         //Always block that will always execute on positive LR edges.
    instruction=memory[k];           //So every time when LR signal is turned on, we'll load an instruction to IR.
	  k=k+1;
  end

endmodule
