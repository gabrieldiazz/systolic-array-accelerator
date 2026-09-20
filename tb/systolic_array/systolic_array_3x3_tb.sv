module systolic_array_3x3_tb;
    logic clk;
    logic reset;

    logic [7:0] a_in [3];
    logic [7:0] b_in [3];

    wire [31:0] c [3][3];

    systolic_array #(
        .WIDTH(8),
        .SIZE(3)
    ) dut (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .c(c)
    );

    // helper task to simplify setting systolic array inputs
    task set_inputs(
        input logic [7:0] a0,
        input logic [7:0] a1,
        input logic [7:0] a2,
        input logic [7:0] b0,
        input logic [7:0] b1,
        input logic [7:0] b2
    );
        a_in[0] = a0;
        a_in[1] = a1;
        a_in[2] = a2;

        b_in[0] = b0;
        b_in[1] = b1;
        b_in[2] = b2;
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // matrix multiplication:
        //
        // A = [1  2  3]    B = [9  8  7]
        //     [4  5  6]        [6  5  4]
        //     [7  8  9]        [3  2  1]
        //
        // Expected:
        // C = A x B = [ 30   24   18]
        //             [ 84   69   54]
        //             [138  114   90]
        //
        // Inputs are staggered to account for systolic-array propagation
      
        reset = 1;

        @(posedge clk);
        #1;

        assert(c[0][0] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[0][1] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[0][2] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[1][0] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[1][1] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[1][2] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[2][0] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[2][1] == 0)
            else $error("inital reset did not execute correctly");
        assert(c[2][2] == 0)
            else $error("inital reset did not execute correctly");


        //apply staggered matrix inputs

        reset = 0;

        set_inputs(1, 0, 0,  9, 0, 0);
        @(posedge clk);
        #1;

        set_inputs(2, 4, 0,  6, 8, 0);
        @(posedge clk);
        #1;

        set_inputs(3, 5, 7,  3, 5, 7);
        @(posedge clk);
        #1;

        set_inputs(0, 6, 8,  0, 2, 4);
        @(posedge clk);
        #1;

        set_inputs(0, 0, 9,  0, 0, 1);
        @(posedge clk);
        #1;

        // Flush
        set_inputs(0, 0, 0,  0, 0, 0);
        @(posedge clk);
        #1;

        set_inputs(0, 0, 0,  0, 0, 0);
        @(posedge clk);
        #1;

        assert(c[0][0] == 30)
            else $error("matrix multiplication failed at c[0][0]");
        assert(c[0][1] == 24)
            else $error("matrix multiplication failed at c[0][1]");
        assert(c[0][2] == 18)
            else $error("matrix multiplication failed at c[0][2]");
        assert(c[1][0] == 84)
            else $error("matrix multiplication failed at c[1][0]");
        assert(c[1][1] == 69)
            else $error("matrix multiplication failed at c[1][1]");
        assert(c[1][2] == 54)
            else $error("matrix multiplication failed at c[1][2]");
        assert(c[2][0] == 138)
            else $error("matrix multiplication failed at c[2][0]");
        assert(c[2][1] == 114)
            else $error("matrix multiplication failed at c[2][1]");
        assert(c[2][2] == 90)
            else $error("matrix multiplication failed at c[2][2]");
       
        $display("all tests passed!");
        $finish;

    end
endmodule 