module CU(Op,S,PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst,NS);
input [5:0] Op;
input [3:0] S;
output reg PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,ALUSrcA,RegWr,RegDst;
output reg[1:0] PCSrc,ALUOp,ALUSrcB;
output reg[3:0] NS;
always@(*) begin
    case(S)
        4'b0000: begin
        {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b1001_0100_0000_1000;
        NS=4'b0001;
        end
        4'b0001:begin
        {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0000_0000_0001_1000;
        case(Op)
            6'b000010:NS=4'b1001;
            6'b000100:NS=4'b1000;
            6'b000000:NS=4'b0110;
            6'b101011:NS=4'b0010;
            6'b100011:NS=4'b0010;
        endcase
        end
        4'b0010:begin
        {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0000_0000_0001_0100;
        case(Op)
            6'b100011:NS=4'b0011;
            6'b101011:NS=4'b0101;
        endcase
        end
        4'b0011:begin
            {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0011_0000_0000_0000;
            NS=4'b0100;
        end
        4'b0100:begin
            {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0000_0010_0000_0010;
            NS=4'b0000;
        end
        4'b0101:begin
            {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0010_1000_0000_0000;
            NS=4'b0000;
        end
        4'b0110:begin
            {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0000_0000_0100_0100;
            NS=4'b0111;
        end
        4'b0111:begin
           {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0000_0000_0000_0011;
           NS=4'b0000;
        end
        4'b1000:begin
            {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b0100_0000_1010_0100;
            NS=4'b0000;
        end
        4'b1001:begin
            {PCWr,PCWrCond,IorD,MemRd,MemWr,IRWr,MemtoReg,PCSrc,ALUOp,ALUSrcB,ALUSrcA,RegWr,RegDst}=16'b1000_0001_0000_0000;
            NS=4'b0000;
        end 
    endcase
end
endmodule