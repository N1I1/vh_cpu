.PHONY: clean update_instr_file base
.PHONY: diff

ARCH=riscv64

ifeq ($(f),)
    $(error f=$(f) is not a correct file)
else
    $(info f=$(f) You can use 'export f=your_file' to set the file, or 'make f=your_file' to sepify the file. (No type only name))
endif



all: base
	@echo "All done."
	@echo "If you want to diff the result, run 'make diff'."

# -------------------------------------------------
# Compile and simulate
SRC=src
base: compile simulate
	@echo "Base done."

compile: 
	@iverilog  -g2005-sv -o $(f).vvp -y $(SRC)/components/ -y. -y $(SRC)/utils/ -y ./kit/ -I $(SRC)/include $(f).v
	@echo "Compilation is complete."

simulate:
	@vvp -n $(f).vvp
	@echo "Simulation done."

gt:
	@gtkwave *.vcd
	@echo "Waveform done."

# ------------------------------------------------
# generate ref.log

EMU_DIR = simple_rv_emu
REF_LOG = $(EMU_DIR)/build/ref.log
DUT_LOG = build/dut.log

$(REF_LOG):
	@cd $(EMU_DIR) && make && ./build/emulator

$(DUT_LOG): base

update_ram:
	cp assets/ram.hex $(EMU_DIR)/assets/instr.hex

diff: update_instr_file $(REF_LOG) $(DUT_LOG)
	@python3 assets/diff.py

clean:
	rm -f *.vcd *.vvp
	rm -rf build/*
	@echo "Clean done."

clean-all:
	rm -f *.vcd *.vvp *.log
	@cd $(EMU_DIR) && make clean
	@echo "Clean-all done."