module mac_tb;
    logic clk;
    logic reset;
    logic [7:0] a;
    logic [7:0] b;
    logic [31:0] acc;

    mac #(
        .WIDTH(8)
    ) dut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .acc(acc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        a = 2;
        b = 3;

        @(posedge clk);
        #1;

        assert(acc == 0)
            else $error("initial reset failed");
        
        reset = 0;

        @(posedge clk);
        #1;

        assert(acc == 6)
            else $error("multiplication does not work as intended");
        
        

        @(posedge clk);
        #1;

        assert(acc == 12)
            else $error("accumulation does not add over another positive edge");

        @(posedge clk);
        #1;

        assert(acc == 18)
            else $error("accumulation does not add over another positive edge");
        
        reset = 1;
        @(posedge clk);
        #1;
        
        assert(acc == 0)
            else $error("reset does not reset mac's output");
        
        $display("all tests passed!");
        $finish;
    end
endmodule
        

