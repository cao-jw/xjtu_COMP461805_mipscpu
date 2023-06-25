module MUX5(
    A,B,Select,S
    );
    input [4:0] A,B;
    input Select;
    output [4:0] S;
    assign S = (Select==0) ? A:B;
endmodule
