module systolic_array #(
    parameter WIDTH = 8,
    parameter SIZE = 4
)(
    input logic clk,
    input logic reset,
    
    input logic [WIDTH-1:0] a_in [SIZE],
    input logic [WIDTH-1:0] b_in [SIZE],
    
    output [31:0] c [SIZE][SIZE]
);

    // instantiate wires

    logic [WIDTH-1:0] a_wire [SIZE][SIZE];
    logic [WIDTH-1:0] b_wire [SIZE][SIZE];


    genvar row;
    genvar col;

    generate 
        for (row = 0; row < SIZE; row = row + 1) begin : gen_row
            for (col = 0; col < SIZE; col = col +1) begin : gen_col

                logic [WIDTH-1:0] a_pe_in;
                logic [WIDTH-1:0] b_pe_in;
                
                // connect the wires to the PEs
                if (col == 0) begin 
                    assign a_pe_in = a_in[row];
                end 
                else begin
                    assign a_pe_in = a_wire[row][col-1];
                end
                if(row == 0) begin
                    assign b_pe_in = b_in[col];
                end
                else begin 
                    assign b_pe_in = b_wire[row-1][col];
                end

                // instantiate PE's
                pe #(
                    .WIDTH(WIDTH)
                ) pe_inst (
                    .clk(clk),
                    .reset(reset),
                    .a_in(a_pe_in),
                    .b_in(b_pe_in),
                    .a_out(a_wire[row][col]),
                    .b_out(b_wire[row][col]),
                    .acc(c[row][col])
                );
            end
        end
    endgenerate 
endmodule
