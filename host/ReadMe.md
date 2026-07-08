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

## Run evaluation

1. Download the hihispmv matrices to `test/hihispmv/`.
    - `[human_gene1 human_gene2 nd6k TSOPF_RS_b2052_c1 thread TSOPF_FS_b300_c1 TSOPF_FS_b300 TSOPF_RS_b678_c1 sme3Db smt nd3k Trec14 heart1 c8_mat11 exdata_1 TSC_OPF_1047 appu crystk03 nemeth26 nemeth23 nemeth24 raefsky3 heart3 heart2 raefsky4 msc10848 nemeth21 msc23052 bcsstk36 gyro_k olafu nemeth20 cbuckle Trec13 raefsky1 psmigr_3 psmigr_1 psmigr_2 gyro nemeth10 crystk01 s2rmq4m1 bcsstk28 s3rmt3m3 t2d_q9 bcsstk24 ted_B bodyy6 bodyy4 bcsstk15 ex9 Goodwin_017 epb1 dw8192 dendrimer Goodwin_013 nasa1824 plbuckle tomography]`
2. run `python3 bench.py` with the following changes to the parameters found in `src/consts.h` and `m.shuffle_random()` in `src/main.cpp`.
Defaults are marked **bold**, only change one parameter and leave others at default value. Rename the resulting `bench_hihispmv.txt` accordingly.
    - COMPUTE_UNITS: [**32**, 16, 8, 4, 2, 1] (`full.txt`, `cu16.txt`, `cu8.txt`, `cu4.txt`, `cu2.txt`, `cu1.txt`)
    - ENABLE_FLOAT6: [**true**, false] (`full.txt`, `nofloat6.txt`)
    - ACC_ROWS: [**6**, 1] (`full.txt`, `acc1.txt`)
    - m.shuffle_random(): [**comment line out**, inlcude line] (`full.txt`, `shuffle.txt`)
3. run `python3 eval.py`. It will print the data content of the latex table and graphs as well as individual performance metric numbers.
