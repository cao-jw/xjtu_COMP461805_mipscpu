module ROM1(Op,MUX1);
input[5:0] Op;
output reg [3:0] MUX1;
always@(*) begin
case(Op)
    6'b000000:MUX1=4'b0110;
    6'b000010:MUX1=4'b1001;
    6'b000100:MUX1=4'b1000;
    6'b100011:MUX1=4'b0010;
    6'b101011:MUX1=4'b0010;
    default :MUX1=4'bzzzz;
        
endcase
end
endmodule