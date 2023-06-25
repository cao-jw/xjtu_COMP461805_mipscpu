module MUX32_2(
A,B,Select,S
    );
    input [31:0] A,B;
    input Select;
    output [31:0] S;
    assign S = (Select==0) ? A:B;
endmodule