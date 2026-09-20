module systolic_array_2x2_tb;
    logic clk;
    logic reset;

    logic [7:0] a_in [2];
    logic [7:0] b_in [2];

    wire [31:0] c [2][2];

    systolic_array #(
        .WIDTH(8),
        .SIZE(2)
    ) dut (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .c(c)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Matrix multiplication:
        //
        // A = [1  2]    B = [5  6]
        //     [3  4]        [7  8]
        //
        // Expected:
        // C = A x B = [19  22]
        //             [43  50]
        //
        // Inputs are staggered to account for systolic-array propagation.
        
        reset = 1;

        a_in[0] = 0;
        a_in[1] = 0;
        b_in[0] = 0;
        b_in[1] = 0;

        @(posedge clk);
        #1;
        $display("RESET: c00=%0d c01=%0d c10=%0d c11=%0d",
            c[0][0], c[0][1], c[1][0], c[1][1]);

        assert(c[0][0] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[0][1] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[1][0] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[1][1] == 0)
            else $error("inital reset did not execute correctly");
        
        reset = 0;
        a_in[0] = 1;
        a_in[1] = 0;
        b_in[0] = 5;
        b_in[1] = 0;
        @(posedge clk);
        #1;

        a_in[0] = 2;
        a_in[1] = 3;
        b_in[0] = 7;
        b_in[1] = 6;
        @(posedge clk);
        #1;

        a_in[0] = 0;
        a_in[1] = 4;
        b_in[0] = 0;
        b_in[1] = 8;
        @(posedge clk);
        #1;

        a_in[0] = 0;
        a_in[1] = 0;
        b_in[0] = 0;
        b_in[1] = 0;
        @(posedge clk);
        #1;

        $display("FINAL: c00=%0d c01=%0d c10=%0d c11=%0d",
            c[0][0], c[0][1], c[1][0], c[1][1]);


        assert(c[0][0] == 19)
            else $error("matrix multiplcation did not get calculated correctly");
        assert(c[0][1] == 22)
            else $error("matrix multiplcation did not get calculated correctly");
        assert(c[1][0] == 43)
            else $error("matrix multiplcation did not get calculated correctly");
        assert(c[1][1] == 50)
            else $error("matrix multiplcation did not get calculated correctly");
        
        $display("all tests passed!");
        $finish;

    end
endmodule 