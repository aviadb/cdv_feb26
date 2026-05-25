VERILATOR  = verilator
TOP 			?= sync_fifo_top
NPROC = $(shell nproc)
PROJECT_ROOT = $(CURDIR)/..
UVM_DIR     = $(PROJECT_ROOT)/cdv_feb26/third-party/uvm-verilator
SRCS       =  $(UVM_DIR)/src/uvm.sv \
							$(PROJECT_ROOT)/dv/sync_fifo_uvm/sync_fifo_if.sv \
						  $(PROJECT_ROOT)/dv/sync_fifo_uvm/sync_fifo_top.sv \
							$(PROJECT_ROOT)/rtl/block_cells/mem_if.sv \
							$(PROJECT_ROOT)/rtl/block_cells/mem_block_dp_cell.sv \
							$(PROJECT_ROOT)/rtl/block_cells/sync_fifo_block_cell.sv \


VERILOG_INCLUDE_DIRS = $(UVM_DIR)/src \
 $(PROJECT_ROOT)/rtl \
 $(PROJECT_ROOT)/dv/sync_fifo_uvm/

SIM_NAME ?= $(TOP)
SIM_DIR ?= $(SIM_NAME)-sim

# Compile with coverage
# compile:
$(SIM_DIR)/$(SIM_NAME).mk:
	$(VERILATOR) \
	--cc \
	--exe \
	--main \
	--timing \
	--sched-zero-delay \
	-Mdir $(SIM_DIR) \
	--output-groups $(NPROC) \
	--prefix $(SIM_NAME) -o $(SIM_NAME).test \
	-DUVM_NO_DPI \
	$(addprefix +incdir+, $(VERILOG_INCLUDE_DIRS)) \
	$(SRCS)

$(SIM_DIR)/$(SIM_NAME): $(SIM_DIR)/$(SIM_NAME).mk
	$(MAKE) -j${NPROC} -C $(SIM_DIR) $(BUILD_ARGS) -f $(SIM_NAME).mk

simulate: $(SIM_DIR)/$(SIM_NAME).mk $(SIM_DIR)/$(SIM_NAME)
	@echo "[2/4] Running simulation..."
	$(SIM_DIR)/$(SIM_NAME).test
# Run simulation
# simulate: compile
# 	@echo "[2/4] Running simulation..."
# 	# ./obj_dir/V$(TOP)
# 	$(SIM_DIR)/$(SIM_NAME)

clean:
	rm -rf simv*.daidir csrc
	rm -rf csrc* simv*
	rm -rf $(SIM_DIR)

.PHONY: compile simulate



	# @echo "[1/4] Compiling design..."
	# $(VERILATOR) \
	# $(UVM_DIR)/src/uvm.sv -I$(UVM_DIR)/src/ \
	# -I$(PROJECT_ROOT)/dv/sync_fifo_uvm/ \
	# --binary \
	# -j 0 \
	# --prefix Vtop \
	# --top-module $(TOP) \
	# --timing \
	# --trace-fst \
	# --trace-params \
	# --trace-structs \
	# --trace-max-array 1024 \
	# --trace-max-width 1024 \
	# $(SRCS) \
