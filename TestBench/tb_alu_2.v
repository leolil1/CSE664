`timescale 1ns / 1ps

module tb_alu;
    // Inputs
    reg [7:0] A, B;
    reg [3:0] ALU_Sel;
    reg clk;

    // Outputs
    wire [7:0] ALU_Out;
    wire carry, zero;

    // Instantiate the ALU module
    alu test_unit (
        .a(A), 
        .b(B), 
        .opcode(ALU_Sel), 
        .clk(clk), 
        .op(ALU_Out), 
        .carry(carry), 
        .zero(zero)
    );

    integer i;

    initial begin
        // Initialize the clock
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    initial begin
        // Initial values
        A = 8'h0A;
        B = 8'h02;
        ALU_Sel = 4'h0;

        // Apply different ALU_Sel values
        for (i = 0; i <= 15; i = i + 1) begin
            #10 ALU_Sel = ALU_Sel + 4'h1;
        end

        // Change input values
        A = 8'hF6;
        B = 8'h0A;

        // Hold the new values for observation
        #100;
    end
endmodule


