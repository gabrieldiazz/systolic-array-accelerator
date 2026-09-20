module systolic_array_top (
    input  logic clk,
    input  logic reset,

    input  logic signed [23:0] a_in,
    input  logic signed [23:0] b_in,

    output logic signed [287:0] c
);

    systolic_array #(
        .WIDTH(8),
        .SIZE(3),
        .ACC_WIDTH(32)
    ) accelerator (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .c(c)
    );

endmodule