`include "top_mod.v"

module test ( 

    output  LED1,
    output  LED2,
    output  LED3,
    output  LED4,
    output  LED5
);
wire [7:0] out;
reg clk1,clr;

initial
    begin
        #10 clk1 = 1'b0;
    end

    always
    begin
        #5 clk1 = ~clk1;
    end


initial
    begin
        #2 clr = 1'b1;
        #6 clr = 1'b0;
        #8  clr = 1'b1;
        #12 clr =1'b0;
		#4000 clr =1'b0;
    end

main uut(.clk(clk1),.out(out),.clr(clr));

assign LED1 = out[0];
assign LED2 = clr;
assign LED3 = out[2];
assign LED4 = out[3];
assign LED5 = out[4];

endmodule