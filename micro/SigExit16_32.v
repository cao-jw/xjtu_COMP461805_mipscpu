module SigExit16_32(
    Inst,Addr
    );
    input [15:0] Inst;
    output reg [31:0] Addr;
     
    always @(Inst)
    begin
       if(Inst[15]==1) Addr[31:16]=16'b1111111111111111;
    else Addr[31:16]=16'b0000000000000000;
        Addr[15:0]=Inst[15:0];
    end
endmodule
