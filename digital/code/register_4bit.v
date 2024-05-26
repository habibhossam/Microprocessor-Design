module reg_4bit(in, out, i_en, clr, clk);
    input [3:0] in; 
    input i_en;
    input clr;
    input clk; 
    output [3:0] out; 
    dFlipflop ff1(clk,clr,i_en,in[0],out[0]);
    dFlipflop ff2(clk,clr,i_en,in[1],out[1]);
    dFlipflop ff3(clk,clr,i_en,in[2],out[2]);
    dFlipflop ff4(clk,clr,i_en,in[3],out[3]);

    endmodule
