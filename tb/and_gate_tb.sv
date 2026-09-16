module and_gate_tb;

    logic a;
    logic b;
    logic y;

    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $monitor("time=%0t a=%b b=%b y=%b", $time, a, b, y);
    end

    initial begin
        a = 0;
        b = 0;
        #10;
        assert(y == 0)
            else $error("0 AND 0 failed");

        a = 0;
        b = 1;
        #10;
        assert(y == 0)
            else $error("0 AND 0 failed");

        a = 1;
        b = 0;
        #10;
        assert(y == 0)
            else $error("0 AND 0 failed");


        a = 1;
        b = 1;
        #10;
        assert(y == 1)
            else $error("0 AND 0 failed");

        $display("All tests passed!");
        $finish;
    end

endmodule

