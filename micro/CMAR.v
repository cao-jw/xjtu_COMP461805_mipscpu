module CMAR(CLK,AddrInCMAR,AddrOutCMAR,Rst);
input[3:0] AddrInCMAR;
input CLK,Rst;
output reg[3:0] AddrOutCMAR;
always@(posedge CLK,posedge Rst) begin
    if(Rst) AddrOutCMAR<=4'b0000;
    else
    AddrOutCMAR<=AddrInCMAR;
end
endmodule