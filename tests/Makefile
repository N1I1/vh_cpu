AS = riscv64-unknown-elf-as
LD = riscv64-unknown-elf-ld

SRC_DIR = src
BUILD_DIR = build

SPIKE_FLAGS = -m0x2000:0x20000 --isa=RV64I --log-commits --log=build/spike.log build/output.elf

SRC_FILES = $(wildcard $(SRC_DIR)/*.S)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.S,$(BUILD_DIR)/%.o,$(SRC_FILES))
START_FILE = $(BUILD_DIR)/start.o
OUTPUT_FILE = $(BUILD_DIR)/output.elf
SPIKE_LOG_FILE = $(BUILD_DIR)/spike.log
FORMAT_FILE = $(BUILD_DIR)/format_spike.log

all: $(SPIKE_LOG_FILE) $(FORMAT_FILE)

$(FORMAT_FILE): $(SPIKE_LOG_FILE)
	python3 src/format.py

$(SPIKE_LOG_FILE): $(OUTPUT_FILE)
	spike  $(SPIKE_FLAGS) $(OUTPUT_FILE)

$(OUTPUT_FILE): $(START_FILE) $(OBJ_FILES) 
	$(LD) -T src/test.ld -o $@ $^

$(START_FILE): $(SRC_DIR)/start.s
	@mkdir -p $(BUILD_DIR)  # Create build directory if it doesn't exist
	$(AS) -o $@ $<

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	@mkdir -p $(BUILD_DIR)  # Create build directory if it doesn't exist
	$(AS) -o $@ $<

clean:
	rm -rf $(BUILD_DIR)/* $(OUTPUT_FILE) $(SPIKE_LOG_FILE) $(FORMAT_FILE)

.PHONY: all clean
