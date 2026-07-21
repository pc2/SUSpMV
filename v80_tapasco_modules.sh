ml reset
# ml fpga/xilinx/vitis/22.2 # module can't be loaded, because it depends on xrt, that was deinstalled
source /opt/software/FPGA/Xilinx/Vitis/2024.2/settings64.sh
ml lang/Java/11.0.27
ml lang/Rust/1.88.0-GCCcore-14.3.0
ml tools/binutils/2.44-GCCcore-14.3.0
ml devel/protobuf/31.1-GCCcore-14.3.0
ml devel/CMake/3.31.8-GCCcore-14.3.0
export TAPASCO_PLATFORM=pcie

ml tools/Zip/3.0-GCCcore-14.3.0
# ml fpga/xilinx/vivado/22.2
export XILINXD_LICENSE_FILE=27000@kiso.uni-paderborn.de
export LM_LICENSE_FILE=27000@kiso.uni-paderborn.de

source ../otus/tapasco-workdir-v80/tapasco-setup.sh
