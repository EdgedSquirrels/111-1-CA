module EX_MEM
(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUres_i,
    MEMWriteData_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUres_o,
    MEMWriteData_o,
    RDaddr_o,
);

input  clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
input [31:0] ALUres_i, MEMWriteData_i;
input [4:0] RDaddr_i;

output reg RegWrite_o = 0, MemtoReg_o, MemRead_o, MemWrite_o = 0;
output reg [31:0] ALUres_o, MEMWriteData_o;
output reg [4:0] RDaddr_o;

always @ (posedge clk_i) begin
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    ALUres_o <= ALUres_i;
    MEMWriteData_o <= MEMWriteData_i;
    RDaddr_o <= RDaddr_i;
end

endmodule