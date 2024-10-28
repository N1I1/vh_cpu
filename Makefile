.PHONY: clean update_instr_file base
.PHONY: diff

ARCH=riscv64

ifeq ($(f),)
    $(error f=$(f) is not a correct file)
else
    $(info f=$(f) You can use 'export f=your_file' to set the file, or 'make f=your_file' to sepify the file. (No type only name))
endif



all: update_instr_file base
	@echo "All done."
	@echo "If you want to diff the result in linux, run 'make diff'."

# -------------------------------------------------
# Compile and simulate
base: compile simulate
	@echo "Base done."

compile: 
	@iverilog  -g2005-sv -o $(f).vvp -y ./components/ -y . -y ./utils/ -I ./include -I ./include/$(ARCH) $(f).v
	@echo "Compilation is complete."

simulate:
	@vvp -n $(f).vvp
	@echo "Simulation done."

gt:
	@gtkwave *.vcd
	@echo "Waveform done."

# -------------------------------------------------
# Spike
SPIKE_BUILD_DIR = $(SPIKE_DIR)/build
SPIKE_DIR = spike

SPIKE_LOG = $(SPIKE_DIR)/build/$(SPIKE_DIR).log
SPIKE_FORMAT_LOG = $(SPIKE_BUILD_DIR)/format_spike.log

ifeq ($(wildcard $(SPIKE_LOG)),)
$(SPIKE_LOG):
	@cd $(SPIKE_DIR) && make
endif

ifeq ($(wildcard $(SPIKE_FORMAT_LOG)),)
$(SPIKE_FORMAT_LOG): $(SPIKE_LOG)
	@cd $(SPIKE_DIR) && make format
endif



# -------------------------------------------------
BUILD_DIR = build

DIFF_LOG = $(BUILD_DIR)/diff.log
RES_LOG = $(BUILD_DIR)/res.log
FORMAT_RES_LOG = $(BUILD_DIR)/format_res.log
CORRECT_INSTR_LOG = $(BUILD_DIR)/correct_instr.log
ORDERED_CORRECT_INSTR_LOG = $(BUILD_DIR)/orrdered_correct_instr.log
ALL_RES_LOG = $(RES_LOG) $(FORMAT_RES_LOG) $(DIFF_LOG) \
	$(CORRECT_INSTR_LOG) $(ORDERED_CORRECT_INSTR_LOG)

ELF_FILE = $(BUILD_DIR)/output.elf
RAM_FILE = $(BUILD_DIR)/ram.hex
ASSETS_DIR = assets

export SPIKE_BUILD_DIR ARCH SPIKE_DIR RES_LOG FORMAT_RES_LOG CORRECT_INSTR_LOG 
export ORDERED_CORRECT_INSTR_LOG SPIKE_LOG SPIKE_FORMAT_LOG ALL_RES_LOG
export ELF_FILE RAM_FILE ASSETS_DIR

order: $(CORRECT_INSTR_LOG)
	@sort -k 3 $(CORRECT_INSTR_LOG) > $(ORDERED_CORRECT_INSTR_LOG)

diff: $(FORMAT_RES_LOG) $(SPIKE_FORMAT_LOG)
	@python3 $(SPIKE_DIR)/src/diff.py
	@echo "Diff done."

ifeq ($(wildcard $(FORMAT_RES_LOG)),)
$(FORMAT_RES_LOG): update_instr_file base
endif

update_instr_file: $(SPIKE_LOG)
	@python assets/elf2instr.py
	@echo "Update instr file done."

# not implemented yet
init_ram: $(SPIKE_LOG)
	@python assets/elf2ram.py
	@echo "Init ram done."


# ------------------------------------------------
clean:
	rm -f *.vcd *.vvp
	rm -f $(ALL_RES_LOG) $(BUILD_DIR)/*.log
	@echo "Clean done."

clean-all:
	rm -f *.vcd *.vvp *.log
	@cd $(SPIKE_DIR) && make clean
	@echo "Clean-all done."