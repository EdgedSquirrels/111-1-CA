module ID_EX
(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    data1_i,
    data2_i,
    imm_i,
    funct_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    data1_o,
    data2_o,
    imm_o,
    funct_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o,
);

input  clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
input [31:0] data1_i, data2_i, imm_i;
input [1:0] ALUOp_i;
input [9:0] funct_i;
input [4:0] RS1addr_i, RS2addr_i, RDaddr_i;

output reg RegWrite_o = 0, MemtoReg_o, MemRead_o, MemWrite_o = 0, ALUSrc_o;
output reg [31:0] data1_o, data2_o, imm_o;
output reg [1:0] ALUOp_o;
output reg [9:0] funct_o;
output reg [4:0] RS1addr_o, RS2addr_o, RDaddr_o;

always @ (posedge clk_i) begin
    MemtoReg_o <= MemtoReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    ALUOp_o <= ALUOp_i;
    ALUSrc_o <= ALUSrc_i;
    data1_o <= data1_i;
    data2_o <= data2_i;
    imm_o <= imm_i;
    funct_o <= funct_i;
    RS1addr_o <= RS1addr_i;
    RS2addr_o <= RS2addr_i;
    RDaddr_o <= RDaddr_i;
    RegWrite_o <= RegWrite_i;
end

endmodule