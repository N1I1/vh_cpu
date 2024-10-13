.PHONY: all co si gt clean
ARCH=riscv64

DIFF_FILE = tests/build/diff.log
all: co si $(DIFF_FILE)
	@echo "All done."
	@echo "Please check the diff.log file.(tests/build/diff.log)"

$(DIFF_FILE): tests/build/format_res.log tests/build/format_spike.log
	@python3 tests/src/diff.py
	@echo "Format done."

tests/build/format_res.log: 
	@cd tests && make

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
	rm -f *.vcd *.vvp *.log
	@cd tests && make clean
	@echo "Clean done."
