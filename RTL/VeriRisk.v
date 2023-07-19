/*
`define "ALU.v"
`define "control_unit.v"
`define "counter.v"
`define "memory.v"
`define "multiplexor.v"
`define "register_file.v"
`define "tri_state_buffer.v"
*/

`default_nettype none

module VeriRISC(
    input wire clk , rst,
    output wire halt
);

localparam DATA_WIDTH = 8 ;
localparam ADDR_WIDTH = 5 ;
localparam OPCODE_WIDTH = 3;

//wires of phase generator
wire [2:0] phase ;

//wires of controller
wire sel , rd , ld_ir , inc_pc  , ld_ac , data_e , ld_pc , wr , zero ;
wire [OPCODE_WIDTH-1:0] opcode;

//wires of ALU
wire [DATA_WIDTH-1 : 0] ac_out  , alu_out ;

//wires of memory
wire [ADDR_WIDTH-1 : 0] addr ;
wire [DATA_WIDTH-1 : 0] data ;


//wire of MUX
wire [ADDR_WIDTH-1 : 0] pc_addr;

//wires of instruction register
wire [ADDR_WIDTH-1 : 0] ir_addr;

//instantiate the phase_generator

//3 bec I count here from 0 to 7
counter #(.WIDTH(3)) phase_generator
(
    .clk(clk),
    .rst(rst),
    .load(1'b0),
    .enab(1'b1),
    .cnt_in('b0),
    .cnt_out(phase)
);


// instantiate the controller
controller controller_inst 
(
    .phase(phase) ,
    .opcode(opcode) ,
    .zero(zero) ,
    .sel(sel) ,
    .data_e(data_e) , 
    .halt(halt) ,
    .inc_pc(inc_pc) ,
    .ld_pc(ld_pc) ,
    .ld_ac(ld_ac) ,
    .ld_ir(ld_ir) ,
    .wr(wr) ,
    .rd(rd)
);

//instantiate the memory

memory #(.AWIDTH(ADDR_WIDTH), .DWIDTH(DATA_WIDTH)) memory_inst
(
    .clk(clk) ,
    .rd(rd) ,
    .wr(wr) ,
    .addr(addr) ,
    .data(data)
);


//instantiate the address mux 

multiplexor #(.WIDTH(ADDR_WIDTH)) address_mux
(
    .sel(sel) ,
    .in0(ir_addr) ,
    .in1(pc_addr) ,
    .mux_out(addr)
);

//instantiate the counter_pc

//5 bec I count here upto 32
counter #(.WIDTH(5)) counter_pc
(
    .clk(clk) ,
    .rst(rst) ,
    .load(ld_pc) ,
    .enab(inc_pc) ,
    .cnt_in(ir_addr) ,
    .cnt_out(pc_addr)
);

//instantiate the register_ir
register #(.WIDTH(DATA_WIDTH)) register_ir
(
    .data_in(data) ,
    .clk(clk) ,
    .rst(rst) ,
    .load(ld_ir) ,
    .data_out({opcode,ir_addr})
);

//instantiate the alu_inst
alu #(.WIDTH(DATA_WIDTH) ) alu_inst 
(
    .in_a(ac_out) ,
    .in_b(data) ,
    .opcode(opcode) ,
    .alu_out(alu_out) ,
    .a_is_zero(zero)
);

//instantiate the register_ac

register #(.WIDTH(DATA_WIDTH)) register_ac
(
    .clk(clk) ,
    .rst(rst) ,
    .load(ld_ac) ,
    .data_in(alu_out) ,
    .data_out(ac_out)
);


//instantiate the register_ac
tri_state_buffer #(.IN_WIDTH(DATA_WIDTH) , 
                   .OUT_WIDTH(DATA_WIDTH)) driver_inst
(
    .data_in(alu_out) ,
    .data_en(data_e) ,
    .data_out(data)
);








endmodule