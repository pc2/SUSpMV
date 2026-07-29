# Host Code

The host code for SuSpMV uses a sparse matrix in .mtx format as input, converts it to the format used by SuSpMV and runs the multiplication with a few test vectors on the desired platform.
Sample .mtx files are available at https://sparse.tamu.edu/ .

## Run Evaluation

```sh
# download matrices
python3 -m venv venv
source venv/bin/activate
pip install ssgetpy
python3 download.py

# run benchmarks
source <tapasco-workspace>/tapasco-setup.sh
tapasco-load-bitstream suspmv.bit
# note: if multiple devices are present, you may need to change src/consts.h "#define TAPASCO_DEVICE_IDX 0"
python3 bench.py

# evaluate results
python3 eval.py
```

## Run Single

```sh
mkdir build
cd build
cmake ..
make
# ./suspmv <path to .mtx> <iterations>
./suspmv test/bcsstk01/bcsstk01.mtx 2
# iterations=0 will save the compute unit data to a hex file to be used in simulation
./suspmv test/bcsstk01/bcsstk01.mtx 0
```
