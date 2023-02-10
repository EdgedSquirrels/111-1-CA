module IF_ID
(
    clk_i,
    rst_i,
    Stall_i,
    Flush_i,
    pc_i,
    instr_i,
    instr_o,
    pc_o,
);


input             clk_i, Stall_i, Flush_i, rst_i;
input      [31:0] instr_i, pc_i;
output reg [31:0] instr_o = 32'b0, pc_o;
// Flush: flush on next clock
// Stall: flush immidiately

always @ (posedge clk_i) begin
    if (Flush_i)
        instr_o <= 32'b0;
    else if (!Stall_i) begin
        pc_o <= pc_i;
        instr_o <= instr_i;
    end
end

always @ (posedge rst_i) begin
    instr_o <= 32'b0;
    pc_o <= 32'b0;
end

endmodule