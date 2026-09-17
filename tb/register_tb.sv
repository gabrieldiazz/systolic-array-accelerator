module register_tb;

    logic clk;
    logic reset;
    logic [7:0] d;
    logic [7:0] q;

    register #(
        .WIDTH(8)
    ) dut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end 

    initial begin
        reset = 1;
        d = 42;

        @(posedge clk);
        #1;

        assert( q == 0)
            else $error("output doesnt reset when reset=1");
        
        reset = 0;
        d = 42;

        @(posedge clk);
        #1;

        assert( q == d )
            else $error("output doesnt match d at rising edge");
        
        $display("all tests passed!");
        $finish;

        
    end
endmodule 

