module cpu;

reg clk;
reg rst;

always begin
    #5 clk = ~clk;
end

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu);

    clk = 0;
    rst = 1;
    #10 rst = 0;
    #340 $finish;
end

data_path dp(clk, rst);

endmodule