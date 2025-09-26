# Makefile for CSE 320 LAB 2 - Verilog Project
# Supports Icarus Verilog (iverilog) simulation

# Directories
SRC_DIR = src
TB_DIR = testbench
SIM_DIR = sim

# Verilog compiler and simulator
VERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.v)
TESTBENCHES = $(wildcard $(TB_DIR)/*_tb.v)

# Default target
all: compile_all simulate_all

# Create simulation directory
$(SIM_DIR):
	@mkdir -p $(SIM_DIR)

# Individual module simulations
alu: $(SIM_DIR)
	@echo "=== Compiling and simulating ALU ==="
	$(VERILOG) -o $(SIM_DIR)/alu_sim $(SRC_DIR)/alu.v $(TB_DIR)/alu_tb.v
	$(VVP) $(SIM_DIR)/alu_sim

register_file: $(SIM_DIR)
	@echo "=== Compiling and simulating Register File ==="
	$(VERILOG) -o $(SIM_DIR)/register_file_sim $(SRC_DIR)/register_file.v $(TB_DIR)/register_file_tb.v
	$(VVP) $(SIM_DIR)/register_file_sim

counter: $(SIM_DIR)
	@echo "=== Compiling and simulating Counter ==="
	$(VERILOG) -o $(SIM_DIR)/counter_sim $(SRC_DIR)/counter.v $(TB_DIR)/counter_tb.v
	$(VVP) $(SIM_DIR)/counter_sim

decoder: $(SIM_DIR)
	@echo "=== Compiling and simulating Decoder ==="
	$(VERILOG) -o $(SIM_DIR)/decoder_sim $(SRC_DIR)/decoder.v $(TB_DIR)/decoder_tb.v
	$(VVP) $(SIM_DIR)/decoder_sim

cpu_top: $(SIM_DIR)
	@echo "=== Compiling and simulating CPU Top ==="
	$(VERILOG) -o $(SIM_DIR)/cpu_top_sim $(SOURCES) $(TB_DIR)/cpu_top_tb.v
	$(VVP) $(SIM_DIR)/cpu_top_sim

# Compile all modules
compile_all: $(SIM_DIR)
	@echo "=== Compiling all modules ==="
	$(VERILOG) -o $(SIM_DIR)/alu_sim $(SRC_DIR)/alu.v $(TB_DIR)/alu_tb.v
	$(VERILOG) -o $(SIM_DIR)/register_file_sim $(SRC_DIR)/register_file.v $(TB_DIR)/register_file_tb.v
	$(VERILOG) -o $(SIM_DIR)/counter_sim $(SRC_DIR)/counter.v $(TB_DIR)/counter_tb.v
	$(VERILOG) -o $(SIM_DIR)/decoder_sim $(SRC_DIR)/decoder.v $(TB_DIR)/decoder_tb.v
	$(VERILOG) -o $(SIM_DIR)/cpu_top_sim $(SOURCES) $(TB_DIR)/cpu_top_tb.v
	@echo "=== Compilation completed ==="

# Simulate all modules
simulate_all: compile_all
	@echo "=== Running all simulations ==="
	@echo "\n--- ALU Simulation ---"
	$(VVP) $(SIM_DIR)/alu_sim
	@echo "\n--- Register File Simulation ---"
	$(VVP) $(SIM_DIR)/register_file_sim
	@echo "\n--- Counter Simulation ---"
	$(VVP) $(SIM_DIR)/counter_sim
	@echo "\n--- Decoder Simulation ---"
	$(VVP) $(SIM_DIR)/decoder_sim
	@echo "\n--- CPU Top Simulation ---"
	$(VVP) $(SIM_DIR)/cpu_top_sim
	@echo "=== All simulations completed ==="

# Generate VCD files for waveform viewing
vcd: $(SIM_DIR)
	@echo "=== Generating VCD waveform files ==="
	$(VERILOG) -o $(SIM_DIR)/cpu_top_vcd $(SOURCES) $(TB_DIR)/cpu_top_tb.v
	$(VVP) $(SIM_DIR)/cpu_top_vcd

# Clean simulation files
clean:
	@echo "=== Cleaning simulation files ==="
	rm -rf $(SIM_DIR)/*
	@echo "=== Clean completed ==="

# Check if iverilog is installed
check_tools:
	@echo "=== Checking required tools ==="
	@which $(VERILOG) > /dev/null || (echo "Error: iverilog not found. Please install Icarus Verilog." && exit 1)
	@which $(VVP) > /dev/null || (echo "Error: vvp not found. Please install Icarus Verilog." && exit 1)
	@echo "Tools check passed: iverilog and vvp are available"

# Install tools (for Ubuntu/Debian systems)
install_tools:
	@echo "=== Installing Icarus Verilog ==="
	sudo apt-get update
	sudo apt-get install -y iverilog gtkwave

# Help target
help:
	@echo "CSE 320 LAB 2 - Verilog Project Makefile"
	@echo "========================================="
	@echo "Available targets:"
	@echo "  all            - Compile and simulate all modules"
	@echo "  alu            - Simulate ALU module"
	@echo "  register_file  - Simulate Register File module"
	@echo "  counter        - Simulate Counter module"
	@echo "  decoder        - Simulate Decoder module"
	@echo "  cpu_top        - Simulate top-level CPU module"
	@echo "  compile_all    - Compile all modules without simulation"
	@echo "  simulate_all   - Run all simulations"
	@echo "  vcd            - Generate VCD waveform files"
	@echo "  clean          - Clean simulation files"
	@echo "  check_tools    - Check if required tools are installed"
	@echo "  install_tools  - Install Icarus Verilog (Ubuntu/Debian)"
	@echo "  help           - Show this help message"

# Phony targets
.PHONY: all alu register_file counter decoder cpu_top compile_all simulate_all vcd clean check_tools install_tools help