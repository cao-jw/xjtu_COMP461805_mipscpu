module PC #(parameter WIDTH=32)(
    input CLK,RST,PCW,
    input [WIDTH-1:0] D,
    output reg[WIDTH-1:0] Q
    );
    reg [31:0] PCreg;
    initial begin 
        PCreg=0;
    end
    always @(posedge CLK,posedge RST)
    if(RST) begin
        Q<=0;
        PCreg<=0;
    end
    else if(posedge CLK&&) 
    else if(CLK&&PCW)Q<=D;
endmodule