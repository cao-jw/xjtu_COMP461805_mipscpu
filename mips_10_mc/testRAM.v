`include "RAM.v"
module test;
    reg clk,r,w;
    reg[31:0] w_data,addr;
    wire[31:0] r_data,w_w; 
    assign w_w=w_data;
    
    initial begin
        $dumpfile("RAM.vcd");
        $dumpvars;
        clk=0;
        r=0;
        w=1;
        addr=32'b0;
        w_data=32'b0;
        #100;
        $finish;
    end
    always begin
        #10;
        clk=~clk;
        w_data=w_data+1;
    end
    always begin
        #5;
        r=~r;
        w=~w;
    end
    RAM ram(.Addr(addr),.R(r),.W(w),.R_data(r_data),.W_data(w_data));
    endmodule
