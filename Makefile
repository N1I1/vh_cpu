.PHONY: all co si gt clean
ARCH=riscv64

DIFF_FILE = tests/build/diff.log

all: co si diff
	@echo "All done."
	@echo "Please check the diff.log file.(tests/build/diff.log)"

diff: tests/build/format_res.log tests/build/format_spike.log
	@python3 tests/src/diff.py
	@echo "Diff done."

tests/build/format_res.log: co si


tests/build/format_spike.log: 
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
	rm -f *.vcd *.vvp
	rm -f tests/build/diff.log tests/build/format_res.log tests/build/res.log tests/build/correct_instr.log
	@echo "Clean done."

clean-all:
	rm -f *.vcd *.vvp *.log
	@cd tests && make clean
	@echo "Clean-all done."
