import os
import sys

order = ['TSOPF_RS_b2383', 'crystk03', 'nd6k', 'crankseg_2', 'ford2', 'thread', 'PFlow_742', 'Si41Ge41H72', 'mouse_gene', 'soc-Pokec', 
        'c-52', 'language', 'analytics', 'nxp1', 'poli_large', 'lowThrust_7', 'hangGlider_3', 'boyd2', 'trans5', 'ASIC_680k']
hispmv = [50.75, 45.51, 79.05, 47.45, 21.54, 45.69, 39.06, 39.66, 43.17, 23.86,
        22.27, 16.17, 14.29, 22.05, 12.38, 27.73, 24.63, 15.51, 19.17, 18.54]

order = ['human_gene1', 'human_gene2', 'nd6k', 'TSOPF_RS_b2052_c1', 'thread', 'TSOPF_FS_b300_c1', 'TSOPF_FS_b300', 'TSOPF_RS_b678_c1', 'sme3Db', 'smt', 'nd3k', 'Trec14', 'heart1', 'c8_mat11', 'exdata_1', 'TSC_OPF_1047', 'appu', 'crystk03', 'nemeth26', 'nemeth23', 'nemeth24', 'raefsky3', 'heart3', 'heart2', 'raefsky4', 'msc10848', 'nemeth21', 'msc23052', 'bcsstk36', 'gyro_k', 'olafu', 'nemeth20', 'cbuckle', 'Trec13', 'raefsky1', 'psmigr_3', 'psmigr_1', 'psmigr_2', 'gyro', 'nemeth10', 'crystk01', 's2rmq4m1', 'bcsstk28', 's3rmt3m3', 't2d_q9', 'bcsstk24', 'ted_B', 'bodyy6', 'bodyy4', 'bcsstk15', 'ex9', 'Goodwin_017', 'epb1', 'dw8192', 'dendrimer', 'Goodwin_013', 'nasa1824', 'plbuckle', 'tomography']
hihispmv = [93.69, 98.12, 80.13, 51.12, 56.91, 43.74, 43.74, 62.56, 36.68, 63.70, 83.82, 78.10, 96.88, 90.09, 86.42, 
        77.40, 47.44, 33.00, 72.75, 72.60, 72.56, 34.58, 90.40, 90.76, 39.20, 51.36, 66.01, 25.46, 25.33, 37.97, 
        44.19, 60.78, 37.89, 58.97, 67.28, 62.76, 62.84, 62.64, 18.98, 37.02, 41.08, 38.30, 36.44, 31.69, 16.13, 
        30.42, 13.79, 04.64, 05.04, 24.05, 22.97, 22.03, 04.97, 10.80, 24.61, 17.24, 13.69, 12.25, 13.26, ]
table = dict()
frequency = 400

class Entry:

    def __init__(self, name):
        self.name = name
        self.width = 1
        self.height = 1
        self.nnz = 1
        self.cycles = 0
        self.time = 0
        self.gflops = 0
        self.blocks = 0
        self.float5 = 0
        self.float6 = 0
        self.float6lastfail = 0
        self.bank_conflicts = 0
        self.bank_conflict_zeroes = 0
        self.y_conflicts = 0
        self.y_conflict_zeroes = 0
        self.trampolin_zeroes = 0
        self.endoftile_zeroes = 0
        self.dummyzeroes = 0

    def set(self, width, height, nnz, cycles, time, gflops, blocks, float5, float6, float6lastfail,
            bank_conflicts, bank_conflict_zeroes, y_conflicts, y_conflict_zeroes, trampolin_zeroes, endoftile_zeroes, dummyzeroes):
        self.width = width
        self.height = height
        self.nnz = nnz
        self.cycles = cycles
        self.time = time
        self.gflops = gflops
        self.blocks = blocks
        self.float5 = float5
        self.float6 = float6
        self.float6lastfail = float6lastfail
        self.bank_conflicts = bank_conflicts
        self.bank_conflict_zeroes = bank_conflict_zeroes
        self.y_conflicts = y_conflicts
        self.y_conflict_zeroes = y_conflict_zeroes
        self.trampolin_zeroes = trampolin_zeroes
        self.endoftile_zeroes = endoftile_zeroes
        self.dummyzeroes = dummyzeroes

    @property
    def values(self):
        return self.float5 * 5 + self.float6 * 6

def read(path):
    with open(path, 'r') as file, open('bench_hihispmv.csv', 'w') as csv:
        entries = list()
        for mtx in order:
            entries.append(Entry(mtx))

        valid = False
        cycles = list()
        float6lastfail_list = list()
        dummyzeroes_list = list()
        gflops_percent_list = list()
        gflops_dict = dict()
        csv.write(f'mtx; width; height; nnz; density; cycles; time; {frequency}MHz GFLOPS; HiHiSpMV;\n')
        for line in file:
            if line.startswith('## Test'):
                mtx = line.split(' ')[-1][0:-1]
                idx = order.index(mtx)
                valid = True
            if line.startswith('Matrix'):
                width = int(line.split(' ')[1][0:-1])
                height = int(line.split(' ')[3][0:-1])
                nnz = int(line.split(' ')[5][0:-2])
            if line.startswith('SUSpMV:'):
                time = (int(line.split(' ')[1][0:-3])) / 1000000
            if line.startswith('Cycles:'):
                cycles.append(int(line.split(' ')[1]))
            if line.startswith('blocks:'):
                blocks = int(line.split(' ')[1])
                float5 = int(line.split(' ')[3])
                float6 = int(line.split(' ')[5])
                float6lastfail = int(line.split(' ')[7])
                bank_conflicts = int(line.split(' ')[9])
                bank_conflict_zeroes = int(line.split(' ')[11])
                y_conflicts = int(line.split(' ')[13])
                y_conflict_zeroes = int(line.split(' ')[15])
                trampolin_zeroes = int(line.split(' ')[17])
                endoftile_zeroes = int(line.split(' ')[19])
                dummyzeroes = int(line.split(' ')[21])
                float6lastfail_list.append(float6lastfail / max(1, float6 + float6lastfail))
                dummyzeroes_list.append(dummyzeroes / (nnz + dummyzeroes))
            if line.startswith('Endtest'):
                if not cycles:
                    cycles = [1]
                cycles = sum(cycles) / len(cycles)
                time = cycles / frequency / 1000000
                suspmv_gflops = int(2*nnz/time/100000000)/10
                entries[idx].set(width, height, nnz, cycles, time, suspmv_gflops, blocks, float5, float6, float6lastfail,
                                bank_conflicts, bank_conflict_zeroes, y_conflicts, y_conflict_zeroes, trampolin_zeroes, endoftile_zeroes, dummyzeroes)
                cycles = list()
    return entries

def print_latex(gflops):
    text = ' '.join([f"({i+1}, {gflops[i]:.3f})" for i in range(len(gflops))])
    print()
    print(text)
    print()

entries = read('bench_hihispmv.txt')

ratio = [e.bank_conflicts / e.nnz for e in entries]
print(f"bank_conflicts: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.y_conflicts / e.nnz for e in entries]
print(f"y_conflicts: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")

ratio = [e.bank_conflict_zeroes / e.values for e in entries]
print(f"bank_conflict_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.y_conflict_zeroes / e.values for e in entries]
print(f"y_conflict_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.trampolin_zeroes / e.values for e in entries]
print(f"trampolin_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.endoftile_zeroes / e.values for e in entries]
print(f"endoftile_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.dummyzeroes / e.values for e in entries]
print(f"dummyzeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
