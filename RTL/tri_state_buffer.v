module tri_state_buffer #(parameter IN_WIDTH = 8 ,
                    parameter OUT_WIDTH = 8)
(
    input wire [IN_WIDTH-1:0] data_in ,
    input wire data_en ,
    output wire [OUT_WIDTH-1:0] data_out
);

assign data_out = data_en ? data_in : 'bz ;


endmodule