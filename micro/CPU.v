`include "ALU.v"
`include "ALUCU.v"
`include "AndGate.v"
`include "ComReg.v"
`include "CU.v"
`include "IR.v"
`include "MDR.v"
`include "MUX32_2.v"
`include "MUX32_4.v"
`include "OrGate.v"
`include "PC.v"
`include "RAM.v"
`include "RF.v"
`include "SHL2_26.v"
`include "SHL2_32.v"
`include "SigExit16_32.v"
`include "SR.v"
`include "MUX5.v"

module CPU(CLK,Rst);
input CLK,Rst;
wire [5:0]Op;
wire[25:0]Inst;//OP&&Inst IR

wire [3:0] S;
wire PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,ALUSrcA,RegWr,RegDst;
wire[1:0] PCSrc,ALUOp,ALUSrcB;
wire[3:0] NS;//Ctrl

wire PCW;
wire[31:0] AddrOutPC;//PC

wire[31:0] OutALUOut,Addr;//IDsel;

wire[31:0] R_data,RAMW_data;//RAM

wire[31:0] OUTMDR;//MDR

wire[4:0] W_Reg;
wire[31:0] RFW_data,R_data1,R_data2;//RF

wire[31:0] ALUSrcASel1;//ALUSrcASel

wire[31:0] ALUSrcBSel0;
wire[31:0] ALUSrcBSel3;//ALUSrcBSel

wire[31:0] OutSig;//SigExit16_32

wire[31:0] ALUA,ALUB,ALUC;
wire[2:0] ALUCtrl;
wire zero,overflow;//ALU

wire[31:0] BeqAddr;
wire[31:0] OutPCSrcSel;//PCSrcSel

wire OutAndGate;//AndGate



    SR sr(.S(S),.NS(NS),.CLK(CLK),.Rst(Rst));//SR

    CU cu(.PCWr(PCWr),//CU
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
    .Op(Op),
    .CLK(CLK),
    .Rst(Rst));

    PC pc(.CLK(CLK),.Rst(Rst),.D(OutPCSrcSel),.Q(AddrOutPC),.PCW(PCW));//PC

    MUX32_2 IDsel(.A(AddrOutPC),.B(OutALUOut),.Select(IorD),.S(Addr));//IDsel

    RAM ram(.Addr(Addr),.R_data(R_data),.W_data(ALUSrcBSel0),.W(MemWr),.R(MemRd));//RAM

    MDR mdr(.CLK(CLK),.D(R_data),.Q(OUTMDR));//MDR
    
    IR ir(.CLK(CLK),.D(R_data),.IRWr(IRWr),.Inst({Op,Inst}));//ir

    MUX5 RegDstSel(.Select(RegDst),.A(Inst[20:16]),.B(Inst[15:11]),.S(W_Reg));//RegDstSel

    MUX32_2 MemtoRegSel(.Select(MemtoReg),.A(OutALUOut),.B(OUTMDR),.S(RFW_data));//RegDstSel

    RF rf(.CLK(CLK),.R_Reg1(Inst[25:21]),.R_Reg2(Inst[20:16]),.W_data(RFW_data),.W_Reg(W_Reg),.R_data1(R_data1),.R_data2(R_data2),.W(RegWr));//RF

    ComReg ComRegA(.CLK(CLK),.D(R_data1),.Q(ALUSrcASel1));//ComRegA
    
    ComReg ComRegB(.CLK(CLK),.D(R_data2),.Q(ALUSrcBSel0));//ComRegB

    MUX32_2 ALUSrcASel(.Select(ALUSrcA),.A(AddrOutPC),.B(ALUSrcASel1),.S(ALUA));//ALUSrcASel

    SigExit16_32 Sig(.Inst(Inst[15:0]),.Addr(OutSig));//Sig

    SHL2_32 shl2_32(.data(OutSig),.odata(ALUSrcBSel3));//SHL2_32

    MUX32_4 ALUSrcBSel(.Select(ALUSrcB),.A(ALUSrcBSel0),.B(4),.C(OutSig),.D(ALUSrcBSel3),.S(ALUB));//ALUSrcBSel

    ALUCU alucu(.funct(Inst[5:0]),.ALUOp(ALUOp),.ALUCtrl(ALUCtrl));//ALUCU

    ALU alu(.A(ALUA),.B(ALUB),.Mod(ALUCtrl),.C(ALUC),.Z(zero),.O(overflow));//ALU

    ComReg ALUOUT(.CLK(CLK),.D(ALUC),.Q(OutALUOut));//ALUOUT

    SHL2_26 shl2_26(.data(Inst),.data1(AddrOutPC[31:28]),.odata(BeqAddr));//shl2_26

    MUX32_4 PCSrcSel(.Select(PCSrc),.A(ALUC),.B(OutALUOut),.C(BeqAddr),.S(OutPCSrcSel),.D(32'bz));

    AndGate andgate(.A(zero),.B(PCWrCond),.R(OutAndGate));

    OrGate orgate(.A(OutAndGate),.B(PCWr),.R(PCW));

endmodule