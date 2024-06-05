module RegisterTest();
  reg clk;
  reg reset;
  reg LoadReg;
  reg DumpReg;
  reg [3:0] RegNumber;
  reg [7:0] in;
  wire [7:0] out;
  wire [7:0] out_alu;

    // Correct module instantiation line
    RegisterFile MUT(clk, reset, LoadReg, DumpReg, RegNumber, in, out, out_alu);
	
    always #10 clk = ~clk;
    initial
    begin
        clk=0;
        reset = 1'b1;
	#5reset = 1'b0;

	#5LoadReg = 1'b1;
	 in=8'b11001100;
	 RegNumber=4'b0001;
	#5 DumpReg = 1'b1;

	#5LoadReg = 1'b1;
	 in=8'b11110000;
	 RegNumber=4'b1111;
	#5 DumpReg = 1'b1;
	
    end
endmodule
