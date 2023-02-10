module Control
(
    Op_i,
    NoOp_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Branch_o,
);
// Reads opcodes in the instruction and output control signals to control the behavior
// of ALU and registers.

input         [6:0] Op_i;
input               NoOp_i;
output        [1:0] ALUOp_o;
output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
wire ZERO;

assign ZERO = (Op_i[6:0] == 7'b0 || NoOp_i);
assign RegWrite_o = !ZERO && (Op_i[4] || !Op_i[5]);
assign MemtoReg_o = !ZERO && (Op_i[6:4] == 3'b000);
assign MemRead_o = !ZERO && (Op_i[6:4] == 3'b000);
assign MemWrite_o = !ZERO && (Op_i[6:4] == 3'b010);
assign ALUOp_o = {Op_i[5] && Op_i[4] && !ZERO, Op_i[6] && Op_i[5] && !ZERO};
assign ALUSrc_o = !ZERO && ~(Op_i[5] && Op_i[4]);
assign Branch_o = !ZERO && Op_i[6];

endmodule