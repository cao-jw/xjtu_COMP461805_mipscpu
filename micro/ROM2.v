module ROM2(Op,MUX2);
input[5:0] Op;
output reg[3:0] MUX2;
always@(*) begin
    case(Op) 
    6'b100011:MUX2=4'b0011;
    6'b101011:MUX2=4'b0101;
endcase
end
endmodule
