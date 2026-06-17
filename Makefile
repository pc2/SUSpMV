# You may override $(BIN_DIR) to a directory of your liking. For instance for parallel builds, you can `make U280/overlay_hw.xclbin BIN_DIR=U280_test` 

TMPDIR := /tmp/vivado_$(USER)

$(TMPDIR):
	mkdir -p $(TMPDIR)

FILES := 
FILES += suspmv.sus
FILES += suspmv_io.sus
FILES += slr_crossing.sus
FILES += sus-float/fp_custom.sus
FILES += sus-xrt/axi_memory.sus
FILES += sus-tapasco/sus/tapasco_ctrl_slave.sus

# Configurations that change based on the platform
VCK5000/%: BIN_DIR ?= VCK5000
VCK5000/%: PART := xcvc1902-vsvd1760-2MP-e-S
VCK5000/%: PLATFORM := xilinx_vck5000_gen4x8_qdma_2_202220_1
VCK5000/%: SUS_FLOAT_LIB_PATH := sus-float/Versal

U280/%: BIN_DIR ?= U280
U280/%: PART := xcu280-fsvh2892-2L-e
U280/%: PLATFORM := xilinx_u280_gen3x16_xdma_1_202211_1
U280/%: SUS_FLOAT_LIB_PATH := sus-float/UltraScalePlus
U280/%: FILES += sus-float/UltraScalePlus/extensions.sus
U280/%: FILES += sus-float/UltraScalePlus/fp_wrappers.sus
U280/%: FILES += suspmv_top_u280.sus

v80/%: BIN_DIR ?= v80
v80/%: PART := xcv80-lsva4737-2MHP-e-S
#v80/%: PLATFORM := xilinx_u280_gen3x16_xdma_1_202211_1
v80/%: SUS_FLOAT_LIB_PATH := sus-float/Versal
v80/%: FILES += sus-float/Versal/fp_wrappers.sus
v80/%: FILES += sus-float/Versal/extensions.sus

U280/sus_codegen.sv: $(FILES) suspmv_top_u280.sus
	mkdir -p $(BIN_DIR)
	sus_compiler $(FILES) -o $(BIN_DIR)/sus_codegen.sv --top SUSpMV_Full

XOS_VCK := $(BIN_DIR)/SUSpMV_Full.xo
LOCAL_XOS := ../SUSpMV_Full.xo

U280/SUSpMV_Full.zip: pack_kernel.tcl pblocks.xdc U280/sus_codegen.sv slr_crossing.sv
	rm -f $(BIN_DIR)/SUSpMV_Full.xo
	rm -rf $(BIN_DIR)/pack_prj
	mkdir $(BIN_DIR)/pack_prj
	cd $(BIN_DIR)/pack_prj;\
	vivado -mode batch -source ../../pack_kernel.tcl -tclargs $(PART) ../SUSpMV_Full.xo $(SUS_FLOAT_LIB_PATH) ../../pblocks.xdc
	rm -f $(BIN_DIR)/SUSpMV_Full.zip
	cd $(BIN_DIR)/pack_prj && zip -r ../SUSpMV_Full.zip SUSpMV_Full_ip

v80/sus_codegen.sv: $(FILES)
	mkdir -p $(BIN_DIR)
	sus_compiler $(FILES) -o $(BIN_DIR)/sus_codegen.sv --top SUSpMV_Full

v80/SUSpMV_Full.zip: pack_kernel.tcl pblocks_v80.xdc v80/sus_codegen.sv slr_crossing.sv
	rm -f $(BIN_DIR)/SUSpMV_Full.xo
	rm -rf $(BIN_DIR)/pack_prj
	mkdir $(BIN_DIR)/pack_prj
	cd $(BIN_DIR)/pack_prj;\
	vivado -mode batch -source ../../pack_kernel.tcl -tclargs $(PART) ../SUSpMV_Full.xo $(SUS_FLOAT_LIB_PATH) ../../pblocks_v80.xdc
	rm -f $(BIN_DIR)/SUSpMV_Full.zip
	cd $(BIN_DIR)/pack_prj && zip -r ../SUSpMV_Full.zip SUSpMV_Full_ip

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
	rm -rf v80
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

testMultiAccumulate: U280/sus_codegen.sv
	cd tests/MultiAccumulate && vivado -mode batch -source sim.tcl

testSpMVUnit_random: U280/sus_codegen.sv
	cd tests/SpMVUnit_random && vivado -mode batch -source sim.tcl

testSpMVUnit_known: U280/sus_codegen.sv
	cd tests/SpMVUnit_known && vivado -mode batch -source sim.tcl

testIO: U280/sus_codegen.sv tests/IO/matrix_params.vh
	cd tests/IO && vivado -mode batch -source sim.tcl

U280/tapasco: U280/SUSpMV_Full.zip
	tapasco import $(BIN_DIR)/SUSpMV_Full.zip as 100 -p AU280
	tapasco --jobsFile tapasco/job_au280.json

v80/tapasco: v80/SUSpMV_Full.zip
	tapasco import $(BIN_DIR)/SUSpMV_Full.zip as 100 -p v80
	tapasco --jobsFile tapasco/job_v80.json

.PHONY: U280/tapasco

host/CMakeCache.txt:
	cd host && cmake -S . -B .

host/suspmv: host/src/main.cpp host/src/dump_hex.cpp host/src/matrix.cpp host/src/matrix.h host/src/consts.h host/CMakeCache.txt
	cd host && cmake --build .

# download all supported matrices
host/test/arc130/arc130.mtx:
	cd host;\
	python3 -m venv venv;\
	source venv/bin/activate;\
	pip install ssgetpy;\
	ssgetpy --format MM --data-type real --outdir test/;\

tests/IO/test_data_arc130: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/arc130/arc130.mtx 0

tests/IO/test_data_1138_bus: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/1138_bus/1138_bus.mtx 0

tests/IO/test_data_bcsstk16: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/bcsstk16/bcsstk16.mtx 0

tests/IO/test_data_ASIC_680k_modified: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/ASIC_680k_modified/ASIC_680k_modified.mtx 0

tests/IO/test_data_analytics: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/analytics/analytics.mtx 0

tests/IO/test_data_human_gene1: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/Belcastro/human_gene1/human_gene1.mtx 0

tests/IO/test_data_null: #host/suspmv
	cd tests/IO/ && ../../host/suspmv ../../host/test/null/null.mtx 0
