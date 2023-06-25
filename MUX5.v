module MUX5(
    A,B,RegDst,S
    );
    input [4:0] A,B;
    input RegDst;
    output [4:0] S;
    assign S = (RegDst==0) ? A:B;
endmodule
