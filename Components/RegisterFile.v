//5 inputs. 2 outputs.
//The 5 inputs are: 1.clock singnal. 2.reset singnal. 3.Load data to register singnal. 4.Dump data from register singnal. 5. The actual data need to be stored.
//The 2 outputs are: 1.output to ALU. 2.output to the MUX which after selection could be sent to Accumulator (ACC).
module RegisterFile(
  input clk,
  input reset,
  input LoadReg,
  input DumpReg,
  input [3:0] RegNumber,       //Adding this new input. 4-bit wide. Used to indicate one of the 16 registers. ie. 0000 is register0. 0001 is register1. 1111 is register15.
  input [7:0] in,
  output [7:0] out,
  output [7:0] out_alu
);
  reg [7:0] register [15:0];  //Creating the 16 registers. Each is 8-bit in size.
  integer i;                  //int used later in a for loop for counter.
  
  always @(posedge clk, reset)begin    //This block will execute on the positive edge of clock singnal, or when reset singnal changes.
    if (reset)begin                         //if..elseif statement that if reset is 1, we are resetting all registers to high impedence. else if LoadReg signal is on, then we'll load data in.
      for(i=0;i<16;i=i+1)begin
         register[i]<=8'bz;
        end
    end
    else if(LoadReg)
      register[RegNumber]<=in;
  end
  
  assign out=DumpReg ? register[RegNumber] : 8'bz;    //output the data in the current working register to MUX if DumpReg signal is on. Otherwise continue to send high impedance.
  assign out_alu=register[RegNumber];                 //output to ALU will continuously be sent. no conditions. From watching the week6 video I think that's how it's supposed to be?
endmodule
