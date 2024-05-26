module rom(
    input [3:0] addr,
    input ROM_LOW_OE,
    output reg [7:0] data
);
    always @(addr or ROM_LOW_OE)
    begin
        if(ROM_LOW_OE)
        begin
            data = 8'bZZZZZZZZ;
        end
        else
        begin
            case(addr)
                4'h0: data = 8'b0000_1000; // lda 8
                4'h1: data = 8'b1000_1000; // add 9 
                4'h2: data = 8'b1001_1001; //out --> 10010001
                4'h3: data = 8'b0010_1010; //sub 0xa -> 0000_0001
                4'h4: data = 8'b1000_1000; //out --> 10010000
                4'h5: data = 8'b0110_1100; //call 0xc
                4'h6: data = 8'b0101_0000; // bun 0x0
                4'h7: data = 8'b0101_0000; 
                4'h8: data = 8'b0001_1110; 
                4'h9: data = 8'b0000_1000;
                4'ha: data = 8'b0000_0001;
                4'hb: data = 8'b1000_0000;
                4'hc: data = 8'b0000_1111; // lda 0xf
                4'hd: data = 8'b1000_1000; //out --> 1111_1111
                4'he: data = 8'b0111_0000; // ret 
                4'hf: data = 8'b1111_1111;
            endcase
        end
    end
endmodule