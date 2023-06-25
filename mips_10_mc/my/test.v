`include "CPU.v"
`timescale 1ns/1ns
module test;
    reg clk;
    reg rst;
    CPU cpu(.CLK(clk),
    .Rst(rst)
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
        rst=1;
        #10;
        rst=0;
    end
    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars;
    end
    
    initial begin
        #1000 $finish;
    end
    endmodule