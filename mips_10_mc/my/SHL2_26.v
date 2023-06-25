module SHL2_26(data,data1,odata);
 input [25:0] data;
 input [3:0] data1;
 output reg [31:0] odata;
 
 always @(data,data1)
 begin
    odata[27:2]<=data[25:0];
  odata[1:0]<=2'b00;
  odata[31:28]<=data1[3:0];
 end
endmodule
