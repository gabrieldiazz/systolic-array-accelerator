module mac #(
    parameter WIDTH = 8
)(
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    output logic [31:0] acc   
);

    always_ff@(posedge clk) begin
        if (reset)
            acc <= '0;
        else
            acc <= (acc + a * b);
    end


endmodule