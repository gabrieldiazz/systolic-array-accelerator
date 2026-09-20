module systolic_array_file_tb;

    integer input_file;
    integer scan_result;
    integer value;
    integer output_file;

    integer A [0:2][0:2];
    integer B [0:2][0:2];

    logic clk;
    logic reset;

    logic signed [7:0] a_in [3];
    logic signed [7:0] b_in [3];

    wire signed [31:0] c [3][3];

    systolic_array #(
        .WIDTH(8),
        .SIZE(3),
        .ACC_WIDTH(32)
    ) dut (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .c(c)
    );

    // helper task to simplify setting systolic array inputs
    task set_inputs(
        input logic signed [7:0] a0,
        input logic signed [7:0] a1,
        input logic signed [7:0] a2,
        input logic signed [7:0] b0,
        input logic signed [7:0] b1,
        input logic signed [7:0] b2
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
        input_file = $fopen("verification/input.txt", "r");

        if (input_file == 0) begin
            $display("ERROR: Could not open input.txt");
            $finish;
        end
        
        //construct A matrix
        for (int i = 0; i < 3; i = i + 1) begin
            for (int j = 0; j < 3; j = j + 1) begin
                scan_result = $fscanf(input_file, "%d", value);
                A[i][j] = value;

                if (scan_result != 1) begin
                    $display("ERROR: Failed reading A[%0d][%0d]", i, j);
                    $finish;
                end
            end
        end

        //construct B matrix
        for (int i = 0; i < 3; i = i + 1) begin
            for (int j = 0; j < 3; j = j + 1) begin
                scan_result = $fscanf(input_file, "%d", value);
                B[i][j] = value;

                if (scan_result != 1) begin
                    $display("ERROR: Failed reading B[%0d][%0d]", i, j);
                    $finish;
                end
            end
        end
        $fclose(input_file);

        //display the matrices
        $display("A:");
        for (int i = 0; i < 3; i = i + 1) begin
            $display("%0d %0d %0d", A[i][0], A[i][1], A[i][2]);
        end

        $display("B:");
        for (int i = 0; i < 3; i = i + 1) begin
            $display("%0d %0d %0d", B[i][0], B[i][1], B[i][2]);
        end

        // reset everything and then set up the staggered inputs
        reset = 1;
        set_inputs(0, 0, 0, 0, 0, 0);

        @(posedge clk);
        #1;

        reset = 0;
        
        for (int t=0; t<5; t = t+1) begin
            for (int i=0; i<3; i = i+1) begin
                if ((t-i) >= 0 && (t-i) < 3) begin 
                    a_in[i] = A[i][t-i];
                    b_in[i] = B[t-i][i];
                end
                else begin
                    a_in[i] = 0;
                    b_in[i] = 0;
                end
            end
            
            @(posedge clk);
            #1;
        end 

        set_inputs(0,0,0, 0,0,0);

        @(posedge clk);
        #1;

        @(posedge clk);
        #1;

        $display("C:");
        for (int i = 0; i < 3; i = i + 1) begin
            $display("%0d %0d %0d", c[i][0], c[i][1], c[i][2]);
        end

        output_file = $fopen("verification/output.txt", "w");
        if (output_file == 0) begin
            $display("ERROR: Could not open output.txt");
            $finish;
        end

        for (int i = 0; i < 3; i = i + 1) begin
            $fdisplay(
                output_file,
                "%0d %0d %0d",
                c[i][0],
                c[i][1],
                c[i][2]
            );
        end

        $fclose(output_file);
        $finish;
    end
endmodule