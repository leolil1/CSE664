//Instruction Register is almost exactly the same as register.
//It takes in the instruction from memory, then forward it to controller.
module IR(
  input clk,
  input reset,
  input LoadIR,
  input [7:0] instruction,
  output [7:0] Opcode,
  output reg LoadIRSig         //a Load Instruction signal which will be sent to testbench to load an instruction. 
                               //This will be removed if we have the PC setup.
);
  reg [7:0] storage;
  
  always @(posedge clk, reset)begin
    if (reset==1)
      storage<=8'b0;
    else if(LoadIR)begin
      LoadIRSig<=1;
      storage<=instruction;
    end else begin
	    LoadIRSig<=0;
    end
  end
  
  assign Opcode=storage[7:0];
endmodule
