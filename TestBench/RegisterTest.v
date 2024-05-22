module RegisterTest();
  reg clk;
  reg reset;
  reg LoadReg;
  reg DumpReg;
  reg [7:0] in;
  wire [7:0] out;
  wire [7:0] out_alu;

   
  Register MUT(clk, reset, LoadReg, DumpReg, in, out, out_alu);
	
	always #5 clk = ~clk;
    initial
    begin
        clk=0;
        #5 reset = 1'b0;

	      #20 LoadReg = 1'b1;
	       in=8'b11001111;

	      #5 DumpReg = 1'b1;
    end
endmodule
