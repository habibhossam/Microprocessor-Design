// to obtain t states
module state_counter (T, clk, res);
    input clk, res;
    output reg [4:0] T = 6'b00001;

    always @(negedge clk or res)
    begin
        if(res == 1)
            T = 6'b00001;
        else if(clk == 0) 
        begin
            if(T == 6'b10000)
                T = 6'b00001;
            else
                T = T << 1;
        end
    end
endmodule
