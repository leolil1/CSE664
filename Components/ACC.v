//ACC is exactly the same as a register. Reference Register for more comments.
module ACC(
  input clk,
  input reset,
  input LoadAcc,
  input DumpAcc,
  input [7:0] in_alu,      //If we look at the Data Path diagram, and includes two MUXs,
  input [7:0] in_reg,      //then we can see all the inputs and ouputs for ACC.
  input [7:0] in_imm,
  input SelAcc0,
  input SelAcc1,
  output reg [7:0] out_reg,
  output [7:0] out_alu
);
  reg [7:0] storage;
  wire [7:0] MUXOutData;
  wire [7:0] MUXOutData2;     
  
  MUX MUX1 (.a(in_imm), .b(in_reg), .sel(SelAcc0), .y(MUXOutData));
  MUX MUX2 (.a(MUXOutData), .b(in_alu), .sel(SelAcc1), .y(MUXOutData2));
	
  always @(posedge clk, reset)begin   
    if (reset)                         
      storage<=8'b0;
    else if(LoadAcc)
      storage<=MUXOutData2;
  end
  
  always @(posedge clk)begin
    if(DumpAcc)
      out_reg<=storage;     		  //output the data in storage to Reg if Dump ACC singnal is ture.
  end
    
  assign out_alu=storage;                 //output to ALU will continuously to be sent since one of the operants of ALU is always going to come from ACC.
endmodule
