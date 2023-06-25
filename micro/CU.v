`include "Add1.v"
`include "CMAR.v"
`include "Decode.v"
`include "ROM1.v"
`include "ROM2.v"
`include "MUX4_4.v"
module ROM(Addr,PCWr,PCWrCond,IorD,MemRd,ALUOp,ALUSrcB,ALUSrcA,RegWr,
code,Caddr);
    input[3:0] Addr;
    output reg PCWr,PCWrCond,IorD,MemRd,ALUSrcA,RegWr;
    output reg[1:0] ALUOp,ALUSrcB;
    output reg[2:0] code;
    output reg [1:0]Caddr;
    reg [15:0] rom[9:0];
    initial begin
        rom[0]=15'b10011_10000_10011;
        rom[1]=15'b00000_00001_10001;
        rom[2]=15'b00000_00001_01010;
        rom[3]=15'b00110_00000_00011;
        rom[4]=15'b00001_00000_00100;
        rom[5]=15'b00101_01000_00000;
        rom[6]=15'b00000_00100_01011;
        rom[7]=15'b00000_01000_00100;
        rom[8]=15'b01000_10010_01000;
        rom[9]=15'b10000_11000_00000;
    end
  always @(*) begin
    {PCWr,PCWrCond,IorD,MemRd}=rom[Addr][14:11];
    {ALUOp,ALUSrcB,ALUSrcA,RegWr}=rom[Addr][7:2];
    code=rom[Addr][10:8];
    Caddr=rom[Addr][1:0];
  end
endmodule

module CU(
    input[5:0] Op,
    input CLK,Rst,
    output  PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,ALUSrcA,RegWr,RegDst,
    output [1:0] PCSrc,ALUOp,ALUSrcB
);
wire[3:0] MUX1,MUX2;
wire[1:0] Caddr;
wire[3:0] AddrOutAdd;
wire[3:0] AddrInCMAR,AddrOutCMAR;
wire[2:0] code;
ROM2 rom2(.Op(Op),.MUX2(MUX2));
ROM1 rom1(.Op(Op),.MUX1(MUX1));
MUX4_4 mux4_4(.Select(Caddr),.A(4'b0000),.B(MUX1),.C(MUX2),.D(AddrOutAdd),.S(AddrInCMAR));
CMAR cmar(.CLK(CLK),.Rst(Rst),.AddrInCMAR(AddrInCMAR),.AddrOutCMAR(AddrOutCMAR));
Add1 add1(.A(AddrOutCMAR),.B(4'b0001),.C(AddrOutAdd));
ROM rom(.Addr(AddrOutCMAR),
.PCWr(PCWr),//CU
    .PCWrCond(PCWrCond),
    .IorD(IorD),
    .MemRd(MemRd),
    .ALUSrcA(ALUSrcA),
    .RegWr(RegWr),
    .ALUOp(ALUOp),
    .ALUSrcB(ALUSrcB),
    .code(code),
    .Caddr(Caddr));
Decode decode(.code(code),.MemWr(MemWr),.IRWr(IRWr),.MemtoReg(MemtoReg),.PCSrc(PCSrc),.RegDst(RegDst));
endmodule