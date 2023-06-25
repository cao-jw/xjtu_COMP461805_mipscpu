module RAM(
Addr,R_data,R,W,W_data
    );
    parameter DataWidth=32;
    parameter AddrWidth=32;
    parameter DataDepth=256;
    input CLK;
    input [AddrWidth-1:0] Addr;

    input W,R;
    input [DataWidth-1:0] W_data;
    output [DataWidth-1:0] R_data;
    
    reg [DataWidth-1:0] data_out;
    reg [DataWidth-1:0] mem [0:DataDepth-1];
    assign R_data=(R) ? data_out:8'bz;
    always@(*)
    begin :MEM_WRITE
        if(W)begin
            mem[Addr[9:2]]=W_data;
        end
    end

    always@(*)
    begin :MEM_READ
        if(R)begin
            data_out=mem[Addr[9:2]];
        end
    end
endmodule
