module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire                ID_Flush, EX_Flush;
wire         [31:0] ID_PC, EX_PC, new_PC;

assign ID_Flush = EX_Flush || (Control.Branch_o && branch_predictor.predict_o);
assign EX_Flush = (ID_EX.Branch_o && ID_EX.predict_o != ALU.Zero_o);
assign ID_PC = (Control.Branch_o && branch_predictor.predict_o) ? T_PC_Adder.data_o : PC_Adder.data_o;
assign EX_PC = ALU.Zero_o ? ID_EX.T_pc_o : ID_EX.NT_pc_o;
assign new_PC = EX_Flush ? EX_PC : ID_PC;

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .PCWrite_i  (Hazard_Detection.PCWrite_o),
    .pc_i       (new_PC),
    .pc_o       ()
);

Adder PC_Adder(
    .data1_i   (PC.pc_o),
    .data2_i   (32'H4),
    .data_o    ()
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o), 
    .instr_o    ()
);

// IF/ID
IF_ID IF_ID(
    .clk_i (clk_i),
    .Stall_i (Hazard_Detection.Stall_o),
    .Flush_i (ID_Flush),
    .pc_i (PC.pc_o),
    .instr_i (Instruction_Memory.instr_o),
    .rst_i (rst_i),
    .instr_o (),
    .pc_o ()
);

Control Control(
    .Op_i (IF_ID.instr_o[6:0]),
    .NoOp_i (Hazard_Detection.NoOp_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o (),
    .MemWrite_o (),
    .ALUOp_o (),
    .ALUSrc_o (),
    .Branch_o ()
);

Adder T_PC_Adder(
    .data1_i   (Imm_Gen.data_o),
    .data2_i   (IF_ID.pc_o),
    .data_o    ()
);

Adder NT_PC_Adder(
    .data1_i   (32'H4),
    .data2_i   (IF_ID.pc_o),
    .data_o    ()
);

Hazard_Unit Hazard_Detection(
    .RS1addr_i (IF_ID.instr_o[19:15]),
    .RS2addr_i (IF_ID.instr_o[24:20]),
    .EX_Rd_i (ID_EX.RDaddr_o),
    .EX_MemRead_i (ID_EX.MemRead_o),
    .PCWrite_o (),
    .Stall_o (),
    .NoOp_o ()
);

Imm_Gen Imm_Gen(
    .data_i (IF_ID.instr_o[31:0]),
    .data_o ()
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (IF_ID.instr_o[19:15]),
    .RS2addr_i   (IF_ID.instr_o[24:20]),
    .RDaddr_i    (MEM_WB.RDaddr_o),
    .RDdata_i    (WB_MUX.data_o),
    .RegWrite_i  (MEM_WB.RegWrite_o),
    .RS1data_o   (),
    .RS2data_o   ()
);

branch_predictor branch_predictor(
    .clk_i (clk_i),
    .rst_i (rst_i),
    .update_i (ID_EX.Branch_o),
	.result_i (ALU.Zero_o),
	.predict_o ()
);


// ID/EX
ID_EX ID_EX(
    .clk_i (clk_i),
    .Flush_i (EX_Flush),
    .RegWrite_i (Control.RegWrite_o),
    .MemtoReg_i (Control.MemtoReg_o),
    .MemRead_i (Control.MemRead_o),
    .MemWrite_i (Control.MemWrite_o),
    .ALUOp_i (Control.ALUOp_o),
    .ALUSrc_i (Control.ALUSrc_o),
    .Branch_i (Control.Branch_o),
    .T_pc_i (T_PC_Adder.data_o),
    .NT_pc_i (NT_PC_Adder.data_o),
    .predict_i (branch_predictor.predict_o),
    .data1_i (Registers.RS1data_o),
    .data2_i (Registers.RS2data_o),
    .imm_i (Imm_Gen.data_o),
    .funct_i ({IF_ID.instr_o[31:25], IF_ID.instr_o[14:12]}),
    .RS1addr_i (IF_ID.instr_o[19:15]),
    .RS2addr_i (IF_ID.instr_o[24:20]),
    .RDaddr_i (IF_ID.instr_o[11:7]),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o (),
    .MemWrite_o (),
    .ALUOp_o (),
    .ALUSrc_o (),
    .Branch_o (),
    .T_pc_o (),
    .NT_pc_o (),
    .predict_o (),
    .data1_o (),
    .data2_o (),
    .imm_o (),
    .funct_o (),
    .RS1addr_o (),
    .RS2addr_o (),
    .RDaddr_o ()
);

MUX32_4 EX_MUXA(
    .data1_i (ID_EX.data1_o),
    .data2_i (WB_MUX.data_o),
    .data3_i (EX_MEM.ALUres_o),
    .data4_i (),
    .select_i (Forward_Unit.ForwardA_o),
    .data_o ()
);

MUX32_4 EX_MUXB(
    .data1_i (ID_EX.data2_o),
    .data2_i (WB_MUX.data_o),
    .data3_i (EX_MEM.ALUres_o),
    .data4_i (),
    .select_i (Forward_Unit.ForwardB_o),
    .data_o ()
);

MUX32 EX_ALUMUX(
    .data1_i (EX_MUXB.data_o),
    .data2_i (ID_EX.imm_o),
    .select_i (ID_EX.ALUSrc_o),
    .data_o ()
);
  

ALU ALU(
    .data1_i    (EX_MUXA.data_o),
    .data2_i    (EX_ALUMUX.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);



ALU_Control ALU_Control(
    .funct_i    (ID_EX.funct_o),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  ()
);

Forward_Unit Forward_Unit(
    .EX_Rs1_i (ID_EX.RS1addr_o),
    .EX_Rs2_i (ID_EX.RS2addr_o),
    .WB_RegWrite_i (MEM_WB.RegWrite_o),
    .WB_Rd_i (MEM_WB.RDaddr_o),
    .MEM_RegWrite_i (EX_MEM.RegWrite_o),
    .MEM_Rd_i (EX_MEM.RDaddr_o),
    .ForwardA_o (),
    .ForwardB_o ()
);

// EX/MEM
EX_MEM EX_MEM(
    .clk_i (clk_i),
    .RegWrite_i (ID_EX.RegWrite_o),
    .MemtoReg_i (ID_EX.MemtoReg_o),
    .MemRead_i (ID_EX.MemRead_o),
    .MemWrite_i (ID_EX.MemWrite_o),
    .ALUres_i (ALU.data_o),
    .MEMWriteData_i (EX_MUXB.data_o),
    .RDaddr_i (ID_EX.RDaddr_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o (),
    .MemWrite_o (),
    .ALUres_o (),
    .MEMWriteData_o (),
    .RDaddr_o ()
);

Data_Memory Data_Memory(
    .clk_i (clk_i),
    .addr_i (EX_MEM.ALUres_o),
    .MemRead_i (EX_MEM.MemRead_o),
    .MemWrite_i (EX_MEM.MemWrite_o),
    .data_i (EX_MEM.MEMWriteData_o),
    .data_o ()
);


// MEM/WB
MEM_WB MEM_WB(
    .clk_i (clk_i),
    .RegWrite_i (EX_MEM.RegWrite_o),
    .MemtoReg_i (EX_MEM.MemtoReg_o),
    .ALUres_i (EX_MEM.ALUres_o),
    .MEMReadData_i (Data_Memory.data_o),
    .RDaddr_i (EX_MEM.RDaddr_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .ALUres_o (),
    .MEMReadData_o (),
    .RDaddr_o ()
);

MUX32 WB_MUX(
    .data1_i (MEM_WB.ALUres_o),
    .data2_i (MEM_WB.MEMReadData_o),
    .select_i (MEM_WB.MemtoReg_o),
    .data_o ()
);
endmodule

