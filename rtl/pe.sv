module pe #(
    parameter WIDTH = 8
) (
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] a_in,
    input logic [WIDTH-1:0] b_in,
    output logic [WIDTH-1:0] a_out,
    output logic [WIDTH-1:0] b_out,
    output logic [31:0] acc
);

    always_ff @(posedge clk) begin
        if (reset) begin
            a_out <= '0;
            b_out <= '0;
            acc <= '0;
        end
        else begin
            a_out <= a_in;
            b_out <= b_in;
            acc <= (acc + a_in * b_in);
        end
    end
endmodule