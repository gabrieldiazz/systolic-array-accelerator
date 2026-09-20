module pe_tb;
    logic clk;
    logic reset;
    logic signed [7:0] a_in;
    logic signed [7:0] b_in;
    logic signed [7:0] a_out;
    logic signed [7:0] b_out;
    logic signed [31:0] acc;

    pe #(
        .WIDTH(8),
        .ACC_WIDTH(32)
    ) dut (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .a_out(a_out),
        .b_out(b_out),
        .acc(acc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        a_in = 0;
        b_in = 0;

        @(posedge clk);
        #1;

        assert(acc == 0)
            else $error("initial reset did not work as intended");
        assert(a_out == 0)
            else $error("initial reset did not work as intended");
        assert(b_out == 0)
            else $error("initial reset did not work as intended");

        reset = 0;
        a_in = 3;
        b_in = 4;
        
        @(posedge clk);
        #1;

        assert(acc == 12)
            else $error("initial multiplication did not work as intended");
        assert(a_out == 3)
            else $error("a_in did not propagate to a_out");
        assert(b_out == 4)
            else $error("b_in did not propagate to b_out");

        @(posedge clk);
        #1;

        assert(acc == 24)
            else $error("result did not accumulate");
        assert(a_out == 3)
            else $error("a_in did not propagate to a_out");
        assert(b_out == 4)
            else $error("b_in did not propagate to b_out");

        
        a_in = 2;
        b_in = 5;

        @(posedge clk);
        #1;

        assert(acc == 34)
            else $error("new input values did not get factored into final result");
         assert(a_out == 2)
            else $error("new a_in did not propagate to a_out");
        assert(b_out == 5)
            else $error("new b_in did not propagate to b_out");

        reset = 1;
        a_in = 0;
        b_in = 0;

        @(posedge clk);
        #1;

        assert(acc == 0)
            else $error("reset did not work as intended");
        assert(a_out == 0)
            else $error("reset did not work as intended");
        assert(b_out == 0)
            else $error("reset did not work as intended");

        reset = 0;
        a_in = -3;
        b_in = 4;

        @(posedge clk);
        #1;

        assert(acc == -12)
            else $error("negative x positive multiplication did not work");
        assert(a_out == -3)
            else $error("new a_in did not propagate to a_out");
        assert(b_out == 4)
            else $error("new b_in did not propagate to b_out");

        a_in = 2;
        b_in = 5;

        @(posedge clk);
        #1;

        assert(acc == -2)
            else $error("adding to negative output did not work");
        assert(a_out == 2)
            else $error("new a_in did not propagate to a_out");
        assert(b_out == 5)
            else $error("new b_in did not propagate to b_out");
        
        a_in = -2;
        b_in = -3;

        @(posedge clk);
        #1;
        
        assert(acc == 4)
            else $error("negative x negative multiplication did not work");
        assert(a_out == -2)
            else $error("negative a_in did not propagate to a_out");
        assert(b_out == -3)
            else $error("negative b_in did not propagate to b_out");
        
        $display("all tests passed!");
        $finish;
    end       

endmodule