module IM(
    input [31:0] IM_addr,
    output [31:0] inst);
reg [7:0] Imemory[0:255];
reg [31:0] inst;
reg [7:0] tempaddr;
initial begin
    Imemory[0]=8'b00000000;
    Imemory[1]=8'b00000000;
    Imemory[2]=8'b00000000;
    Imemory[3]=8'b00001000;
end
always@(*)begin
    tempaddr = IM_addr[7:0];
    inst[7:0] = Imemory[tempaddr];
    inst[15:8] = Imemory[tempaddr+1];
    inst[23:16] = Imemory[tempaddr+2];
    inst[31:24] = Imemory[tempaddr+3];
end
endmodule