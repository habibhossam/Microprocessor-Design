`include "tristatebuff_8bit.v"
`include "tristatebuff_4bit.v"
`include "control_unit.v"
`include "opcode_decoder.v"
`include "program_counter.v"
`include "t_state_counter.v"
`include "demux.v"
`include "register_4bit.v"
`include "register_8bit.v"
`include "ALU.v"
`include "memory.v"
`include "dFlipflop.v"

module main( clk, out, clr);
  
output [7:0] out;
input clk, clr;
wire [7:0] bus;
wire buf_clk;


// Control unit****************************************************
wire inc, PC_LD, PC_OE, MAR_LD, ROM_OE, IR_LD, IR_OE;
wire ACC_LD, ACC_OE, S0, S1, ALU_en, B_LD,OUT_LD, AR_LD, AR_OE;
wire HLT;
wire [3:0] op_code;
control_sequencer seq(.op_code(op_code),.clk(buf_clk),.clr(clr),.inc(inc),
.PC_OE(PC_OE),.PC_LD(PC_LD),.MAR_LD(MAR_LD),.ROM_OE(ROM_OE),.IR_LD(IR_LD),.IR_OE(IR_OE),
.ACC_LD(ACC_LD),.ACC_OE(ACC_OE),.S0(S0),.S1(S1),.ALU_en(ALU_en),
.B_LD(B_LD),.OUT_LD(OUT_LD),.AR_LD(AR_LD),.AR_OE(AR_OE),.HLT(HLT));
//************************************************************************

// Clock buffer*****************************************************
bufif1(buf_clk, clk, HLT);
//***********************************************************
     
//program counter******************************************************
wire [3:0] out_pc;
assign bus[3:0] = out_pc;
program_counter pc(.inc(inc), .clk(buf_clk), .en(PC_OE), .rst(clr), .out(out_pc),.bus(bus[3:0]),.ld(PC_LD));
//**********************************************************************

//memory address register************************************************
wire [3:0] mar_out;
reg_4bit  mar(.in(bus[3:0]), .out(mar_out), .i_en(MAR_LD), .clr(clr), .clk(buf_clk));
//**********************************************************************
  
//RomModule************************************************
wire [7:0] mem_out;
rom mem(.addr(mar_out), .ROM_LOW_OE(ROM_OE), .data(mem_out));
assign bus = mem_out;
//**********************************************************************

//Instruction register************************************************
wire [7:0] ir_out;
reg_8bit  IR(.in(bus), .out(ir_out), .i_en(IR_LD), .clr(clr), .clk(buf_clk));

tristatebuff_4bit IR_BUF(.in(ir_out[3:0]), .out(bus[3:0]), .low_en(IR_OE));
assign op_code = ir_out[7:4]; 
//**********************************************************************

//Accumulator************************************************
wire [7:0] acc_out;
reg_8bit  acc(.in(bus), .out(acc_out), .i_en(ACC_LD), .clr(clr), .clk(buf_clk));

tristatebuff_8bit buf1(.in(acc_out), .out(bus), .low_en(ACC_OE));
//**********************************************************************

//B register************************************************
wire [7:0] b_reg_out;
reg_8bit  b_reg(.in(bus), .out(b_reg_out), .i_en(B_LD), .clr(clr), .clk(buf_clk));
//**********************************************************************

//ALU************************************************
wire [7:0] alu_out;
wire [1:0] ALU_sel;
assign ALU_sel[0] = S0;
assign ALU_sel[1] = S1;
alu  ALU_main(.A(acc_out), .B(b_reg_out), .ALU_Sel(ALU_sel), .CarryOut(), .ALU_Out(alu_out));
tristatebuff_8bit ALU_BUF(.in(alu_out), .out(bus), .low_en(ALU_en));
//**********************************************************************

//Output register************************************************
reg_8bit out_reg(.in(bus), .out(out), .i_en(OUT_LD), .clr(clr), .clk(buf_clk));
//**********************************************************************


//AR register************************************************
wire [3:0] AR_out;
reg_4bit AR(.in(bus[3:0]), .out(AR_out), .i_en(AR_LD), .clr(clr), .clk(buf_clk));
tristatebuff_4bit AR_BUF(.in(AR_out), .out(bus[3:0]), .low_en(AR_OE));
//**********************************************************************

	
endmodule
    

