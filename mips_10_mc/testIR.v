`include "PC.v"
`include "IR.v"
`include "RAM.v"
module test;
    reg clk,r,w;
    reg[31:0] w_data,addr;
    wire[31:0] r_data,w_w; 
    assign w_w=w_data;
    PC pc()
    endmodule