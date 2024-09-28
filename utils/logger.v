`include "./include/riscv64/common.vh"
`include "../include/color.vh"

module Logger;
    integer logfile=0;

    task log(input string msg);
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end
        $fdisplay(logfile, "%s", msg);
        $display("%s", msg);
    endtask

    task log_start_info;
        string str ;
        str = `ANSI_FMT(`ARCH, `ANSI_BG_GREEN); 
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end

        $display("ARCH %s Starting simulation...", str);
        $fdisplay(logfile, "ARCH %s Starting simulation...", str);
    endtask
    

    task close_log;
        if (logfile != 0) begin
            $fclose(logfile);
        end
    endtask
endmodule