`default_nettype none
module control (
    input wire [2:0] phase,opcode,
    input wire zero,rst, clk ,
    output reg sel , rd , ld_ir , inc_pc , halt , ld_ac , data_e , ld_pc , wr
);
    reg ALUOP , SKZ ,JMP , STO ,HALT;

always @(*)begin
    ALUOP = (opcode == 2) || (opcode == 3) || (opcode == 4) || (opcode == 5);
    SKZ = (opcode == 3'b001);
    HALT = (opcode == 3'b000);
    STO = (opcode == 3'b110);
    JMP = (opcode == 3'b111);

end


always@(*) begin
 if (rst) begin
     sel=1;rd=0;ld_ir=0;inc_pc=0;halt=0;ld_pc=0;data_e=0;ld_ac=0;wr=0; 
     end   
case (phase)
3'b000: begin sel=1;rd=0;ld_ir=0;inc_pc=0;halt=0;ld_pc=0;data_e=0;ld_ac=0;wr=0; end
3'b001: begin sel=1;rd=1;ld_ir=0;inc_pc=0;halt=0;ld_pc=0;data_e=0;ld_ac=0;wr=0;  end
3'b010 , 3'b011: begin sel=1;rd=1;ld_ir=1;inc_pc=0;halt=0;ld_pc=0;data_e=0;ld_ac=0;wr=0;  end
3'b100: begin sel=0;rd=0;ld_ir=0;inc_pc=1;halt=HALT;ld_pc=0;data_e=0;ld_ac=0;wr=0;  end
3'b101: begin sel=0;rd=ALUOP;ld_ir=0;inc_pc=0;halt=0;ld_pc=0;data_e=0;ld_ac=0;wr=0;  end
3'b110: begin sel=0;rd=ALUOP;ld_ir=0;inc_pc=SKZ&zero ;halt=0;ld_pc=JMP;data_e=STO;ld_ac=0;wr=0;  end
3'b111: begin sel=0;rd=ALUOP;ld_ir=0;inc_pc=0;halt=0;ld_pc=JMP;data_e=STO;ld_ac=ALUOP;wr=STO;  end
endcase

end



endmodule