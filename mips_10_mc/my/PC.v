module PC #(parameter WIDTH=32)(
    input CLK,Rst,PCW,
    input [WIDTH-1:0] D,
    output reg[WIDTH-1:0] Q
    );
    initial begin 
        Q=0;
    end
    always @(posedge CLK,posedge Rst)
    if(Rst) begin
        Q<=0;
    end
    else 
    if(PCW) Q<=D;
endmodule