module ALU_Control (
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);
// Reads funct7 and funct3 in the instruction and tell ALU what kind of operation it
// should do.

input  [9:0]      funct_i;
input  [1:0]      ALUOp_i;
output reg [2:0]  ALUCtrl_o;

always@ (funct_i or ALUOp_i) begin
    if (ALUOp_i[1] == 0 && funct_i[2:0] != 3'b101) begin
        case(ALUOp_i[0])
            0: ALUCtrl_o = 3'b000; // ADD
            1: ALUCtrl_o = 3'b110; // SUB
        endcase
    end
    else if (funct_i[2:0] == 3'b000 && ALUOp_i[1]) begin
        case({funct_i[8], funct_i[3]})
            2'b10: ALUCtrl_o = 3'b110; // SUB
            2'b01: ALUCtrl_o = 3'b010; // MUL
            2'b00: ALUCtrl_o = 3'b000; // ADD
        endcase
    end
    else
        ALUCtrl_o = funct_i[2:0];
end


endmodule