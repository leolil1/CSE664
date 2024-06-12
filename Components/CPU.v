//Live Lec 5 6.pdf is very useful when trying to figure out which modules connects to which.
//Pg 44 has the full diagram. We should be good for the most part just by following that.
module CPU(
	input clk,
  	input reset,
  	input [7:0] instruction
);
//
//Bus are listed here. Really they are just wires connecting ports from one module to another.
//Some are just passing 1-bit signal, so 1-bit bus. Some are passing multiple bits such as
//signals like Opcode, SelALU... so they are multipel bits bus.
//
wire [7:0]OpcodeWire; //This is used to connect InstructionRegister(IR) to Controller to pass the 8-bit 
                       //instruction. This wire will be used to make that happen.

wire LoadIRWire; //This is used for Controller to signal IR to load another Instruction.
                 //This wire provides the way for Controller to send that signal to IR.

wire LoadAccWire; //This is used for Controller to signal ACC to load the data to its storage
		  //Think this as the Write Enable for ACC. If this signal is off, you can
		  //continue to send data to ACC. It won't do anything with it.

wire DumpAccWire; //This is used for Controller to signal ACC to dump data stored in its storage
		  //to register.

wire LoadRegWire; //This is the Write Enable for RegisterFile. Controller can use this to signal
		  //register to write data to storage.

wire DumpRegWire; //This is used for Controller to signal register to dump it's data out. The data
		  //as of now is only sent to ACC after.

wire [3:0] ImmediateDataWire;   //This is used to for controller to send out the immedaite data.
				//For the final product, this will be connected to MUX for both
				//the ACC and ProgramCounter. For now thou testing, it's connected
				//directly to the ACC "in" port.

wire [7:0] Out_accDataWire;     //This is used to connect ACC to Reg. So when DumpAcc is turned on,
				//the data stored in ACC will be sent to Reg.

wire [7:0] out_regDataWire;     //This is used to connect Reg to ACC. So when DumpReg is turned on,
				//the data stored in Reg will be sent to the MUX of the ACC.

wire [3:0] RegNumberWire;     //This is used for the controller to pass the register number to RegisterFile.

wire SelAcc0Wire; //Two buses for the two MUXs before ACC register. See Data Path diagram in
wire SelAcc1Wire; //Live Lec 5 6.pdf pg 44 to see the design.

//
//Instantiating all the modules below. And connecting all the ports.
//
//InstructionRegister
IR IR1(.clk(clk), .reset(reset), .LoadIR(LoadIRWire), .instruction(instruction), .Opcode(OpcodeWire));

//ACC
ACC Acc1(.clk(clk), .reset(reset), .LoadAcc(LoadAccWire), .DumpAcc(DumpAccWire), .in_reg(out_regDataWire), .in_imm(ImmediateDataWire), .SelAcc0(SelAcc0Wire), .SelAcc1(SelAcc1Wire), .out_reg(Out_accDataWire));
	
//RegisterFile
RegisterFile RF1(.clk(clk), .reset(reset), .LoadReg(LoadRegWire), .DumpReg(DumpRegWire), .RegNumber(RegNumberWire), .in(Out_accDataWire), .out(out_regDataWire));

//Controller
Controller Con1(.clk(clk), .reset(reset), .Opcode(OpcodeWire), .LoadIR(LoadIRWire), .LoadReg(LoadRegWire), .DumpReg(DumpRegWire), .LoadAcc(LoadAccWire), .DumpAcc(DumpAccWire), .SelAcc0(SelAcc0Wire), .SelAcc1(SelAcc1Wire), .ImmediateData(ImmediateDataWire), .RegNumber(RegNumberWire));
endmodule
