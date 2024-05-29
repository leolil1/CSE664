//There are couple things behind the design of the Controller.
//1.Controller should follow 3 step executions: fectch instructino, decode, execute
//2.At each of the 3 stages, different types of output singals will be generated.
//These signals, later, will be sent to appropriate modules like ALU, Register...
module Controller(
  input clk, reset,
  input [3:0] Opcode,
  output reg LoadIR, IncPC, SelPC, LoadPC, LoadReg, DumpReg, LoadAcc,
  output reg [1:0] SelAcc,
  output reg [3:0] SelALU
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
  	stage<=2'b01;         //Once instruction is loaded, we now move on to stage 1.
	end
   //stage 1 block.
   //In this stage, we are generating different control signals based on the Opcode.
   //So there will be many differnt case statements.
   else if (stage==2'b01)begin
    case(Opcode)
    4'b0100:begin
   	//Load Reg to ACC.  
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=1;
	LoadAcc<=0;
	SelAcc<=2'b00;
	SelALU<=0;  
	stage<=2'b10; 
    end

    4'b0101:begin
   	//Load ACC to Reg.  
  	LoadIR<=0; 
	IncPC<=1; 
	SelPC<=0; 
	LoadPC<=0; 
	LoadReg<=0;
    	DumpReg<=0;
	LoadAcc<=1;
	SelAcc<=2'b00;
	SelALU<=0;  
	stage<=2'b10; 
    end

     4'b0101:begin
   	//Load Immediate to ACC.  
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
	    
    4'b0010:begin
	//Add instruction.  
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
