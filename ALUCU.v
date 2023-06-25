module ALUCU(
    input [5:0]funct,
    input [1:0]ALUOp,
    output reg [2:0] ALUCtrl
    );
    always @(*)
        case(ALUOp)
            2'b00:ALUCtrl<=3'b100;//add
            2'b01:ALUCtrl<=3'b110;//sub
        default:case(funct)
                    6'b100000:ALUCtrl<=3'b100;//ADD
                    6'b100001:ALUCtrl<=3'b101;//ADDU
                    6'b100010:ALUCtrl<=3'b110;//SUB
                    6'b100100:ALUCtrl<=3'b000;//AND
                    6'b100101:ALUCtrl<=3'b001;//OR
                    6'b101010:ALUCtrl<=3'b011;//SLT
                    default:ALUCtrl<=3'bxxx;
                endcase
         endcase
endmodule
