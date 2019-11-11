
module count_reset_v1#
(
	parameter[19:0]num = 20'hffff0
)(
	input clk_i,
	output rst_o
    );

reg[19:0] cnt = 20'd0;
reg rst_d0;

/*count for clock*/
always@(posedge clk_i)
begin
	cnt <= ( cnt <= num)?( cnt + 20'd1 ):num;
end

/*generate output signal*/
always@(posedge clk_i)
begin
	rst_d0 <= ( cnt >= num)?1'b1:1'b0;
end	

assign rst_o = rst_d0;

endmodule

