module MUX4_4(Select,A,B,C,D,S);
    input [1:0] Select;
    input[3:0] A,B,C,D;
    output reg[3:0] S;
    always @(*)
        begin
            case(Select)
                2'b00: S <= A;
                2'b01: S <= B;
                2'b10: S <= C;
                2'b11: S <= D;
                default: S <= 4'bz;
            endcase
        end
endmodule