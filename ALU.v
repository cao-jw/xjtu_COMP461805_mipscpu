module ALU(
        input [31:0] A,        //OP1
        input [31:0] B,        //OP2
        input [2:0] Mod,    //controller
        output [31:0] C,    //result
        output Z,//zero
        output O);//overflow
        
    parameter Add    =    3'b100;//add 
    parameter Sub    =    3'b110;//sub
    parameter Addu    =    3'b100;//addu
    parameter And    =    3'b000;//and
    parameter Or    =    3'b001;//or
    parameter Slt    =    3'b011;//slt 
    
    parameter bits=31;
    //parameter ENABLE=1,DISABLE=0;
    
    reg [32:0] result;
    wire signed [31:0] SA=A,SB=B;
    
    always@(*)begin
        case(Mod)
            Addu: begin
                result=A+B;
            end
            Add: begin
                result=SA+SB;
            end
            Sub: begin
                result=SA-SB;
            end
            And: begin
                result=A&B;
            end
            Or: begin
                result=A|B;
            end
            Slt: begin
                result=SA<SB?1:0;
            end
            default:
                result=A+B;
        endcase
    end
    
    assign C=result[31:0];
    assign Z=(C==32'b0)?1:0;
    assign O=result[32];
endmodule
