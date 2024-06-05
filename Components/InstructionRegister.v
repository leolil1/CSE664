//Instruction Register is almost exactly the same as register.
//It takes in the instruction from memory, then forward it to controller.
module IR(
  input clk,
  input reset,
  input LoadIR,
  input [7:0] instruction,
  output [7:0] Opcode,
);
  reg [7:0] storage;
  
  always @(posedge clk, reset)begin
    if (reset==1)
      storage<=8'bz;
    else if(LoadIR)
      storage<=instruction;
  end
  
  assign Opcode=storage[7:0];
endmodule
