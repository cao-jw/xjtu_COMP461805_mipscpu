`include "CU.v"
`include "SR.v"
module test(CLK,Op);
    input CLK;
    input [5:0] Op;
    wire PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,ALUSrcA,RegWr,RegDst;
    wire[1:0] PCSrc,ALUOp,ALUSrcB;
    wire [3:0] S;
    wire [3:0] NS;
    SR sr(.S(S),.NS(NS),.CLK(CLK));
    CU cu(.PCWr(PCWr),
    .PCWrCond(PCWrCond),
    .IorD(IorD),
    .MemRd(MemRd),
    .MemWr(MemWr),
    .IRWr(IRWr),
    .MemtoReg(MemtoReg),
    .ALUSrcA(ALUSrcA),
    .RegWr(RegWr),
    .RegDst(RegDst),
    .PCSrc(PCSrc),
    .ALUOp(ALUOp),
    .ALUSrcB(ALUSrcB),
    .S(S),
    .NS(NS),
    .Op(Op));
endmodule
module testbench;
reg clk;
reg [5:0]Op;
initial begin
    clk=0;
    Op=6'b100011;
    $dumpfile("CU.vcd");
    $dumpvars;
    #200;
    $finish;
end
always begin
    #10;
    clk=~clk;
end
test w(.CLK(clk),.Op(Op));
endmodule