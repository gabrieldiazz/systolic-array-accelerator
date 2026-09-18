module systolic_array_2x2 #(
    parameter WIDTH = 8
) (
    input logic clk,
    input logic reset,
    
    input logic [WIDTH-1:0] a0_in,
    input logic [WIDTH-1:0] a1_in,

    input logic [WIDTH-1:0] b0_in,
    input logic [WIDTH-1:0] b1_in,

    output logic [31:0] c00,
    output logic [31:0] c01,
    output logic [31:0] c10,
    output logic [31:0] c11
);

    // instantiate wires

    logic [WIDTH-1:0] a00_to_a01;
    logic [WIDTH-1:0] a10_to_a11;
    logic [WIDTH-1:0] b00_to_b10;
    logic [WIDTH-1:0] b01_to_b11;

    pe #(
        .WIDTH(WIDTH)
    ) PE00 (
        .clk(clk),
        .reset(reset),
        .a_in(a0_in),
        .b_in(b0_in),
        .a_out(a00_to_a01),
        .b_out(b00_to_b10),
        .acc(c00)
    );

    pe #(
        .WIDTH(WIDTH)
    ) PE01 (
        .clk(clk),
        .reset(reset),
        .a_in(a00_to_a01),
        .b_in(b1_in),
        .a_out(),
        .b_out(b01_to_b11),
        .acc(c01)
    );

    pe #(
        .WIDTH(WIDTH)
    ) PE10 (
        .clk(clk),
        .reset(reset),
        .a_in(a1_in),
        .b_in(b00_to_b10),
        .a_out(a10_to_a11),
        .b_out(),
        .acc(c10)
    );

    pe #(
        .WIDTH(WIDTH)
    ) PE11 (
        .clk(clk),
        .reset(reset),
        .a_in(a10_to_a11),
        .b_in(b01_to_b11),
        .a_out(),
        .b_out(),
        .acc(c11)
    );

endmodule