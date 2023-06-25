`include "CPU.v"
`timescale 1ns/1ns
module test;
    reg clk;
    reg rst;
    wire[31:0] out_ALU,R_data1,R_data2,Address_in_PC,Address_out_PC,Address_Add_PC,Inst,R_data,Inst_Left;
    wire zero;
    CPU cpu(.CLK(clk),
    .rst(rst),
    .out_ALU(out_ALU),
    .R_data1(R_data1),
    .R_data2(R_data2),
    .Address_in_PC(Address_in_PC),
    .Address_out_PC(Address_out_PC),
    .Address_Add_PC(Address_Add_PC),
    .Inst(Inst),
    .R_data(R_data),
    .Inst_Left(Inst_Left),
    .zero(zero)
    );
    initial begin
        clk=0;
    end
    always begin
        #10 clk=~clk;
    end
        initial begin
            rst=0;
            #10;
            //clk=0;
            rst=1;
            #10;
            //clk=0;
            rst=0;
    end
    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars;
    end
    
    initial begin
        #300 $finish;
    end
    endmodule