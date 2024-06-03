module programcounter (clk,enable,val,count);
    input [7:0] val;
    input clk,enable;
    output reg [7:0] count;
    always @ (posedge clk)
        if (enable)
            count <= count + 1;
        else
            count <= val;
endmodule