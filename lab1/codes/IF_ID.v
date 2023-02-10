module IF_ID
(
    clk_i,
    Stall_i,
    Flush_i,
    pc_i,
    instr_i,
    start_i,
    instr_o,
    pc_o,
);


input             clk_i, Stall_i, Flush_i, start_i;
input      [31:0] instr_i, pc_i;
output reg [31:0] instr_o = 32'b0, pc_o;
// Flush: flush on next clock
// Stall: flush immidiately

always @ (posedge clk_i) begin
    if (!Stall_i && start_i) begin
        pc_o <= pc_i;
        instr_o <= instr_i;
    end
    if (Flush_i)
        instr_o <= 32'b0;
end

endmodule