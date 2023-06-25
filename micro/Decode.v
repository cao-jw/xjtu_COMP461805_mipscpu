module Decode(
    input[2:0] code,
    output reg MemWr,IRWr,MemtoReg,RegDst,
    output reg[1:0] PCSrc);
    always@(*)
    case(code)
    3'b001:{MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b000001;
    3'b010:{MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b000010;
    3'b011:{MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b000100;
    3'b100:{MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b001000;
    3'b101:{MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b100000;
    3'b110:{MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b010000;
    default {MemWr,IRWr,MemtoReg,PCSrc,RegDst}=6'b000000;
        
    endcase
    endmodule