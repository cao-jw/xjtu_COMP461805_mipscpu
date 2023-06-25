`timescale 1ps/1ps
module MultiCycleCPU_test(

    );
    
//    module MultiCycleCPU(
//                CLK,
//                Opcode,ALU_in1,ALU_in2,ALU_result,STATE_out,PC_out,
//                IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk
//                    );
    
    reg CLK;
    wire IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk;
    wire [5:0] Opcode;
    
    wire [31:0] ALU_in1;
    wire [31:0] ALU_in2;
    wire [31:0] ALU_result;
    wire [31:0] PC_out;
    
    MultiCycleCPU cpu32(
            .CLK(CLK),
            .Opcode(Opcode),
            .ALU_in1(ALU_in1),
            .ALU_in2(ALU_in2),
            .ALU_result(ALU_result),
            .PC_out(PC_out),
            .IF_clk(IF_clk),
            .ID_clk(ID_clk),
            .ALU_clk(ALU_clk),
            .MEM_clk(MEM_clk),
            .WB_clk(WB_clk)
            );
            
    initial
        begin
            CLK=0;
            $dumpfile("cpu.vcd");
            $dumpvars;
        end
    always #2 CLK=~CLK;
    initial begin
        #500;
        $finish;
    end
endmodule

module MultiCycleCPU(
CLK,
Opcode,ALU_in1,ALU_in2,ALU_result,PC_out,
IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk
    );
    input CLK;
    output [5:0] Opcode;
    output [31:0] ALU_in1;
    output [31:0] ALU_in2;
    output [31:0] ALU_result;
    output [31:0] PC_out;//计算出的下一个pc值
    
    output IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk;
    //ControlUnit输出信号
    wire PCWre,Branch,Jump,RegDst,ALUSrc,MemorReg,MemWr,ExtOp;
    wire RegWr;
    wire [2:0] ALUctr;
    
    wire [2:0] STATE_out;
    
    //ALU输出信号
    wire Carryout,Zero,Overflow;
    
    wire [31:0] PC_in;
    
    //从指令中取出的相关数据
    wire [25:0] Imm26;
    wire [5:0] FUNC;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [4:0] RD;
    
    wire [31:0] DataMem_out;
    
    //RegisterFile相关
    wire [31:0] data_to_registerfile;
    //wire [31:0] ALU_data1;
    wire [31:0] ALU_temp_data1;
    
    wire [31:0] ALU_temp_data2;
    //wire [31:0] ALU_data2;
//    module PCctr(
//           clk,PCWre,Branch, Jump, Zero, imm,pc_in,pc_out);
//imm取自指令后26位
    PCctr pcctr(
                .PCWre(PCWre),
                .Branch(Branch),
                .Jump(Jump),
                .Zero(Zero),
                .imm(Imm26),
                .pc_in(PC_in),
                .pc_out(PC_out)
                );
      
      
//      module PC_in_out(
//                        clk,pc_in,
//                        pc_out  ); 
//把当前pc值PC_out，送入PC_in，以便PCctr下一次计算
        PC_in_out pc_in_out(
                    .clk(CLK),
                    .pc_in(PC_out),
                    .pc_out(PC_in)
                    );            
    
//    module InstructionMem(
//        pc,IF_clk,
//        ins_Opcode,ins_func,ins_rs,ins_rt,ins_rd,ins_imm );
//imm取自指令后26位
    InstructionMem IM(
                        .pc(PC_out),
                        .IF_clk(IF_clk),
                        .ins_Opcode(Opcode),
                        .ins_func(FUNC),
                        .ins_rs(RS),
                        .ins_rt(RT),
                        .ins_rd(RD),
                        .ins_imm(Imm26)
                        );
       
//       module ControlUnit(
//                    clk,Opcode,func,
//                    Branch,Jump,RegDst,ALUSrc,ALUctr,MemorReg,RegWr,MemWr,ExtOp,PCWre,
//                    IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk,
//                    state_out
//                        );
        ControlUnit controlunit(
                    .clk(CLK),
                    .Opcode(Opcode),
                    .func(FUNC),
                    .Branch(Branch),
                    .Jump(Jump),
                    .RegDst(RegDst),
                    .ALUSrc(ALUSrc),
                    .ALUctr(ALUctr),
                    .MemorReg(MemorReg),
                    .RegWr(RegWr),
                    .MemWr(MemWr),
                    .ExtOp(ExtOp),
                    .PCWre(PCWre),
                    .IF_clk(IF_clk),
                    .ID_clk(ID_clk),
                    .ALU_clk(ALU_clk),
                    .MEM_clk(MEM_clk),
                    .WB_clk(WB_clk),
                    .state_out(STATE_out)
                    );
                    
              
//      module RegisterFile(
//                WB_clk,RegWr,Overflow,RegDst,Ra,Rb,Rc,busW,
//                busA,busB ); 
        RegisterFile registerfile(
                    .WB_clk(WB_clk),
                    .RegWr(RegWr),
                    .Overflow(Overflow),
                    .RegDst(RegDst),
                    .Ra(RS),
                    .Rb(RT),
                    .Rc(RD),
                    .busW(data_to_registerfile),
                    .busA(ALU_in1),
                    .busB(ALU_temp_data1)
                    );  
           
           
//           module Extender(
//                    ExtOp,ex_imm,
//                    ex_out
//                        ); 
            Extender extender(
                        .ExtOp(ExtOp),
                        .ex_imm(Imm26),
                        .ex_out(ALU_temp_data2)
                        );
                                
//         module ALUSrc_select(
//                        ALUSrc,busB,imm36,
//                        src_out );           
           ALUSrc_select alusrc_select(
                    .ALUSrc(ALUSrc),
                    .busB(ALU_temp_data1),
                    .imm36(ALU_temp_data2),
                    .src_out(ALU_in2)
           );
           
//           module ALU32(
//                    ALU_clk,ALUctr,in0,in1,
//                    carryout,overflow,zero,out );
           ALU32 alu32(
                       .ALU_clk(ALU_clk),
                       .ALUctr(ALUctr),
                       .in0(ALU_in1),
                       .in1(ALU_in2),
                       .carryout(Carryout),
                       .overflow(Overflow),
                       .zero(Zero),
                       .out(ALU_result)
                       );
                       
                       
//           module DataMem(
//                    MEM_clk,WrEn,Adr,DataIn,
//                    DataOut
//                        );
             DataMem datamem(
                      .MEM_clk(MEM_clk),
                      .WrEn(MemWr),
                      .Adr(ALU_result),
                      .DataIn(ALU_temp_data1),
                      .DataOut(DataMem_out)
                      );
                      
//             module Data_select(
//                    MemorReg,ALU_out,DataMem_out,
//                    Data_out
//                        );
               Data_select data_select(
                        .MemorReg(MemorReg),
                        .ALU_out(ALU_result),
                        .DataMem_out(DataMem_out),
                        .Data_out(data_to_registerfile)
                        );
                      
                       
endmodule

module PCctr(
PCWre,Branch, Jump, Zero, imm,pc_in,pc_out
    );
    //input clk;
    input PCWre;
    input Branch;
    input Jump;
    input Zero;
    input [25:0] imm;//imm取自指令的后26位
    input [31:0] pc_in;
    output reg [31:0] pc_out;
    initial
    begin
        pc_out=0;
    end
    //clk上升沿触发
    always @(Jump or Branch or Zero or PCWre)
    if(Jump)
        pc_out={pc_in[31:28],imm[25:0],1'b0,1'b0};
    else if(Branch&&Zero)
        pc_out=pc_in+{{14{imm[15]}},imm[15:0],1'b0,1'b0};
    else if(!Jump&&PCWre)
        pc_out=pc_in+4;
        
endmodule

module PC_in_out(
clk,pc_in,
pc_out
    );
    input clk;
    input [31:0] pc_in;
    output reg [31:0] pc_out;
    
    always@(posedge clk)
    begin
        pc_out<=pc_in;
    end
endmodule

module InstructionMem(
pc,IF_clk,
ins_Opcode,ins_func,ins_rs,ins_rt,ins_rd,ins_imm
    );
    input [31:0] pc;
    input IF_clk;
    output reg [5:0] ins_Opcode;
    output reg [5:0] ins_func;
    output reg [4:0] ins_rs;
    output reg [4:0] ins_rt;
    output reg [4:0] ins_rd;
    output reg [25:0] ins_imm;
    reg [31:0] memory[64:0];
    
    initial
    begin
      memory[0]=32'b000000_00111_00010_00010_00000_100000;//add reg[2]=reg[7]+reg[2]
      memory[1]=32'b000000_00010_00111_00100_00000_100011;//subu reg[4]=reg[2]-reg[7]
      memory[2]=32'b000000_00000_00001_00010_00000_101011;//sltu reg[0]<reg[1]?reg[2]=1:reg[2]=0
      memory[3]=32'b001101_00011_00100_0010011111000001;//ori reg[4]=reg[3]|zeroext(0010011111000001)
      memory[4]=32'b101011_00101_00110_0000000000000111;//sw reg[6]=6 MEM[reg[5]+SignExt(imm16)<=reg[6]
      memory[5]=32'b100011_00101_00111_0000000000000111;//lw reg[7]<=MEM[reg[5]+SignExt(imm16)
      memory[6]=32'b000000_00111_00010_00011_00000_100000;//add reg[7]=6,,reg[2]=1,reg[3]=reg[7]+reg[2]
      memory[7]=32'b000100_00001_00010_0000000000000001;//beq reg[1]==reg[2] ? pc<=pc+4+SignExt(0000000000000001)*4 : pc<=pc+4
      //memory[8]beq跳转到memory[9]
      memory[9]=32'b000010_00000_00000_00000_00000_111111;//jump pc<=0000_00000_00000_00000_00000_111111_00
    end
    
    always @(posedge IF_clk)
    begin
       ins_Opcode=memory[pc[31:2]][31:26];
       ins_func=memory[pc[31:2]][5:0];
       ins_rs=memory[pc[31:2]][25:21];
       ins_rt=memory[pc[31:2]][20:16];
       ins_rd=memory[pc[31:2]][15:11];
       ins_imm=memory[pc[31:2]][25:0];
    end
        
endmodule

module ControlUnit(
clk,Opcode,func,
Branch,Jump,RegDst,ALUSrc,ALUctr,MemorReg,RegWr,MemWr,ExtOp,PCWre,
IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk,
state_out
    );
    input clk;
    input [5:0] Opcode;
    input [5:0] func;
    output reg Branch;
    output reg Jump;
    output reg RegDst;
    output reg ALUSrc;
    output reg [2:0] ALUctr;
    output reg MemorReg;
    output reg RegWr;
    output reg MemWr;
    output reg ExtOp;
    output reg PCWre;
    output reg [2:0] state_out;
    
    output reg IF_clk;
    output reg ID_clk;
    output reg ALU_clk;
    output reg MEM_clk;
    output reg WB_clk;
    
    parameter [2:0] IF=3'b000,//IF state
                     ID=3'b001,//ID state
                     EXE1=3'b110,//add,sub,subu,slt,sltu,ori,addiu
                     EXE2=3'b101,//beq
                     EXE3=3'b010,//sw lw
                     MEM=3'b011,//MEM state
                     WB1=3'b111,//add,sub,subu,slt,sltu,ori,addiu
                     WB2=3'b100;//lw
    parameter [5:0] R_type=6'b000000,
                     ori=6'b001101,
                     addiu=6'b001001,
                     lw=6'b100011,
                     sw=6'b101011,
                     beq=6'b000100,
                     jump=6'b000010;
    //状态寄存器                 
    reg [2:0] state,next_state;
  
    initial
        begin
        Branch=0;
        Jump=0;
        RegDst=0;
        ALUSrc=0;
        ALUctr=0;
        MemorReg=0;
        RegWr=0;
        MemWr=0;
        ExtOp=0;
        PCWre=0;
        state=3'b000;
        state_out=state;
        end
        
        //上升沿触发
        always@(posedge clk)
        begin
            state<=next_state;
            state_out=state;
        end
        
        always@(state)
        begin
        case(state)
            //IF阶段无条件跳转到ID阶段
            IF:  next_state<=ID;
            //ID阶段
            ID:
                begin
                    if(Opcode == jump)
                        next_state<=IF;
                    else if(Opcode==beq)
                        next_state<=EXE2;
                    else if(Opcode==lw||Opcode==sw)
                        next_state<=EXE3;
                    else
                        next_state<=EXE1;
                end
            EXE1:next_state<=WB1;
            EXE2:next_state<=IF;
            EXE3:next_state<=MEM;
            MEM:
                begin
                    if(Opcode==lw)
                        next_state=WB2;
                    else
                        next_state=IF;
                end
           WB1:next_state<=IF;
           WB2:next_state<=IF;
           default:next_state=IF;
      endcase
      end
      
      
      always @(next_state)
      begin
            if(next_state==IF)
                IF_clk=1;
            else
                IF_clk=0;
            
            if(next_state==ID)
                ID_clk=1;
            else
                ID_clk=0;
            
            if(next_state==EXE1||next_state==EXE2||next_state==EXE3)
                ALU_clk=1;
            else
                ALU_clk=0;
                
            if(next_state==MEM)
                MEM_clk=1;
            else
                MEM_clk=0;
            
            if(next_state==WB1||next_state==WB2)
                WB_clk=1;
            else
                WB_clk=0;
                
      end
      
      always@(state)
      begin
        if(state==IF&&Opcode!=jump)
            PCWre<=1;
        else
            PCWre<=0;
        if(Opcode==R_type)
            begin
            Branch<=0;
            Jump<=0;
            RegDst<=1;
            ALUSrc<=0;
            MemorReg<=0;
            RegWr<=1;
            MemWr<=0;
            ALUctr[2]<=(~func[2])&func[1];
            ALUctr[1]<=func[3]&(~func[2])&func[1];
            ALUctr[0]<=((~func[3])&(~func[2])&(~func[1])&(~func[0])) | ((~func[2])&func[1]&(~func[0]));
            end
        else
            begin
            if(Opcode==beq)
                Branch<=1;
            else
                Branch<=0;
                
            if(Opcode==jump)
                Jump<=1;
            else
                Jump<=0;
                
            RegDst<=0;
            
            if(Opcode==ori||Opcode==addiu||Opcode==lw||Opcode==sw)
                ALUSrc<=1;
            else
                ALUSrc<=0;
                
            if(Opcode==lw)
                MemorReg<=1;
            else
                MemorReg<=0;
                
            if(Opcode==ori||Opcode==addiu||Opcode==lw)
                RegWr<=1;
             else
                RegWr<=0;
                
             if(Opcode==sw)
                MemWr<=1;
             else
                MemWr<=0;
                
             if(Opcode==addiu||Opcode==lw||Opcode==sw)
                ExtOp<=1;
             else
                ExtOp<=0;
                
             ALUctr[2]<=~Opcode[5]&~Opcode[4]&~Opcode[3]&Opcode[2]&~Opcode[1]&~Opcode[0];
             ALUctr[1]<=~Opcode[5]&~Opcode[4]&Opcode[3]&Opcode[2]&~Opcode[1]&Opcode[0];
             ALUctr[0]<=0;
             end
       end  
            
      
           
endmodule

module RegisterFile(
WB_clk,RegWr,Overflow,RegDst,Ra,Rb,Rc,busW,
busA,busB
    );
    input WB_clk;
    input RegWr;
    input Overflow;
    input RegDst;
    //Ra(Rs),Rb(Rt),Rc(Rd)
    input [4:0] Ra;
    input [4:0] Rb;
    input [4:0] Rc;
    
    input [31:0] busW;
    output  reg [31:0] busA;
    output  reg [31:0] busB;
    reg [31:0] RegMem [31:0];//32个32位宽寄存器
    
    //初始化寄存器中的值
    integer i;
    initial 
    begin
//        RegMem[0]<=5;
//        RegMem[1]<=32'b11;
//        RegMem[2]<=32'b10;
        for(i=0;i<32;i=i+1)
            RegMem[i]<=i;
    end
    
    always @(Ra or Rb)
    begin
     busA=RegMem[Ra];
     busB=RegMem[Rb];
    end
    
    always@(posedge WB_clk or RegWr)
    begin
    //RegMem[2]<=2;
        if(RegWr&&!Overflow)
        begin
            if(RegDst)
//                RegMem[2]=2;
                RegMem[Rc]<=busW;
            else
               
                RegMem[Rb]<=busW;
                
        end
     end
    
endmodule

module Extender(
ExtOp,ex_imm,
ex_out
    );
    input ExtOp;
    input [25:0] ex_imm;
    output  [31:0] ex_out;
    assign ex_out=ExtOp?{ {16{ex_imm[15]}} ,ex_imm[15:0]}:{ 16'b0,ex_imm[15:0]};
    //符号扩展
//    always @(ExtOp)
//    begin
//        if(ExtOp)
//            ex_out={ {16{ex_imm[15]}} ,ex_imm[15:0]};
//         else
//            ex_out={ 16'b0,ex_imm[15:0]};
//    end
endmodule

module ALUSrc_select(
ALUSrc,busB,imm36,
src_out
    );
    input ALUSrc;
    input [31:0] busB;
    input [31:0] imm36;
    output [31:0] src_out;
    
    assign src_out=ALUSrc?imm36:busB;
endmodule

module ALU32(
ALU_clk,ALUctr,in0,in1,
carryout,overflow,zero,out
    );
    input ALU_clk;
    input [31:0] in0,in1;
    input [2:0] ALUctr;//控制ALU进行何种操作
    output reg[31:0] out;
    output reg carryout,overflow,zero;
   
always@(posedge ALU_clk)
begin
    case(ALUctr)
        //addu
        3'b000:
            begin
            {carryout,out}=in0+in1;
            zero=(out==0)?1:0;
            overflow=0;
            end
            
        //add
        3'b001:
            begin
            out=in0+in1;
            overflow=((in0[31]==in1[31])&&(~out[31]==in0[31]))?1:0;
            zero=(out==0)?1:0;
            carryout=0;
            end
        //or
        3'b010:
            begin
            out=in0|in1;
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
        //subu
        3'b100:
            begin
            {carryout,out}=in0-in1;
            zero=(out==0)?1:0;
            overflow=0;
            end
        //sub
        3'b101:
            begin
            out=in0-in1;
            overflow=((in0[31]==0&&in1[31]==1&&out[31]==1)||(in0[31]==1&&in1[31]==0&&out[31]==0))?1:0;
            zero=(in0==in1)?1:0;
            carryout=0;
            end
        //sltu
        3'b110:
            begin
                out=(in0<in1)?1:0;
                carryout=out;
                zero=(out==0)?1:0;
                overflow=0;
            end
        //slt
        3'b111:
            begin                        
            if(in0[31]==1&&in1[31]==0)
                out=1;
            else if(in0[31]==0&&in1[31]==1)
                out=0;
            else 
                out=(in0<in1)?1:0;
           overflow=out; 
           zero=(out==0)?1:0;
           carryout=0;              
           end
        /*
        //and
        11'b00000100100:
            begin
            out=in0&in1;
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
       
        //xor
        11'b00000100110:
            begin
            out=in0^in1;
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
        //nor
        11'b00000100111:
            begin
            out=~(in0|in1);
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
        
        //shl
        11'b00000000100:
            begin
            {carryout,out}=in0<<in1;
            overflow=0;
            zero=(out==0)?1:0;
            end
        //shr
        11'b00000000110:
            begin
            out=in0>>in1;
            carryout=in0[in1-1];
            overflow=0;
            zero=(out==0)?1:0;
            end
        //sar
        11'b00000000111:
            begin
            out=($signed(in0))>>>in1;
            carryout=in0[in1-1];
            overflow=0;
            zero=(out==0)?1:0;
            end
        */
    endcase
end
endmodule

module DataMem(
MEM_clk,WrEn,Adr,DataIn,
DataOut
    );
    input MEM_clk;
    input WrEn;
    input [31:0] Adr;
    input [31:0] DataIn;
    output reg [31:0] DataOut;
    //32个32位宽寄存器
    reg [31:0] memory[0:31];
    integer i;
    initial
    begin
        for(i=0;i<32;i=i+1)
            memory[i]<=0;
    end
    
    always@ (posedge MEM_clk)
    begin
        if(WrEn==0)
            DataOut=memory[Adr];
        else
            memory[Adr]=DataIn;
    end
    
endmodule

module Data_select(
MemorReg,ALU_out,DataMem_out,
Data_out
    );
    input MemorReg;
    input [31:0] ALU_out;
    input [31:0] DataMem_out;
    output [31:0] Data_out;
    
    assign Data_out=MemorReg?DataMem_out:ALU_out;
endmodule
