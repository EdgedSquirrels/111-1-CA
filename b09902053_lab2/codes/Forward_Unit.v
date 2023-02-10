module Forward_Unit
(
    EX_Rs1_i,
    EX_Rs2_i,
    WB_RegWrite_i,
    WB_Rd_i,
    MEM_RegWrite_i,
    MEM_Rd_i,
    ForwardA_o,
    ForwardB_o,
);

input [4:0] EX_Rs1_i, EX_Rs2_i, WB_Rd_i, MEM_Rd_i;
input WB_RegWrite_i, MEM_RegWrite_i;

output reg [1:0] ForwardA_o, ForwardB_o;

always @ (*) begin
    if (MEM_RegWrite_i
    && (MEM_Rd_i != 0)
    && (MEM_Rd_i == EX_Rs1_i))
        ForwardA_o = 2'b10;
    else if (WB_RegWrite_i
    && (WB_Rd_i != 0)
    && (WB_Rd_i == EX_Rs1_i))
        ForwardA_o = 2'b01;
    else
        ForwardA_o = 2'b00;
    
    if (MEM_RegWrite_i
    && (MEM_Rd_i != 0)
    && (MEM_Rd_i == EX_Rs2_i))
        ForwardB_o = 2'b10;
    else if (WB_RegWrite_i
    && (WB_Rd_i != 0)
    && (WB_Rd_i == EX_Rs2_i))
        ForwardB_o = 2'b01;
    else
        ForwardB_o = 2'b00;
end

endmodule