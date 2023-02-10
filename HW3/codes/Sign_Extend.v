module Sign_Extend(
    data_i,
    data_o
);
// Signed extends the immediate value into 32-bit number. You have to make sure
// both positive and negative immediate values can work correctly.

input  [11:0] data_i;
output [31:0] data_o;

assign data_o = {{20{data_i[11]}}, data_i[11:0]};

endmodule