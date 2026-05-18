# Host Code

The host code for SuSpMV uses a sparse matrix in .mtx format as input, converts it to the format used by SuSpMV and runs the multiplication with a few test vectors on the desired platform.
Sample .mtx files are available at https://sparse.tamu.edu/ .

Download by using:

```sh
# setup
python3 -m venv venv
source venv/bin/activate
pip install ssgetpy
# download all supported matrices
ssgetpy --format MM --data-type real --outdir test/
# download some matrices
ssgetpy --format MM --data-type real --outdir test/ --limit 1 --group HB --max-nnzs 1000
```

## Run single

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
