module CodeRam(
    input [31:0] Addr, output [31:0] Inst
    );
    
    reg [31:0] mem [0:255];
    reg [7:0] tempaddr;
    reg [31:0] Inst;
    
    initial begin
        mem[0]=32'h00421821;//
        mem[1]=32'h00621822;//
        mem[2]=32'h00851820;//
        mem[3]=32'h00831824;//
        mem[4]=32'h00641020;//
        mem[5]=32'h00851825;//
        mem[6]=32'h00851826;//
        mem[7]=32'h00851827;//
        mem[8]=32'h0800000a;//
        mem[9]=32'h00851825;//
        mem[10]=32'hac83003c;//
        mem[11]=32'h8c84003c;//
        mem[12]=32'h1063fff4;//
    end
    
    always@(*) begin
        tempaddr[7:0]=Addr[9:2];
        Inst[31:0]=mem[tempaddr];
    end

endmodule
