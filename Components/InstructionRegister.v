//Instruction Register is almost exactly the same as register.
//Only difference is it does not have a write enable like Dump Reg singnal as IR is supposed to continuously sending data to Controller. No exception.
//Another difference is the 8-bit output is split up to 4-bit each. The first 4-bit will be the Opcode which will be sent to Controller. The last 4-bit is the immediate data.
module IR(
  input clk,
  input reset,
  input LoadIR,
  input [7:0] instruction,
  output [3:0] Opcode,
  output [3:0] Immediate_data
);
  reg [7:0] storage;
  
  always @(posedge clk, reset)begin
    if (reset==1)
      storage<=8'bz;
    else if(LoadIR)
      storage<=instruction;
  end
  
  assign Opcode=storage[7:4];
  assign Immediate_data=storage[3:0];
endmodule
