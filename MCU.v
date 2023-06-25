module MCU(
    input [5:0] op,
    output MemtoReg,MemWr,MemRd,
    output Branch,ALUSrc,
    output RegDst,RegWr,
    output Jump,
    output [1:0] ALUOp
    );
    reg [9:0] controls;
    assign{RegDst,RegWr,ALUSrc,MemRd,MemWr,MemtoReg,Branch,Jump,ALUOp}=controls;
    always @(*)
        case(op)
            6'b000000:controls<=10'b1100000010;//R
            6'b100011:controls<=10'b0111010000;//LW
            6'b101011:controls<=10'bx0101x0000;//SW
            6'b000100:controls<=10'bx0000x1001;//beq
            6'b000010:controls<=10'bx0x00x01xx;//j
        endcase
endmodule
