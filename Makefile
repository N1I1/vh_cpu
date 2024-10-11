.PHONY: all co si gt clean
ARCH=riscv64
all: co si

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
	rm -f *.vcd *.vvp log.txt
	@echo "Clean done."
