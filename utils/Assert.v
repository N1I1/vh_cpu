`include "../include/riscv64/common.vh"

module Assert;
    Logger lg();

    task assert_color(input bit condition, input string msg);
        if (!condition) begin
            string formatted_msg;
            formatted_msg = `ANSI_FMT(msg, `ANSI_BG_RED);
            $display(formatted_msg);
            // lg.write_log(formatted_msg);
        end
    endtask

endmodule