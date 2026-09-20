module pe #(
    parameter WIDTH = 8,
    parameter ACC_WIDTH = 32
) (
    input logic clk,
    input logic reset,
    input logic signed [WIDTH-1:0] a_in,
    input logic signed [WIDTH-1:0] b_in,
    output logic signed  [WIDTH-1:0] a_out,
    output logic signed [WIDTH-1:0] b_out,
    output logic signed [ACC_WIDTH-1:0] acc
);

    // add a pipelined register to save the multiplication result
    logic signed [(2*WIDTH)-1:0] product_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            a_out <= '0;
            b_out <= '0;
            product_reg <= '0;
            acc <= '0;
        end
        else begin
            a_out <= a_in;
            b_out <= b_in;
            product_reg <= a_in * b_in;
            acc <= acc + product_reg;
        end
    end
endmodule