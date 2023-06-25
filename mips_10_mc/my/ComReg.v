module ComReg(D,CLK,Q);
input CLK;
input [31:0] D;
output [31:0] Q;
reg [31:0] Q;
always@(posedge CLK) begin
    Q<=D;
end
    endmodule
