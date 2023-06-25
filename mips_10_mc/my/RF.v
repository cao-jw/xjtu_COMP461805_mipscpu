module RF(
    CLK,W_data,R_Reg1,R_Reg2,W_Reg,R_data1,R_data2,W
    );
    parameter DataWidth=32;
    parameter AddrWidth=5;
    parameter DataDepth=1<<AddrWidth;
        input CLK;
        input W;
        input [AddrWidth-1:0] R_Reg1,R_Reg2,W_Reg;
        input [DataWidth-1:0] W_data;
        output [DataWidth-1:0] R_data1,R_data2;
        reg [DataWidth-1:0] rf [DataDepth-1:0];
        integer i;
        assign R_data1=rf[R_Reg1];
        assign R_data2=rf[R_Reg2];
        always @ (posedge CLK)
        begin :MEM_WRITE
            if(W)begin
                rf[W_Reg]=W_data;
            end
        end
        initial begin
            for(i=0;i!=DataDepth;i=i+1) begin
                rf[i]=i;
            end
        end
endmodule
