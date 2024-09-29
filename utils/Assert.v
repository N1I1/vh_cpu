`include "./include/riscv64/common.vh"
`include "../include/color.vh"
`include "./Logger.v"

module Assert;
    Logger lg();

    task assert_log(input bit condition, input string msg);
        if (!condition) begin
            string msg = $sformatf("Assertion failed: %s", `ANSI_FMT(msg, `ANSI_FB_RED));
            lg.log(msg);
            $display("Assertion failed: %s", msg);
            $finish;
        end
endmodule