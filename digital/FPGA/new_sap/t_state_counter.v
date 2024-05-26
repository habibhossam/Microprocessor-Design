// to obtain t states
module state_counter (T, clk, res);
    input clk, res;
    output reg [4:0] T = 5'b00001;

    always @(negedge clk)
    begin
        if(res == 1) begin 
            T <= 5'b00001;
		end
        else if(clk == 0) 
        begin
            if(T == 5'b10000)
                T <= 5'b00001;
            else
                T <= T << 1;
        end
    end
endmodule
