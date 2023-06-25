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
    integer  i;
    initial begin
    for(i=0;i!=256;i=i+1) mem[i]=0;
    end
    assign R_data=(R) ? data_out:8'bz;
    always@(*)
    begin :MEM_WRITE
        if(W)begin
            mem[Addr[9:2]]=W_data;
        end
    end

    always@(*)
    begin :MEM_READ
            data_out=mem[Addr[9:2]];
    end

    initial begin
        mem[0]=32'h00421821;//
        mem[1]=32'h00621822;//
        mem[2]=32'h00851820;//
        mem[3]=32'h00831824;//
        mem[4]=32'h00641020;//
        mem[5]=32'h08000007;//
        mem[6]=32'h00851825;//
        mem[7]=32'hac832710;//
        mem[8]=32'h8c842710;//
        mem[9]=32'h1063fff7;//
    end

endmodule