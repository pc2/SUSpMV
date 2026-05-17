# Host Code

The host code for SuSpMV uses a sparse matrix in .mtx format as input, converts it to the format used by SuSpMV and runs the multiplication with a few test vectors on the desired platform.
Sample .mtx files are available at https://sparse.tamu.edu/ .

Download by using:

```sh
# setup
python3 -m venv venv
source venv/bin/activate
pip install ssgetpy
# download
python3 download.py
```

## Run single

```sh
mkdir build
cd build
cmake ..
make
# ./suspmv <path to .mtx> <iterations>
./suspmv test/ash85/ash85.mtx 2
```
