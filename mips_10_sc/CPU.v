`include "Add1.v"
`include "ALU.v"
`include "ALUCU.v"
`include "AndGate.v"
`include "CodeRam.v"
`include "MCU.v"
`include "MUX5.v"
`include "MUX32.v"
`include "PC.v"
`include "RAM.v"
`include "RF.v"
`include "SHL2_26.v"
`include "SHL2_32.v"
`include "SigExit16_32.v"

module CPU(
CLK,rst,out_ALU,R_data1,R_data2,Address_in_PC,Address_out_PC,Address_Add_PC,Inst,R_data,Inst_Left,zero
    );
     input CLK,rst;
     output [31:0]out_ALU;
     output [31:0] R_data1,R_data2,Address_in_PC,Address_out_PC,Address_Add_PC,Inst,R_data,Inst_Left;
     output zero;
     wire[31:0] W_data,R_data1,R_data2,R_data;
     wire [31:0] Address_in_PC,Address_out_PC;//用于PC的输入和输出
     wire [31:0] Address_Add_PC;//用于程序计数器正常指令进行加4的输出
     wire [31:0] Inst;//用于指令存储器的指令输出
     wire RegDst,Jump,Branch,MemtoReg,ALUSrc,RegWr,MemWr,MemRd;//用于对控制信号的连线
     wire [1:0] ALUOp;//控制信号ALUop的连线
     wire [4:0] W_Reg;//寄存器堆中写入寄存器所在的位号的连线
     wire [31:0] outsig,Add2B,ALU_B,out_ALU;//sign==outsig,out_sign==Add2B
     wire [31:0] outAdd2,Branch_or_normal;//ALU_Add_32_out==outAdd2
     wire [2:0] ALUCtrl;
     wire [31:0] Inst_Left;
     wire zero,Mux32_3_select;//Mux32_EN==Mux32_3_select
     wire overflow;     
     PC pc(.clk(CLK),.reset(rst),.d(Address_in_PC),.q(Address_out_PC));
      Add1 pc_adder(.A(4),.B(Address_out_PC),.C(Address_Add_PC));
      CodeRam coderam(.Addr(Address_out_PC),.Inst(Inst));
      MCU mcu(.op(Inst[31:26]),.RegDst(RegDst),.RegWr(RegWr),.ALUSrc(ALUSrc),.MemRd(MemRd),.MemWr(MemWr),.MemtoReg(MemtoReg),.Branch(Branch),.Jump(Jump),.ALUOp(ALUOp));
      MUX5 mux5(.A(Inst[20:16]),.B(Inst[15:11]),.RegDst(RegDst),.S(W_Reg));
      RF rf(.CLK(CLK),.W_data(W_data),.R_Reg1(Inst[25:21]),.R_Reg2(Inst[20:16]),.W_Reg(W_Reg),.R_data1(R_data1),.R_data2(R_data2),.W(RegWr));
      SigExit16_32 sigexit16_32(.Inst(Inst[15:0]),.Addr(outsig));
      MUX32 mux32_1(.A(R_data2),.B(outsig),.Select(ALUSrc),.S(ALU_B));
      ALUCU alucu(.funct(Inst[5:0]),.ALUOp(ALUOp),.ALUCtrl(ALUCtrl));
      ALU alu(.A(R_data1),.B(ALU_B),.Mod(ALUCtrl),.C(out_ALU),.Z(zero),.O(overflow));
      RAM ram(.Addr(out_ALU),.R_data(R_data),.R(MemRd),.W(MemWr),.W_data(R_data2));
      MUX32 MUX32_2(.A(out_ALU),.B(R_data),.Select(MemtoReg),.S(W_data));
      SHL2_32 shl2_32(.data(outsig),.odata(Add2B));
      Add1 add2(.A(Address_Add_PC),.B(Add2B),.C(outAdd2));
      AndGate andgate(.R(Mux32_3_select),.A(Branch),.B(zero));
      MUX32 mux32_3(.A(Address_Add_PC),.B(outAdd2),.Select(Mux32_3_select),.S(Branch_or_normal));
      SHL2_26 left2_26(.data(Inst[25:0]),.data1(Address_Add_PC[31:28]),.odata(Inst_Left));
      MUX32 mux32_4(.A(Branch_or_normal),.B(Inst_Left),.Select(Jump),.S(Address_in_PC));
endmodule
