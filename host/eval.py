import os

order = ['human_gene1', 'human_gene2', 'nd6k', 'TSOPF_RS_b2052_c1', 'thread', 'TSOPF_FS_b300_c1', 'TSOPF_FS_b300', 'TSOPF_RS_b678_c1', 'sme3Db', 'smt', 'nd3k', 'Trec14', 'heart1', 'c8_mat11', 'exdata_1', 'TSC_OPF_1047', 'appu', 'crystk03', 'nemeth26', 'nemeth23', 'nemeth24', 'raefsky3', 'heart3', 'heart2', 'raefsky4', 'msc10848', 'nemeth21', 'msc23052', 'bcsstk36', 'gyro_k', 'olafu', 'nemeth20', 'cbuckle', 'Trec13', 'raefsky1', 'psmigr_3', 'psmigr_1', 'psmigr_2', 'gyro', 'nemeth10', 'crystk01', 's2rmq4m1', 'bcsstk28', 's3rmt3m3', 't2d_q9', 'bcsstk24', 'ted_B', 'bodyy6', 'bodyy4', 'bcsstk15', 'ex9', 'Goodwin_017', 'epb1', 'dw8192', 'dendrimer', 'Goodwin_013', 'nasa1824', 'plbuckle', 'tomography']
gflops = [93.69, 98.12, 80.13, 51.12, 56.91, 43.74, 43.74, 62.56, 36.68, 63.70, 83.82, 78.10, 96.88, 90.09, 86.42, 
          77.40, 47.44, 33.00, 72.75, 72.60, 72.56, 34.58, 90.40, 90.76, 39.20, 51.36, 66.01, 25.46, 25.33, 37.97, 
          44.19, 60.78, 37.89, 58.97, 67.28, 62.76, 62.84, 62.64, 18.98, 37.02, 41.08, 38.30, 36.44, 31.69, 16.13, 
          30.42, 13.79, 04.64, 05.04, 24.05, 22.97, 22.03, 04.97, 10.80, 24.61, 17.24, 13.69, 12.25, 13.26, ]
table = dict()

with open('bench_hihispmv.txt', 'r') as file, open('bench_hihispmv.csv', 'w') as csv:
    valid = False
    cycles = 0
    csv.write(f'mtx; width; height; nnz; density; cycles; time; 300MHz GFLOPS; 450MHz GFLOPS; HiHiSpMV;\n')
    for line in file:
        if line.startswith('## Test'):
            mtx = line.split(' ')[-1][0:-1]
            valid = True
        if line.startswith('Matrix'):
            width = int(line.split(' ')[1][0:-1])
            height = int(line.split(' ')[3][0:-1])
            nnz = int(line.split(' ')[5][0:-2])
        if line.startswith('SUSpMV:'):
            time = (int(line.split(' ')[1][0:-3])) / 1000000
        if line.startswith('Cycles:'):
            cycles += int(line.split(' ')[1])
        if line.startswith('Endtest'):
            cycles /= 5
            time = cycles / 300000000
            table[mtx] = f'{mtx}; {width}; {height}; {nnz}; {nnz/(width*height)}; {cycles}; {time}; {int(2*nnz/time/100000000)/10}; {int(450/300*2*nnz/time/100000000)/10}; {gflops[order.index(mtx)]};'
            cycles = 0

    for mtx in order:
        csv.write(table[mtx]+'\n')


order = ['TSOPF_RS_b2383', 'crystk03', 'nd6k', 'crankseg_2', 'ford2', 'thread', 'PFlow_742', 'Si41Ge41H72', 'mouse_gene', 'soc-Pokec', 
         'c-52', 'language', 'analytics', 'nxp1', 'poli_large', 'lowThrust_7', 'hangGlider_3', 'boyd2', 'trans5', 'ASIC_680k']
gflops = [50.75, 45.51, 79.05, 47.45, 21.54, 45.69, 39.06, 39.66, 43.17, 23.86,
          22.27, 16.17, 14.29, 22.05, 12.38, 27.73, 24.63, 15.51, 19.17, 18.54]
table = dict()

with open('bench_hispmv.txt', 'r') as file, open('bench_hispmv.csv', 'w') as csv:
    valid = False
    cycles = 0
    csv.write(f'mtx; width; height; nnz; density; cycles; time; 300MHz GFLOPS; 450MHz GFLOPS; HiSpMV;\n')
    for line in file:
        if line.startswith('## Test'):
            if valid:
                cycles /= 5
                time = cycles / 300000000
                table[mtx] = f'{mtx}; {width}; {height}; {nnz}; {nnz/(width*height)}; {cycles}; {time}; {int(2*nnz/time/100000000)/10}; {int(450/300*2*nnz/time/100000000)/10}; {gflops[order.index(mtx)]};'
                cycles = 0
            mtx = line.split(' ')[-1][0:-1]
            valid = True
        if line.startswith('Matrix'):
            width = int(line.split(' ')[1][0:-1])
            height = int(line.split(' ')[3][0:-1])
            nnz = int(line.split(' ')[5][0:-2])
        if line.startswith('SUSpMV:'):
            time = (int(line.split(' ')[1][0:-3])) / 1000000
        if line.startswith('Cycles:'):
            cycles += int(line.split(' ')[1])
    cycles /= 5
    time = cycles / 300000000
    table[mtx] = f'{mtx}; {width}; {height}; {nnz}; {nnz/(width*height)}; {cycles}; {time};  {int(2*nnz/time/100000000)/10}; {int(450/300*2*nnz/time/100000000)/10}; {gflops[order.index(mtx)]};'

    for mtx in order:
        csv.write(table[mtx]+'\n')
