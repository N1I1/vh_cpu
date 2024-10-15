.PHONY: all co si gt clean
ARCH=riscv64

LOG_DIR = tests/build

DIFF_FILE = $(LOG_DIR)/diff.log
RES_FILE = $(LOG_DIR)/res.log
FORMAT_RES_FILE = $(LOG_DIR)/format_res.log

CORRECT_INSTR_FILE = $(LOG_DIR)/correct_instr.log
ORDERED_CORRECT_INSTR_FILE = $(LOG_DIR)/orrdered_correct_instr.log

ALL_RES_FILE = $(RES_FILE) $(FORMAT_RES_FILE) $(DIFF_FILE) \
	$(CORRECT_INSTR_FILE) $(ORDERED_CORRECT_INSTR_FILE)

SPIKE_FILE = tests/build/spike.log
SPIKE_FORMAT_RES_FILE = $(LOG_DIR)/format_spike.log



all: update_instr_file co si diff order
	@echo "All done."
	@echo "Please check the diff.log file.($(LOG_DIR)/diff.log)"

	
order: $(CORRECT_INSTR_FILE)
	@sort -k 3 $(LOG_DIR)/correct_instr.log > $(LOG_DIR)/orrdered_correct_instr.log

diff: $(FORMAT_RES_FILE) $(SPIKE_FORMAT_RES_FILE)
	@python3 tests/src/diff.py
	@echo "Diff done."

$(FORMAT_RES_FILE): update_instr_file co si


$(SPIKE_FORMAT_RES_FILE):
	@cd tests && make

$(SPIKE_FILE):
	@cd tests && make

update_instr_file: $(SPIKE_FILE)
	@python3 assets/elf2instr.py
	@echo "Update instr file done."

co: 
	@iverilog  -g2005-sv -o $(f).vvp -y ./components/ -y . -y ./utils/ -I ./include -I ./include/$(ARCH) $(f).v
	@echo "Compilation is complete."

si:
	@vvp -n $(f).vvp
	@echo "Simulation done."

gt:
	@gtkwave *.vcd
	@echo "Waveform done."

clean:
	rm -f *.vcd *.vvp
	rm -f $(ALL_RES_FILE)
	@echo "Clean done."

clean-all:
	rm -f *.vcd *.vvp *.log
	@cd tests && make clean
	@echo "Clean-all done."