//There are couple things behind the design of the Controller.
//1.Controller should follow 3 step executions: fectch instructino, decode, execute
//2.At each of the 3 stages, different types of output singals will be generated.
//These signals, later, will be sent to appropriate modules like ALU, Register...
module Controller(
  input clk, reset,
  input [7:0] Opcode,
  input Zero_Carry,    //Lecture 6 Video "Instruction Set" says it's the ACC upper bit, 1 or 0, indicates
  //if it's Zero or Carry. Yet if you look at the Datapath diagram, it shows Zero or Carry singnal coming
  //out of ALU... So I'm not sure exactly where this input signal is gonne be coming from.
  output reg LoadIR, IncPC, SelPC, LoadPC, LoadReg, DumpReg, LoadAcc, DumpAcc,
  output reg SelAcc0,
  output reg SelAcc1,
  output reg [3:0] SelALU,
  output reg [3:0] ImmediateData,
  output reg [3:0] RegNumber
);

  reg [1:0] stage;

  //always block to execute following in either reset==1 or positive clock edge
  always @(posedge clk, reset)begin
    //reset block. reset everything to 0.
    if (reset==1)begin
      stage<=2'b00;
      LoadIR<=0; 
      IncPC<=0; 
      SelPC<=0; 
      LoadPC<=0; 
      LoadReg<=0; 
      DumpReg<=0; 
      LoadAcc<=0;
      DumpAcc<=0;
      SelAcc0<=1'bz;
      SelAcc0<=1'bz;
      SelALU<=4'b0;
      ImmediateData<=4'b0;
      RegNumber<=4'b0;
    end

    //stage 0 block.
    //In this stage, we are only fetching instructions from InstructionRegister.
    //This means, later when we are putting things together, we need to connect IR to Controller.
   if (stage==2'b00)begin
	//fetch instruction
  	LoadIR<=1;             //Send out the load instruction signal to IR.
	//IncPC<=1;              //Incrementing Program Counter here? or no?
	//SelPC<=0; 
	//LoadPC<=0; 
	//LoadReg<=0;
	//DumpReg<=1;
	LoadAcc<=0;
	DumpAcc<=0;
	//SelAcc<=0;
	//SelALU<=0;
	//RegNumber<=0;
  	stage<=2'b01;         //Once instruction is loaded, we now move on to stage 1.
	end
   //stage 1 block.
   //In this stage, we are generating different control signals based on the Opcode.
   //So there will be many different case statements.
   else if (stage==2'b01)begin
    case(Opcode[7:4])
    //Load Reg to ACC.
    4'b0100:begin  
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=1;          //Turn on this bit. Check the Register code. This should be to dump data stored in register to ACC.
	LoadAcc<=1;          //Turn on this Write Enable bit. So reg data can be written to ACC.
	DumpAcc<=0;
	SelAcc0<=1;          //Turn on this bit to select reg as the input.
	SelAcc1<=0;          //Leave this bit off so reg will continue to be selected in 2nd MUX.
	SelALU<=0;
	RegNumber<=Opcode[3:0];
	stage<=2'b10; 
    end
	
    //Load ACC to Reg.
    4'b0101:begin 
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;       
	DumpAcc<=1;          //Turn on this bit to dump data stored in ACC to Reg.
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=0; 
	RegNumber<=Opcode[3:0];
	stage<=2'b10; 
    end
	
     //Load Immediate to ACC.
     4'b1101:begin  
  	LoadIR<=0; 
	//IncPC<=1; 
	//SelPC<=0; 
	//LoadPC<=0; 
	//LoadReg<=0;
    	//DumpReg<=0;
	LoadAcc<=1;       //Turn on this Write Enable bit so data can be written to ACC to store.
	DumpAcc<=0;
	SelAcc0<=0;       //Leave both Sel as 0, so imm can be selected as input for ACC to store.
	SelAcc1<=0;
	//SelALU<=0;  
	ImmediateData<=Opcode[3:0];
	RegNumber<=0;
	stage<=2'b10; 
    end

    //Jump on Zero. Jump Reg.
    4'b0110:begin
	if(Zero_Carry==0)begin  
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=0;       //This should be connected to the MUX for PC. So 0 selects register as input.
	LoadPC<=1;      //Got turn this bit on to load?
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=0;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10;
	end
    end

    //Jump on Zero. Jump Immediate.
    4'b0111:begin
	if(Zero_Carry==0)begin  
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=1;       //This should be connected to the MUX for PC. So 1 selects Immediate as input.
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=0;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0; 
	SelALU<=0;  
	stage<=2'b10;
	end
    end

    //Jump on Carry. Jump Reg.
    4'b1000:begin
	if(Zero_Carry==1)begin  
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=0;       
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=0;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10;
	end
    end

    //Jump on Cary. Jump Immediate.
    4'b1010:begin
	if(Zero_Carry==1)begin  
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=1;       
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=0;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;  
	SelALU<=0;  
	stage<=2'b10;
	end
    end

    //NOP. For this instruction, only thing we do is increment the PC by 1.
    4'b0000:begin  
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=0;          
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=0;  
	stage<=2'b10; 
    end

    //HALT. For this instruction, we dont do anything. Not even incrementing PC.
    4'b1111:begin  
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=0;          
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=0; 
	stage<=2'b10; 
    end

    //Add instruction
    4'b0001:begin 
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
	DumpReg<=1;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=4'b0000;   //ALU Opcode is from alu_2.v module.
	RegNumber<=Opcode[3:0];
	stage<=2'b10; 
    end

    //Sub instruction
    4'b0010:begin 
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
	DumpReg<=1;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=4'b0001;   
	RegNumber<=Opcode[3:0];
	stage<=2'b10; 
    end

    //Nor instruction
    4'b0011:begin 
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
	DumpReg<=1;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=4'b1000;   
	RegNumber<=Opcode[3:0];
	stage<=2'b10; 
    end

    //Below two instructions do not involve reg. Value will be coming from ACC.
    //Then output is sent back to ACC.
    //Right Shift instruction
    4'b1100:begin 
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=4'b1100;   
	stage<=2'b10; 
    end

    //Left Shift instruction
    4'b1011:begin 
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
	DumpReg<=0;
	LoadAcc<=0;
	DumpAcc<=0;
	SelAcc0<=0;
	SelAcc1<=0;
	SelALU<=4'b1101;   
	stage<=2'b10; 
    end
   
   endcase
   end
//stage 2 bloc.
//In this stage, we'll execute. Not sure what to put here yet.
else if (stage==2'b10)begin
stage<=2'b00;       //Resetting stages to 0. 
end



end
endmodule
