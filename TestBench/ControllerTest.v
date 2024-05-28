module ControllerTest();
  reg clk, reset;
  reg [3:0] Opcode;
  wire LoadIR, IncPC, SelPC, LoadPC, LoadReg, LoadAcc;
  wire [1:0] SelAcc;
  wire [3:0] SelALU;

    // Correct module instantiation line
    Controller MUT(clk, reset, Opcode, LoadIR, IncPC, SelPC, LoadPC, LoadReg, LoadAcc, SelAcc, SelALU);
	
  always #5 clk = ~clk;
    initial
    begin
        clk=0;
        reset = 1'b0;
        #5 reset = 1'b1;
	      #5 reset = 1'b0;
        

        Opcode=4'b0001;
        #30 Opcode=4'b0010;
	
    end
endmodule
