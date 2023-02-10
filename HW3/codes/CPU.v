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

wire [31:0] instr, pc_o, pc_i, alu_o, RS1data, RS2data, imm, ALUData2;
wire [1:0] ALUOp;
wire [2:0] ALUCtrl;
wire ALUSrc, RegWrite;


Control Control(
    .Op_i       (instr[6:0]),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite)
);

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (32'H4),
    .data_o     (pc_i)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_i),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instr)
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (instr[19:15]),
    .RS2addr_i   (instr[24:20]),
    .RDaddr_i    (instr[11:7]), 
    .RDdata_i    (alu_o),
    .RegWrite_i  (RegWrite), 
    .RS1data_o   (RS1data), 
    .RS2data_o   (RS2data) 
);


MUX32 MUX_ALUSrc(
    .data1_i    (RS2data),
    .data2_i    (imm),
    .select_i   (ALUSrc),
    .data_o     (ALUData2)
);



Sign_Extend Sign_Extend(
    .data_i     (instr[31:20]),
    .data_o     (imm)
);

  

ALU ALU(
    .data1_i    (RS1data),
    .data2_i    (ALUData2),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (alu_o),
    .Zero_o     ()
);



ALU_Control ALU_Control(
    .funct_i    ({instr[31:25], instr[14:12]}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);




endmodule

