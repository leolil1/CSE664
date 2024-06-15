module alu (
    input [7:0] a, b,          // inputs to ALU
    input [3:0] opcode,        // control signal for different operations
    input clk,                 // clock signal
    input alu_enable,	       // ALU operation enable bit.
    output reg [7:0] op,       // output of ALU
    output reg carry,          // carry flag
    output reg zero            // zero flag
);

    reg [7:0] ACC;             // Accumulator register

    always @(posedge clk) begin
        if(alu_enable)begin          //This signal will be used by the controller to limit ALU operation to one operation per instruction.
                                     //Without it, because of the purposely introduced delay in the controller, ALU will keep executing
                                     //every high edge of CLK and ruins the correct result from the first execution.
        case (opcode)
            4'b0000 : begin 
                {carry, op} = a + b; 
                ACC = op;
                $display("Addition operation"); 
            end
            4'b0001 : begin 
                {carry, op} = a - b; 
                ACC = op;
                $display("Subtraction operation"); 
            end
            4'b0010 : begin 
                op = a * b; 
                ACC = op;
                $display("Multiplication operation"); 
            end
            4'b0011 : begin 
                op = a / b; 
                ACC = op;
                $display("Division operation"); 
            end
            4'b0100 : begin 
                op = a % b; 
                ACC = op;
                $display("Modulo Division operation"); 
            end
            4'b0101 : begin 
                op = a & b; 
                ACC = op;
                $display("Bit-wise AND operation"); 
            end
            4'b0110 : begin 
                op = ~(a | b);   //Made this from a | b to ~(a|b). So from XOR to NOR. One of the requirements is to have a NOR operation.
                ACC = op;
                $display("Bit-wise NOR operation"); 
            end
            4'b0111 : begin 
                op = a && b; 
                ACC = op;
                $display("Logical AND operation"); 
            end
            4'b1000 : begin 
                op = a || b; 
                ACC = op;
                $display("Logical OR operation"); 
            end
            4'b1001 : begin 
                op = a ^ b; 
                ACC = op;
                $display("Bit-wise XOR operation"); 
            end
            4'b1010 : begin 
                op = ~a; 
                ACC = op;
                $display("Bit-wise Invert operation"); 
            end
            4'b1011 : begin 
                op = !a; 
                ACC = op;
                $display("Logical Invert operation"); 
            end
            4'b1100 : begin 
                op = a >> 1; 
                ACC = op;
                $display("Right Shift operation"); 
            end
            4'b1101 : begin 
                op = a << 1; 
                ACC = op;
                $display("Left Shift operation"); 
            end
            4'b1110 : begin 
                op = a + 1; 
                ACC = op;
                $display("Increment operation"); 
            end
            4'b1111 : begin 
                op = a - 1; 
                ACC = op;
                $display("Decrement operation"); 
            end
            default: op = 8'bXXXXXXXX;
        endcase
       end
        // Set zero flag
        zero = (op == 8'd0);

        // Output to ACC register
        ACC = op;
    end
endmodule

