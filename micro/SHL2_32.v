module SHL2_32(data,odata);
 input [31:0] data;
 output reg [31:0] odata;

 always @(data)
 begin
    odata[31:2]<=data[29:0];
  odata[1:0]<=2'b00;
 end
endmodule
