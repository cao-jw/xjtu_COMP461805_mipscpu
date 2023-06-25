module PC #(parameter WIDTH=32)(
//author:XJTU mry
    input clk,reset,
    input [WIDTH-1:0] d,
    output reg[WIDTH-1:0] q
    );
    always @(posedge clk,posedge reset)
    if(reset)q<=0;
    else q<=d;
endmodule

module PC_adder(
    adr,n_adr
    );
    //author:XJTU mry
    input [31:0] adr;
    output [31:0] n_adr;
    assign n_adr = adr + 32'd4;
endmodule

module codeRAM(
    address,data
    );
    //author:XJTU mry
        parameter DataWidth=32;
    parameter AddrWidth=32;
    parameter DataDepth=32;
    
    input [AddrWidth-1:0] address;

    output [DataWidth-1:0] data;
    //reg[4:0] n;
    //reg [DataWidth-1:0] data_out;
    reg [DataWidth-1:0] men [0:DataDepth-1];
    assign data=men[address[6:2]];
  
    initial 
    begin
        men[0]=32'h20020005;
        men[1]=32'h2003000c;
        men[2]=32'h2067fff7;
        men[3]=32'h00e22025;
        men[4]=32'h00642824;
        men[5]=32'h00a42820;
        men[6]=32'h10a7000a;
        men[7]=32'h0064202a;
        men[8]=32'h10800001;
        men[9]=32'h20050000;
        men[10]=32'h00e2202a;
        men[11]=32'h10800001;
        men[12]=32'h20050000;
        men[13]=32'h00e2202a;
        men[14]=32'h00853820;
        men[15]=32'h00e23822;
        men[16]=32'hac670044;
        men[17]=32'h8c020050;
        men[18]=32'h08000011;
        men[19]=32'h20020001;
        men[20]=32'hac020054;
    end
endmodule

module mainDec(
//author:XJTU mry
    input [5:0] op,
    output mentoreg,menwrite,
    output branch,alusrc,
    output regdst,regwrite,
    output jump,
    output [1:0] aluop
    );
    reg [8:0] controls;
    assign{regwrite,regdst,alusrc,branch,menwrite,mentoreg,jump,aluop}=controls;
    always @(*)
        case(op)
            6'b000000:controls<=9'b110000010; //R
            6'b100011:controls<=9'b101001000;//lw
            6'b101011:controls<=9'b001010000; //sw
            6'b000100:controls<=9'b000100001; //beq
            6'b001000:controls<=9'b101000000; //addi
            6'b000010:controls<=9'b000000100; //jmp
            default:controls<=9'bxxxxxxxxx;
        endcase
endmodule

module MUX6(
//author:XJTU mry
    A,B,Src,S
    );
    input [4:0] A,B;
    input Src;
    output [4:0] S;
    assign S = (Src==0) ? A:B;
endmodule

module RegisterUnit(
//author:XJTU mry
    clk,we,ra1,ra2,wa3,wd,rd1,rd2
    );
    parameter DataWidth=32;
    parameter AddrWidth=5;
    parameter DataDepth=1<<AddrWidth;
        input clk;
        input we;
        input [AddrWidth-1:0] ra1,ra2,wa3;
        input [DataWidth-1:0] wd;
        output [DataWidth-1:0] rd1,rd2;
        reg [DataWidth-1:0] rf [DataDepth-1:0];
        assign rd1=rf[ra1];
        assign rd2=rf[ra2];
        always @ (posedge clk)
        begin :MEM_WRITE
            if(we)begin
                rf[wa3]=wd;
            end
        end
        initial 
            begin
                rf[0]=32'h0;
                rf[1]=32'h0;
                rf[2]=32'h0;
                rf[3]=32'h0;
                rf[4]=32'h0;
                rf[5]=32'h0;
                rf[6]=32'h0;
                rf[7]=32'h0;
                rf[8]=32'h0;
                rf[9]=32'h0;
                rf[10]=32'h0;
                rf[11]=32'h0;
                rf[12]=32'h0;
                rf[13]=32'h0;
                rf[14]=32'h0;
                rf[15]=32'h0;
                rf[16]=32'h0;
            end

endmodule

module Extend16to32(
//author:XJTU mry
    order,addr
    );
    input [15:0] order;
    output reg [31:0] addr;
     
    always @(order)//complement
    begin
       if(order[15]==1) addr[31:16]=16'b1111111111111111;
    else addr[31:16]=16'b0000000000000000;
        addr[15:0]=order[15:0];
    end
endmodule

module MUX32(
//author:XJTU mry
A,B,Src,S
    );
    input [31:0] A,B;
    input Src;
    output [31:0] S;
    assign S = (Src==0) ? A:B;
endmodule

module aluDec(
//author:XJTU mry
    input [5:0]funct,
    input [1:0]aluop,
    output reg [3:0] alucontrol
    );
    always @(*)
        case(aluop)
            2'b00:alucontrol<=3'b0010;
            2'b01:alucontrol<=3'b0011;
        default:case(funct)
                    6'b100000:alucontrol<=4'b0010;//ADD
                    6'b100001:alucontrol<=4'b0000;//ADDU
                    6'b100010:alucontrol<=4'b0011;//SUB
                    6'b100011:alucontrol<=4'b0001;//SUBU
                    6'b100100:alucontrol<=4'b0100;//AND
                    6'b100101:alucontrol<=4'b0101;//OR
                    6'b100110:alucontrol<=4'b0110;//XOR
                    6'b100111:alucontrol<=4'b0111;//NOR
                    6'b101010:alucontrol<=4'b1011;//SLT
                    6'b101011:alucontrol<=4'b1010;//SLTU
                    default:alucontrol<=4'bxxxx;
                endcase
         endcase
endmodule

module alu(
//author:XJTU mry
        input [31:0] a,        //OP1
        input [31:0] b,        //OP2
        input [3:0] aluc,    //controller
        output [31:0] r,    //result
        output zero,
        output carry,
        output negative,
        output overflow);
        
    parameter Addu    =    4'b0000;    //r=a+b unsigned
    parameter Add    =    4'b0010;    //r=a+b signed
    parameter Subu    =    4'b0001;    //r=a-b unsigned
    parameter Sub    =    4'b0011;    //r=a-b signed
    parameter And    =    4'b0100;    //r=a&b
    parameter Or    =    4'b0101;    //r=a|b
    parameter Xor    =    4'b0110;    //r=a^b
    parameter Nor    =    4'b0111;    //r=~(a|b)
    //parameter Lui1    =    4'b1000;    //r={b[15:0],16'b0}
    //parameter Lui2    =    4'b1001;    //r={b[15:0],16'b0}
    parameter Slt    =    4'b1011;    //r=(a-b<0)?1:0 signed
    parameter Sltu    =    4'b1010;    //r=(a-b<0)?1:0 unsigned
    parameter Sra    =    4'b1100;    //r=b>>>a 
    parameter Sll    =    4'b1110;    //r=b<<a
    parameter Srl    =    4'b1101;    //r=b>>a
    
    parameter bits=31;
    parameter ENABLE=1,DISABLE=0;
    
    reg [32:0] result;
    wire signed [31:0] sa=a,sb=b;
    
    always@(*)begin
        case(aluc)
            Addu: begin
                result=a+b;
            end
            Subu: begin
                result=a-b;
            end
            Add: begin
                result=sa+sb;
            end
            Sub: begin
                result=sa-sb;
            end
            Sra: begin
                if(a==0) {result[31:0],result[32]}={b,1'b0};
                else {result[31:0],result[32]}=sb>>>(a-1);
            end
            Srl: begin
                if(a==0) {result[31:0],result[32]}={b,1'b0};
                else {result[31:0],result[32]}=b>>(a-1);
            end
            Sll: begin
                result=b<<a;
            end
            And: begin
                result=a&b;
            end
            Or: begin
                result=a|b;
            end
            Xor: begin
                result=a^b;
            end
            Nor: begin
                result=~(a|b);
            end
            Sltu: begin
                result=a<b?1:0;
            end
            Slt: begin
                result=sa<sb?1:0;
            end
            //Lui1,Lui2: result = {b[15:0], 16'b0};
            default:
                result=a+b;
        endcase
    end
    
    assign r=result[31:0];
    assign carry = result[32]; 
    assign zero=(r==32'b0)?1:0;
    assign negative=result[31];
    assign overflow=result[32];
endmodule

module RAM(
//author:XJTU mry
clk,address,data_in,data,we
    );
    parameter DataWidth=32;
    parameter AddrWidth=32;
    parameter DataDepth=32;
    input clk;
    input [AddrWidth-1:0] address;

    input we;
    input [DataWidth-1:0] data_in;
    output [DataWidth-1:0] data;
    
    reg [DataWidth-1:0] data_out;
    reg [DataWidth-1:0] men [0:DataDepth-1];
    assign data=(!we) ? data_out:8'bz;
    always @ (posedge clk)
    begin :MEM_WRITE
        if(we)begin
            men[address[6:2]]=data_in;
        end
    end
    
    always @ (posedge clk)
    begin :MEM_READ
        if(!we)begin
            data_out=men[address[6:2]];//?
        end
    end
endmodule

module Left2(data,odata);
//author:XJTU mry
 input [31:0] data;
 output reg [31:0] odata;

 always @(data)
 begin
    odata[31:2]<=data[29:0];
  odata[1:0]<=2'b00;
 end
endmodule

module ALU_Add_32(addr1,addr2,out_addr);
 input [31:0] addr1,addr2;
 output [31:0] out_addr;
 assign out_addr = addr1+addr2;
endmodule

module myand(
//author:XJTU mry
R,A,B
    );
    input A,B;
    output  R;
    assign R=A&B;
endmodule

module Left2_26(data,data1,odata);
//author:XJTU mry
 input [25:0] data;
 input [3:0] data1;
 output reg [31:0] odata;
 
 always @(data,data1)
 begin
    odata[27:2]<=data[25:0];
  odata[1:0]<=2'b00;
  odata[31:28]<=data1[3:0];
 end
endmodule

module CPU(
clk,rst,out_ALU,Read_Data1,Read_Data2,Address_in_PC,Address_out_PC,Address_Add_PC,Order,Read_Data_Mem,Order_Left,zero
    );
     input clk;
     input rst;
     //output [6:0] data1,data2,data3,data4;
     output [31:0]out_ALU;
     output [31:0] Read_Data1,Read_Data2,Address_in_PC,Address_out_PC,Address_Add_PC,Order,Read_Data_Mem,Order_Left;
     output zero;
     wire [31:0] Read_Data1;
     wire [31:0] Read_Data2;
     wire [31:0] Address_in_PC,Address_out_PC;//用于PC的输入和输出
     wire [31:0] Address_Add_PC;//用于程序计数器正常指令进行加4的输出
     wire [31:0] Order;//用于指令存储器的指令输出
     wire RegDst,Jump,Branch,MemtoReg,ALUSrc,RegWrite,MemWrite;//用于对控制信号的连线
     wire [1:0] ALUop;//控制信号ALUop的连线
     wire [4:0] Write_register;//寄存器堆中写入寄存器所在的位号的连线
     wire [31:0] Write_Data;//Read_Data1,Read_Data2;//寄存器堆中的连线
     wire [31:0] sign,out_sign,ALU1,out_ALU;
     wire [31:0] ALU_Add_32_out,Branch_or_normal;
     wire [3:0] ALU_ctr;
     wire [31:0] Read_Data_Mem;
     wire [31:0] Order_Left;
     wire zero,Mux32_EN;
     wire carry,negative,overflow;
     
     //PC(CLK,Address_in_PC,Address_out_PC,rst);
     PC pc(.clk(clk),.reset(rst),.d(Address_in_PC),.q(Address_out_PC));
      //Add_PC(Address_out_PC,Address_Add_PC);
      PC_adder pc_adder(.adr(Address_out_PC),.n_adr(Address_Add_PC));
      //Order_Mem(Address_out_PC,Order);
      codeRAM coderam(.address(Address_out_PC),.data(Order));
      //Control_Unit(Order[31:26],RegDst,Jump,Branch,MemRead,MemtoReg,ALUop,MemWrite,ALUSrc,RegWrite);
      mainDec maindec(.op(Order[31:26]),.mentoreg(MemtoReg),.menwrite(MemWrite),.branch(Branch),.alusrc(ALUSrc),.regdst(RegDst),.regwrite(RegWrite),.jump(Jump),.aluop(ALUop));
      //Mux_6(Order[20:16],Order[15:11],RegDst,Write_register);
      MUX6 mux6(.A(Order[20:16]),.B(Order[15:11]),.Src(RegDst),.S(Write_register));
      //Registers(Order[25:21],Order[20:16],Write_register,Write_Data,Read_Data1,Read_Data2,RegWrite,CLK);
      RegisterUnit ru(.clk(clk),.we(RegWrite),.ra1(Order[25:21]),.ra2(Order[20:16]),.wa3(Write_register),.wd(Write_Data),.rd1(Read_Data1),.rd2(Read_Data2));
      //sign_ep(Order[15:0],sign);
      Extend16to32 extend16to32(.order(Order[15:0]),.addr(sign));
      //Mux_32(Read_Data2,sign,ALUSrc,ALU1);
      MUX32 mux32_1(.A(Read_Data2),.B(sign),.Src(ALUSrc),.S(ALU1));
      //ALU_Control(ALUop,Order[5:0],ALU_ctr);
      aluDec aludec(.funct(Order[5:0]),.aluop(ALUop),.alucontrol(ALU_ctr));
      //ALU(ALU_ctr,Read_Data1,ALU1,zero,out_ALU);
      alu ALU(.a(Read_Data1),.b(ALU1),.aluc(ALU_ctr),.r(out_ALU),.zero(zero),.carry(carry),.negative(negative),.overflow(overflow));
      //Data_Mem(out_ALU,Read_Data2,Read_Data_Mem,CLK,MemWrite,MemRead);
      RAM ram(.clk(clk),.address(out_ALU),.data_in(Read_Data2),.data(Read_Data_Mem),.we(MemWrite));
      //Mux_32(out_ALU,Read_Data_Mem,MemtoReg,Write_Data);
      MUX32 MUX32_2(.A(out_ALU),.B(Read_Data_Mem),.Src(MemtoReg),.S(Write_Data));
      Left2 left2(.data(sign),.odata(out_sign));
      ALU_Add_32 aluadd32(.addr1(Address_Add_PC),.addr2(out_sign),.out_addr(ALU_Add_32_out));
      myand myand_(.R(Mux32_EN),.A(Branch),.B(zero));
      //Mux_32(Address_Add_PC,ALU_Add_32_out,Mux32_EN,Branch_or_normal);
      MUX32 mux32_3(.A(Address_Add_PC),.B(ALU_Add_32_out),.Src(Mux32_EN),.S(Branch_or_normal));
      Left2_26 left2_26(.data(Order[25:0]),.data1(Address_Add_PC[31:28]),.odata(Order_Left));
      //Mux_32(Branch_or_normal,Order_Left,Jump,Address_in_PC);
      MUX32 mux32_4(.A(Branch_or_normal),.B(Order_Left),.Src(Jump),.S(Address_in_PC));
endmodule

module sim_cpu(
//author:XJTU mry
    );
    reg  clk;
    reg rst;
         //output [6:0] data1,data2,data3,data4;
    wire [31:0]out_ALU;
    wire [31:0] Read_Data1,Read_Data2,Address_in_PC,Address_out_PC,Address_Add_PC,Order,Read_Data_Mem,Order_Left;
    wire zero;
    CPU cpu(
    .clk(clk),
    .rst(rst),
    .out_ALU(out_ALU),
    .Read_Data1(Read_Data1),
    .Read_Data2(Read_Data2),
    .Address_in_PC(Address_in_PC),
    .Address_out_PC(Address_out_PC),
    .Address_Add_PC(Address_Add_PC),
    .Order(Order),
    .Read_Data_Mem(Read_Data_Mem),
    .Order_Left(Order_Left),
    .zero(zero)
    );
    initial begin 
    $dumpfile("simcpu.vcd");
    $dumpvars;
    end
    always begin
        #10 clk=~clk;
    end
    initial begin
            clk=0;
            rst=0;
            #10;
            //clk=0;
            rst=1;
            #10;
            //clk=0;
            rst=0;
    end
    always begin
        #10 if($time>=1000)
        $finish;
    end
endmodule
