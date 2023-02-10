module branch_predictor
(
    clk_i, 
    rst_i,

    update_i,
	result_i,
	predict_o
);
input clk_i, rst_i, update_i, result_i;
output predict_o;

reg [1:0] state = 2'b11;
assign predict_o = state[1];


// TODO
always @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) state = 2'b11;
    else if (update_i) begin
        if (result_i)
            state = ((state == 3) ? 3 : state + 1);
        else
            state = ((state == 0) ? 0 : state - 1);
    end
end

endmodule
