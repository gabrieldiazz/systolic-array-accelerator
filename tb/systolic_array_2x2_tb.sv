module systolic_array_2x2_tb;
    logic clk;
    logic reset;

    logic [7:0] a0_in;
    logic [7:0] a1_in;
    logic [7:0] b0_in;
    logic [7:0] b1_in;

    logic [31:0] c00;
    logic [31:0] c01;
    logic [31:0] c10;
    logic [31:0] c11;

    systolic_array_2x2 #(
        .WIDTH(8)
    )  dut (
        .clk(clk),
        .reset(reset),
        .a0_in(a0_in),
        .a1_in(a1_in),
        .b0_in(b0_in),
        .b1_in(b1_in),
        .c00(c00),
        .c01(c01),
        .c10(c10),
        .c11(c11)
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

        a0_in = 0;
        a1_in = 0;
        b0_in = 0;
        b1_in = 0;

        @(posedge clk);
        #1;

        assert(c00 == 0)
            else $error("inital reset did not execute correctly");
        assert(c01 == 0)
            else $error("inital reset did not execute correctly");
        assert(c10 == 0)
            else $error("inital reset did not execute correctly");
        assert(c11 == 0)
            else $error("inital reset did not execute correctly");
        
        reset = 0;
        a0_in = 1;
        a1_in = 0;
        b0_in = 5;
        b1_in = 0;
        @(posedge clk);
        #1;

        a0_in = 2;
        a1_in = 3;
        b0_in = 7;
        b1_in = 6;
        @(posedge clk);
        #1;

        a0_in = 0;
        a1_in = 4;
        b0_in = 0;
        b1_in = 8;
        @(posedge clk);
        #1;

        a0_in = 0;
        a1_in = 0;
        b0_in = 0;
        b1_in = 0;
        @(posedge clk);
        #1;

        assert(c00 == 19)
            else $error("matrix multiplcation did not get calculated correctly");
        assert(c01 == 22)
            else $error("matrix multiplcation did not get calculated correctly");
        assert(c10 == 43)
            else $error("matrix multiplcation did not get calculated correctly");
        assert(c11 == 50)
            else $error("matrix multiplcation did not get calculated correctly");
        
        $display("all tests passed!");
        $finish;

    end
endmodule 




