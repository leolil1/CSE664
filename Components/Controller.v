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
  output reg LoadIR, IncPC, SelPC, LoadPC, LoadReg, DumpReg, LoadAcc,
  output reg [1:0] SelAcc,
  output reg [3:0] SelALU,
  output reg [3:0] SelReg
);
  //reg [3:0] count;
  reg [1:0] stage;

  //always block to execute following in either reset==1 or positive clock edge
  always @(posedge clk, reset)begin
    //reset block. reset everything to 0.
    if (reset==1)begin
      //count<=4'b0;
      stage<=2'b00;
      LoadIR<=0; IncPC<=0; SelPC<=0; LoadPC<=0; LoadReg<=0; DumpReg<=0; LoadAcc<=0;
      SelAcc<=2'b0;
      SelALU<=4'b0;
      SelReg<=4'b0;
    end

    //stage 0 block.
    //In this stage, we are only fetching instructions from InstructionRegister.
    //This means, later when we are putting things together, we need to connect IR to Controller.
   if (stage==2'b00)begin
	//fetch instruction
  	LoadIR<=1;             //Send out the load instruction signal to IR.
	IncPC<=1;              //Incrementing Program Counter here? or no?
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
	DumpReg<=1;
	LoadAcc<=0;
	SelAcc<=0;
	SelALU<=0;
        SelReg<=0;
  	stage<=2'b01;         //Once instruction is loaded, we now move on to stage 1.
	end
   //stage 1 block.
   //In this stage, we are generating different control signals based on the Opcode.
   //So there will be many different case statements.
   else if (stage==2'b01)begin
    case(Opcode)
    //Load Reg to ACC.
    4'b0100:begin  
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=1;          //Turn on this bit. Check the Register code. This should be to dump data stored in register to ACC.
	LoadAcc<=0;
	SelAcc<=2'b00;
	SelALU<=0;
        SelReg<=Opcode[3:0];  //Later in the CPU module, we can do something like
	//registers[SelReg] which will select registers according to SelReg.
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
	LoadAcc<=1;        //Turn on this bit. Check the ACC code.
	SelAcc<=2'b00;
	SelALU<=0;
        SelReg<=Opcode[3:0];  
	stage<=2'b10; 
    end
	
     //Load Immediate to ACC.
     4'b0101:begin  
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	SelAcc<=2'b01;  //So I'm thinking IR needs to have the Immediate_data output be connected to the first MUX for ACC, and also the MUX to program counter. 
	//Then depends on the selection, the immedaite_data can be accepted or ignored. Here, it'll be accepted.
	SelALU<=0;  
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
	SelAcc<=2'b00;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	SelAcc<=2'b00;  
	SelALU<=0;  
	stage<=2'b10;
	end
    end

    //Jump on Zero. Jump Immediate.
    4'b0110:begin
	if(Zero_Carry==0)begin  
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=1;       //This should be connected to the MUX for PC. So 1 selects Immediate as input.
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	SelAcc<=2'b00;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	SelAcc<=2'b00;  
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
	SelAcc<=2'b00;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	SelAcc<=2'b00;  
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
	SelAcc<=2'b00;  
	SelALU<=0;  
	stage<=2'b10; 
    	end
	else begin
	//if ACC is not zero, then we just need to increment PC by 1.
	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0;       
	LoadPC<=1;      
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=0;
	SelAcc<=2'b00;  
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
	SelAcc<=2'b00;
	SelALU<=0;
        SelReg<=Opcode[3:0];  
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
	SelAcc<=2'b00;
	SelALU<=0;
        SelReg<=Opcode[3:0];  
	stage<=2'b10; 
    end

    //Add instruction
    4'b0010:begin 
  	LoadIR<=0; 
	IncPC<=0; 
	SelPC<=0; 
	LoadPC<=1; 
	LoadReg<=0;
	DumpReg<=1;
	LoadAcc<=0;
	SelAcc<=0;
	SelALU<=4'b0001;   //I'm assuming SelALU for ADD is 0001. Need to find this info from Andrew/James' code.
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
