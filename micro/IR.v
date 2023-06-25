module IR(
   CLK, D,IRWr,Inst    
);
    input [31:0] D;
    input CLK,IRWr;
    output[31:0] Inst;
    reg[31:0] Inst;
    //initial Inst=0;
    always @(posedge CLK)
    if(IRWr) Inst=D;
    endmodule