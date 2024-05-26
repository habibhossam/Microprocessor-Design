module control_sequencer(
    input [3:0] op_code,
    input clk, clr,
    output inc,
    output PC_LD,
    output PC_OE,
    output MAR_LD,
    output ROM_OE,
    output IR_LD,
    output IR_OE,
    output ACC_LD,
    output ACC_OE,
    output S0,
    output S1,
    output ALU_en,
    output B_LD,
    output OUT_LD,
    output AR_LD,
    output AR_OE,
    output HLT
);
    wire [15:0] D;
    wire [4:0] T;

    wire CLR_Flag;

    opcode_decoder decoder(.op_code(op_code),.D(D));
    state_counter counter(.T(T), .clk(clk),.res(clr)); 

  //control signals for various T states
//---------------------to be changed-----------
	assign AR_LD =(D[6]&T[2]);
	assign AR_OE =~(D[7]&T[2]);
//---------------------------------------------

	assign ACC_LD = ((D[0]&T[3]) | (D[1]&T[4]) | (D[2]&T[4]) | (D[3]&T[4]) | (D[4]&T[4]));
	assign ACC_OE = ~(D[8]&T[2]);
	assign B_LD = ((D[1]&T[3]) | (D[2]&T[3]) | (D[3]&T[3]) | (D[4]&T[3]));
	assign MAR_LD = ((T[0])| (D[0]&T[2]) | (D[1]&T[2]) | (D[2]&T[2]) | (D[3]&T[2]) | (D[4]&T[2]));
	assign OUT_LD = (D[8]&T[2]);
	assign IR_LD = (T[1]);
	assign IR_OE = ~((D[0]&T[2]) | (D[1]&T[2]) | (D[2]&T[2]) | (D[3]&T[2]) | (D[4]&T[2]) | (D[5]&T[2]) | (D[6]&T[3]));
	assign PC_LD = ((D[5]&T[2]) | (D[6]&T[3]) | (D[7]&T[2]));
	assign PC_OE = ((T[0]) | (D[6]&T[2]));
	assign inc = (T[1]);
	assign ROM_OE = ~((T[1]) | (D[1]&T[3]) | (D[2]&T[3]) | (D[3]&T[3]) | (D[4]&T[3]) | (D[0]&T[3]));
	assign ALU_en = ~((D[1]&T[4]) | (D[2]&T[4]) | (D[3]&T[4]) | (D[4]&T[4]));

	assign S0 = (D[2]&T[4]) | (D[4]&T[4]);
	assign S1 = (D[3]&T[4]) | (D[4]&T[4]);

	assign HLT = ~(D[9]&T[2]);

	//assign CLR_Flag = ((clr) | ((D[0]&T[3]) | (D[1]&T[4]) | (D[2]&T[4]) | (D[3]&T[4]) | (D[4]&T[4]) | (D[5]&T[2]) | (D[6]&T[3]) | (D[7]&T[2]) | (D[8]&T[2])));
endmodule