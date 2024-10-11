`include "../include/riscv64/common.vh"

module Logger;
    integer logfile=0;

    task log(input string msg);
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end
        $fdisplay(logfile, "%s", msg);
        $display("%s", msg);
    endtask

    task write_log(input string msg);
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end
        $fdisplay(logfile, "%s", msg);
    endtask
 
    task log_warning(input string msg);
        string format;
        format = `ANSI_FMT(`ARCH, `ANSI_BG_YELLOW);
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end
        $fdisplay(logfile, "%s", format);
        $display("%s", format)
    endtask

    task log_wrong(input string msg);
        string format;
        format = `ANSI_FMT(`ARCH, `ANSI_BG_REG);
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end
        $fdisplay(logfile, "%s", format);
        $display("%s", format)
    endtask

    task log_start_info();
        string start_info;
        start_info = `ANSI_FMT(`ARCH, `ANSI_BG_GREEN); 
        if (logfile == 0) begin
            logfile = $fopen("log.txt", "w");
        end

        $display("ARCH %s Starting simulation...", start_info);
        $fdisplay(logfile, "ARCH %s Starting simulation...", start_info);
    endtask

    task close_log();
        $fdisplay(logfile, "Simulation finished. Log file closed.");
        if (logfile != 0) begin
            $fclose(logfile);
        end
    endtask
    
endmodule