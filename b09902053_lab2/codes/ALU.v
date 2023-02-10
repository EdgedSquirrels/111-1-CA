module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);
// According to the control signal, do the corresponding arithmetic operation on two
// input fields.

input signed      [31:0] data1_i, data2_i;
input             [2:0]  ALUCtrl_i;
output reg signed [31:0] data_o;
output reg               Zero_o = 0;

// self determined:
// func[8], func[2], (op[0] & func[3])|func[1], func[0]
`define AND 3'b111
`define XOR 3'b100
`define SLL 3'b001
`define SRA 3'b101

`define MUL 3'b010 // notice
`define ADD 3'b000
`define SUB 3'b110 // notice

always@ (data1_i or data2_i or ALUCtrl_i) begin
    case (ALUCtrl_i)
        `AND: data_o = data1_i & data2_i;
        `XOR: data_o = data1_i ^ data2_i;
        `ADD: data_o = data1_i + data2_i;
        `SUB: data_o = data1_i - data2_i;
        `MUL: data_o = data1_i * data2_i;
        `SLL: data_o = data1_i << data2_i;
        `SRA: data_o = data1_i >>> data2_i[4:0]; // Caution: funct7 contains 1
        default: data_o = 0;
    endcase
    Zero_o = (data1_i == data2_i);
end




endmodule