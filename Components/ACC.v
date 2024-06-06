//ACC is exactly the same as a register. Reference Register for more comments.
module ACC(
  input clk,
  input reset,
  input LoadAcc,
  input DumpAcc,
  input [7:0] in,
  output [7:0] out_reg,
  output [7:0] out_alu
);
  reg [7:0] storage;      
  
  always @(posedge clk, reset)begin   
    if (reset)                         
      storage<=8'bz;
    else if(LoadAcc)
      storage<=in;
  end
  
  assign out_reg=DumpAcc ? storage : 8'bz;    //output the data in storage to Reg if Dump ACC singnal is ture. Otherwise continue to send high impedence.
  assign out_alu=storage;                 //output to ALU will continuously to be sent since one of the operants of ALU is always going to come from ACC.
endmodule
