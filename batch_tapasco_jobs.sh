
# Use this script to batch FPGA synthesis jobs for Tapasco. 

source u280_tapasco_modules.sh
source ../otus/tapasco-workdir/tapasco-setup.sh

make U280/SUSpMV_Full.zip

mkdir -p fpga_builds

sbatch tapasco_frequency_study_job.sh
