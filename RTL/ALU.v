module alu #(parameter WIDTH = 8)
(
    input wire [WIDTH-1 : 0] in_a , in_b ,
    input wire [2:0] opcode ,
    output reg [WIDTH-1 : 0] alu_out ,
    output reg a_is_zero 
);

always @(*) begin
    
if (in_a == 0)
    a_is_zero = 1 ;
    else
    a_is_zero = 0;

    case (opcode) 

    3'b010: alu_out = in_a + in_b;
    3'b011: alu_out = in_a & in_b;
    3'b100: alu_out = in_a ^ in_b;
    3'b101: alu_out = in_b;
    default : alu_out = in_a;
    endcase


end

endmodule
