module program_counter(
	input clk,
	input rst,
	input inc,
	input en,
	input ld,
	input [3:0] bus,
	output tri[3:0] out
);


reg[3:0] program_counter;
assign not_en= ~en;
tristatebuff_4bit tbuf(.in(program_counter), .out(out), .low_en(not_en));
always @(posedge clk, posedge rst) begin
	   if (rst) begin
		  program_counter <= 4'b0000;
	   end else if (inc) begin
		program_counter <= program_counter + 1;
	   end else if (ld) begin
		program_counter <= bus;
	end
    
end
endmodule