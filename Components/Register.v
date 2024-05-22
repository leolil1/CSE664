//5 inputs. 2 outputs.
//The 5 inputs are: 1.clock singnal. 2.reset singnal. 3.Load data to register singnal. 4.Dump data from register singnal. 5. The actual data need to be stored.
//The 2 outputs are: 1.output to ALU. 2.output to the MUX which after selection could be sent to Accumulator (ACC).
module Register(
  input clk,
  input reset,
  input LoadReg,
  input DumpReg,
  input [7:0] in,
  output [7:0] out,
  output [7:0] out_alu
);
  reg [7:0] storage;      //Register internal storage. Used to store the data.
  
  always @(posedge clk, reset)begin    //This block will execute on the positive edge of clock singnal, or when reset singnal changes.
    if (reset)                         //if..elseif statement that if reset is 1, we are resetting register data to high impedence. else if Load register singnal we'll load data in.
      storage<=8'bz;
    else if(LoadReg)
      storage<=in;
  end
  
  assign out=DumpReg ? storage : 8'bz;    //output the data in storage to MUX if Dump register singnal is ture. Otherwise continue to send high impedence.
  assign out_alu=storage;                 //output to ALU will continuously to be sent. no conditions. From watching the week6 video I think that's how it's supposed to be?
endmodule
