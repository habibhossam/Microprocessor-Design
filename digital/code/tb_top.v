

module tb_main();
    reg clk, clr;
    wire [7:0] out;
    wire [7:0] bus;
wire [7:0] PC;
wire [3:0] MAR;
wire [7:0] mem;
wire [7:0] IR;
wire [6:0] sig;
    main uut(
         .clk(clk), .clr(clr), .out(out),.out_bus(bus),.out_PC(PC),.MAR(MAR),.meme(mem),.IR_out(IR),.sig(sig)
    );

    initial
    begin
        #10 clk = 1'b0;
    end

    always
    begin
        #5 clk = ~clk;
    end

    initial
    begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_main);
    end

    initial
    begin
        #2 clr = 1'b1;
        #6 clr = 1'b0;
        #8  clr = 1'b1;
        #12 clr =1'b0;
        #2000 $finish;
    end

    initial
    begin
        $monitor("out:%b bus:%b PC:%b MAR:%b mem:%b IR:%b inc:%b PC_LD:%b PC_OE:%b MAR_LD:%b ROM_OE:%b IR_LD:%b IR_OE:%b",
	out,bus,PC,MAR,mem,IR,sig[0],sig[1],sig[2],sig[3],sig[4],sig[5],sig[6]);
    end
endmodule
