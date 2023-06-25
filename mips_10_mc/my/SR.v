module SR(CLK,S,NS,Rst);
input CLK,Rst;
input [3:0] NS;
output reg[3:0] S ;
always@(posedge CLK,posedge Rst ) begin
    if(Rst) begin
    S<=4'b0000;
    end
    else 
    S=NS;
    end
    initial begin
        S=4'b0000;
    end
    endmodule
