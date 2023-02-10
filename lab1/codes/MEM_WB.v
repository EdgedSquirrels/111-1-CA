module MEM_WB
(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    ALUres_i,
    MEMReadData_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    ALUres_o,
    MEMReadData_o,
    RDaddr_o,
);

input  clk_i, RegWrite_i, MemtoReg_i;
input [31:0] ALUres_i, MEMReadData_i;
input [4:0] RDaddr_i;

output reg RegWrite_o = 0, MemtoReg_o;
output reg [31:0] ALUres_o, MEMReadData_o;
output reg [4:0] RDaddr_o;

always @ (posedge clk_i) begin
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    ALUres_o <= ALUres_i;
    MEMReadData_o <= MEMReadData_i;
    RDaddr_o <= RDaddr_i;
end

endmodule