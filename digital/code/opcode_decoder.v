module opcode_decoder(op_code,D);
    input [3:0] op_code;
output [15:0] D;
assign D = (1'b1 << op_code);
endmodule