module register #(parameter  WIDTH  = 8 )
(
    input wire [WIDTH-1 : 0] data_in ,
    input wire rst ,clk ,load ,
    output reg [WIDTH-1 : 0 ]data_out
);

always @(posedge clk) begin
    
    if (rst)
    data_out<=0;
    else begin
        if (load) begin
            data_out <= data_in;
        end
    end
end
endmodule
