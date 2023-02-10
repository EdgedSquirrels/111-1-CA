module Hazard_Unit
(
    RS1addr_i,
    RS2addr_i,
    EX_Rd_i,
    EX_MemRead_i,
    PCWrite_o,
    Stall_o,
    NoOp_o,
);

input [4:0] RS1addr_i, RS2addr_i, EX_Rd_i;
input       EX_MemRead_i;
output reg PCWrite_o = 0, Stall_o = 1, NoOp_o = 1;

always @ (*) begin
    // detect whether the rd in EX stage is the same as rs1 or rs2
    if (EX_Rd_i != 0
    && EX_MemRead_i
    && (EX_Rd_i == RS1addr_i || EX_Rd_i == RS2addr_i)
    ) begin
        PCWrite_o <= 0;
        Stall_o <= 1;
        NoOp_o <= 1;
    end
    else begin
        PCWrite_o <= 1;
        Stall_o <= 0;
        NoOp_o <= 0;
    end
end

endmodule