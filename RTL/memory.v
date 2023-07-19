`default_nettype none
module memory #(parameter AWIDTH=5, 
                parameter DWIDTH=8)
(
    input wire [AWIDTH-1:0] addr ,
    input wire wr , rd , clk ,
    inout wire [DWIDTH-1 : 0] data 
);


reg [DWIDTH-1 : 0] array [(2**AWIDTH)-1 : 0] ;

always @(posedge clk) begin
    if (wr) 
        array[addr] = data;
end

assign data = rd?  array[addr] : 'bz;

endmodule