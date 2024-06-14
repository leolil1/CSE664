module CPU(
  input clk,
  input reset,
  input [7:0] instruction
);

//
//Buses are listed here. Really they are just wires connecting ports from one module to another.
//Some are just passing 1-bit signal, so 1-bit bus. Some are passing multiple bits such as
//signals like Opcode, SelALU... so they are multiple bits bus.
//
wire [7:0] OpcodeWire; //This is used to connect InstructionRegister(IR) to Controller to pass the 8-bit 
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

wire DumpRegWire; //This is used for Controller to signal register to dump its data out. The data
          //as of now is only sent to ACC after.

wire [3:0] ImmediateDataWire;   //This is used for the controller to send out the immediate data.
        //For the final product, this will be connected to MUX for both
        //the ACC and ProgramCounter. For now though testing, it's connected
        //directly to the ACC "in" port.

wire [7:0] Out_accDataWire;     //This is used to connect ACC to Reg. So when DumpAcc is turned on,
        //the data stored in ACC will be sent to Reg.

wire [7:0] out_regDataWire;     //This is used to connect Reg to ACC. So when DumpReg is turned on,
        //the data stored in Reg will be sent to the MUX of the ACC.

wire [3:0] RegNumberWire;     //This is used for the controller to pass the register number to RegisterFile.

wire SelAcc0Wire; //Two buses for the two MUXs before ACC register. See Data Path diagram in
wire SelAcc1Wire; //Live Lec 5 6.pdf pg 44 to see the design.

wire [7:0] alu_a, alu_b;     //Inputs to ALU
wire [3:0] SelALUWire;       //ALU control signal from Controller
wire [7:0] alu_op;           //Output of ALU
wire alu_carry, alu_zero;    //ALU flags

//
//Instantiating all the modules below and connecting all the ports.
//

//InstructionRegister
IR IR1(.clk(clk), .reset(reset), .LoadIR(LoadIRWire), .instruction(instruction), .Opcode(OpcodeWire));

//ACC
ACC Acc1(
  .clk(clk), .reset(reset), .LoadAcc(LoadAccWire), .DumpAcc(DumpAccWire), 
  .in_alu(alu_op), .in_reg(out_regDataWire), .in_imm(ImmediateDataWire), 
  .SelAcc0(SelAcc0Wire), .SelAcc1(SelAcc1Wire), .out_reg(Out_accDataWire), .out_alu(alu_a)
);

//RegisterFile
RegisterFile RF1(
  .clk(clk), .reset(reset), .LoadReg(LoadRegWire), .DumpReg(DumpRegWire), 
  .RegNumber(RegNumberWire), .in(Out_accDataWire), .out(out_regDataWire), .out_alu(alu_b)
);

//Controller
Controller Con1(
  .clk(clk), .reset(reset), .Opcode(OpcodeWire), .Zero(alu_zero), .Carry(alu_carry),
  .LoadIR(LoadIRWire), .LoadReg(LoadRegWire), .DumpReg(DumpRegWire), .LoadAcc(LoadAccWire), .DumpAcc(DumpAccWire), 
  .SelAcc0(SelAcc0Wire), .SelAcc1(SelAcc1Wire), .SelALU(SelALUWire), 
  .ImmediateData(ImmediateDataWire), .RegNumber(RegNumberWire)
);

//ALU
alu ALU1(
  .a(alu_a), .b(alu_b), .opcode(SelALUWire), .clk(clk), 
  .op(alu_op), .carry(alu_carry), .zero(alu_zero)
);

endmodule
