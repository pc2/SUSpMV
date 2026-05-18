# You may override $(BIN_DIR) to a directory of your liking. For instance for parallel builds, you can `make U280/overlay_hw.xclbin BIN_DIR=U280_test` 

TMPDIR := /tmp/vivado_$(USER)

$(TMPDIR):
	mkdir -p $(TMPDIR)

# Configurations that change based on the platform
VCK5000/%: BIN_DIR ?= VCK5000
VCK5000/%: PART := xcvc1902-vsvd1760-2MP-e-S
VCK5000/%: PLATFORM := xilinx_vck5000_gen4x8_qdma_2_202220_1

U280/%: BIN_DIR ?= U280
U280/%: PART := xcu280-fsvh2892-2L-e
U280/%: PLATFORM := xilinx_u280_gen3x16_xdma_1_202211_1

FILES := 
FILES += suspmv.sus
FILES += suspmv_io.sus
FILES += sus-float/fp_custom.sus
FILES += sus-float/UltraScalePlus/extensions.sus
FILES += sus-float/UltraScalePlus/fp_wrappers.sus
FILES += sus-xrt/axi.sus

sus_codegen.sv: $(FILES)
	sus_compiler $(FILES) -o sus_codegen.sv --top SUSpMV_Full

XOS_VCK := $(BIN_DIR)/suspmv.xo
LOCAL_XOS := ../suspmv.xo

$(BIN_DIR)/suspmv.xo: pack_kernel.tcl sus_codegen.sv
	mkdir -p $(BIN_DIR)
	rm -f $(BIN_DIR)/suspmv.xo
	rm -rf $(BIN_DIR)/pack_prj$*
	mkdir $(BIN_DIR)/pack_prj$*
	cd $(BIN_DIR)/pack_prj$*;\
	vivado -mode batch -source ../../pack_kernel.tcl -tclargs $(PART) $* ../suspmv.xo

VCK5000/overlay_hw_emu.xclbin: vck5000_connectivity.cfg $(XOS_VCK)
	rm -f $(BIN_DIR)/overlay_hw_emu.xclbin
	rm -rf $(BIN_DIR)/overlay_hw_emu_prj
	mkdir $(BIN_DIR)/overlay_hw_emu_prj
	cd $(BIN_DIR)/overlay_hw_emu_prj &&\
	v++ -l --platform $(PLATFORM) -t hw_emu -s -g --config ../../vck5000_connectivity.cfg -o overlay_hw_emu.xsa $(LOCAL_XOS) &&\
	v++ -p --platform $(PLATFORM) -t hw_emu -o ../overlay_hw_emu.xclbin overlay_hw_emu.xsa --package.boot_mode=ospi

VCK5000/overlay_hw.xclbin: vck5000_connectivity.cfg $(XOS_VCK)
	rm -f $(BIN_DIR)/overlay_hw.xclbin
	rm -rf $(BIN_DIR)/overlay_hw_prj
	mkdir $(BIN_DIR)/overlay_hw_prj
	cd $(BIN_DIR)/overlay_hw_prj &&\
	v++ -l --platform $(PLATFORM) -t hw -s -g --config ../../vck5000_connectivity.cfg -o overlay_hw.xsa $(LOCAL_XOS) &&\
	v++ -p --platform $(PLATFORM) -t hw -o ../overlay_hw.xclbin overlay_hw.xsa --package.boot_mode=ospi
	xclbinutil --info -i $(BIN_DIR)/overlay_hw.xclbin

U280/overlay_hw_emu.xclbin: u280_connectivity.cfg $(XOS_VCK)
	rm -f $(BIN_DIR)/overlay_hw_emu.xclbin
	rm -rf $(BIN_DIR)/overlay_hw_emu_prj
	mkdir $(BIN_DIR)/overlay_hw_emu_prj
	cd $(BIN_DIR)/overlay_hw_emu_prj &&\
	v++ -l --platform $(PLATFORM) -t hw_emu -s -g --config ../../u280_connectivity.cfg -o ../overlay_hw_emu.xclbin $(LOCAL_XOS)

U280/overlay_hw.xclbin: u280_connectivity.cfg $(XOS_VCK)
	rm -f $(BIN_DIR)/overlay_hw.xclbin
	rm -rf $(BIN_DIR)/overlay_hw_prj
	mkdir $(BIN_DIR)/overlay_hw_prj
	cd $(BIN_DIR)/overlay_hw_prj &&\
	v++ -l --platform $(PLATFORM) -t hw -s -g --config ../../u280_connectivity.cfg -o ../overlay_hw.xclbin $(LOCAL_XOS)
	xclbinutil --info -i $(BIN_DIR)/overlay_hw.xclbin

main.x: main.cpp
	g++ -g -O3 -std=c++17 -I$(XILINX_XRT)/include -L$(XILINX_XRT)/lib -lxrt_coreutil -pthread main.cpp -o main.x

.PHONY: _emu
_emu: main.x | $(TMPDIR)
# It appears that the emulation creates .runs in the directory that holds main.x, so we copy it over to /tmp such that the .runs can be safely dropped there. 
# While the temporary directory doesn't seem to improve performance, it does appear that it's less "sticky" than the $PC2HOME filesystem. IE, it's less likely to get stuck undeletable due to xsim and xsimk not dieing
	cp main.x $(TMPDIR)
	cp extra_waves.tcl $(BIN_DIR)/
	cp $(XRT_INI) $(BIN_DIR)/xrt.ini
	cd $(BIN_DIR) &&\
	emconfigutil --platform $(PLATFORM) &&\
	XCL_EMULATION_MODE=hw_emu $(TMPDIR)/main.x u

_run: main.x
	cd $(BIN_DIR) && ../main.x $(ARGS)

.PHONY: U280/emulate U280/emulate_batch U280/run
U280/emulate: XRT_INI := xrt_gui.ini
U280/emulate: _emu
U280/emulate_batch: XRT_INI := xrt_batch.ini
U280/emulate_batch: _emu
U280/run: ARGS := a
U280/run: _run

.PHONY: VCK5000/emulate VCK5000/emulate_batch VCK5000/run
VCK5000/emulate: XRT_INI := xrt_gui.ini
VCK5000/emulate: _emu
VCK5000/emulate_batch: XRT_INI := xrt_batch.ini
VCK5000/emulate_batch: _emu
VCK5000/run: ARGS := e
VCK5000/run: _run

.PHONY: clean cleantmp
clean: cleantmp
	rm -rf VCK5000
	rm -rf U280
	rm -f sus_codegen.sv
	rm -f main.x
	
cleantmp:
	rm -rf $(TMPDIR)

U280/enable_host_mem: 
	sudo /opt/software/FPGA/scripts/u280/host_memory/enable_hostmem_single_fpga.sh 0000\:01\:00.1
	sudo /opt/software/FPGA/scripts/u280/host_memory/enable_hostmem_single_fpga.sh 0000\:81\:00.1
	sudo /opt/software/FPGA/scripts/u280/host_memory/enable_hostmem_single_fpga.sh 0000\:a1\:00.1

U280/reset: 
	xbutil reset -d 0000:a1:00.1 --force

VCK5000/reset: 
	xbutil reset -d 0000:a1:00.1 --force

testMultiAccumulate: sus_codegen.sv
	cd tests/MultiAccumulate && vivado -mode batch -script sim.tcl

testSpMVUnit: sus_codegen.sv
	cd tests/SpMVUnit && vivado -mode batch -script sim.tcl

testIO: sus_codegen.sv
	cd tests/IO && vivado -mode batch -script sim.tcl
