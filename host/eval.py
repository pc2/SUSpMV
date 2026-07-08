import os
import sys

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
    entries = list()
    for mtx in order:
        entries.append(Entry(mtx))

    valid = False
    cycles = list()
    float6lastfail_list = list()
    dummyzeroes_list = list()
    gflops_percent_list = list()
    gflops_dict = dict()
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
            split = line.split(' ')
            blocks = int(split[1])
            float5 = int(split[3])
            float6 = int(split[5])
            float6lastfail = int(split[7])
            bank_conflicts = 0                           # = int(split[9])
            bank_conflict_zeroes = 0                           # = int(split[11])
            y_conflicts = 0                           # = int(split[13])
            y_conflict_zeroes = 0                           # = int(split[15])
            trampolin_zeroes = 0                           # = int(split[17])
            endoftile_zeroes = 0                           # = int(split[19])
            dummyzeroes = 0                           # = int(split[21])
            float6lastfail_list.append(float6lastfail / max(1, float6 + float6lastfail))
            dummyzeroes_list.append(dummyzeroes / (nnz + dummyzeroes))
        if line.startswith('Endtest'):
            cycles = sum(cycles) / len(cycles)
            time = cycles / frequency / 1000000
            suspmv_gflops = 2*nnz/time/1000000000
            entries[idx].set(width, height, nnz, cycles, time, suspmv_gflops, blocks, float5, float6, float6lastfail,
                            bank_conflicts, bank_conflict_zeroes, y_conflicts, y_conflict_zeroes, trampolin_zeroes, endoftile_zeroes, dummyzeroes)
            cycles = list()
    return entries

def print_latex(values):
    text = ' '.join([f"({i+1}, {values[i]:.3f})" for i in range(len(values))])
    print()
    print(text)
    print()

def print_latex_table(order, hihispmv, noshuffle, shuffle):
    text = ''
    for i in range(60//4):
        for j in [i, i+15, i+30, i+45]:
            if j >= len(order):
                text += '& & & &'
            else:
                vals = [hihispmv[j], noshuffle[j], shuffle[j]]
                best = max(vals)
                vals = [v if v != best else '\cellcolor{green!25}' + str(v) for v in vals]
                text += f'{j+1} & {order[j]} & {vals[0]} & {vals[1]} & {vals[2]}'
            text += ' &\n' if j != i+45 else ' \\\\\n\n'
    print()
    print(text)
    print()

v400 = read('full.txt')
v400s = read('shuffle.txt')

full = v400
nofloat6 = read('nofloat6.txt')
acc1 = read('acc1.txt')

cu1 = read('cu1.txt')
cu2 = read('cu2.txt')
cu4 = read('cu4.txt')
cu8 = read('cu8.txt')
cu16 = read('cu16.txt')
cu32 = v400

print()
print('#######')
print('# main:')
print_latex_table(order, hihispmv, [e.gflops for e in v400], [e.gflops for e in v400s])

ratio = [e.blocks * 32 / e.time / 1000000000 for e in v400s]
print(f"block  bandwidth shuffle   : {sum(ratio)/len(ratio):.3f} GB/s {max(ratio):.3f} GB/s")
ratio = [e.nnz * 4 / e.time / 1000000000 for e in v400s]
print(f"matrix bandwidth shuffle   : {sum(ratio)/len(ratio):.3f} GB/s {max(ratio):.3f} GB/s")

ratio = [e.blocks * 32 / e.time / 1000000000 for e in v400]
print(f"block  bandwidth no-shuffle: {sum(ratio)/len(ratio):.3f} GB/s {max(ratio):.3f} GB/s")
ratio = [e.nnz * 4 / e.time / 1000000000 for e in v400]
print(f"matrix bandwidth no-shuffle: {sum(ratio)/len(ratio):.3f} GB/s {max(ratio):.3f} GB/s")

print()
print('##########')
print('# scaling:')
print_latex([e.gflops / b.gflops for b, e in zip(cu1, cu2)])
print_latex([e.gflops / b.gflops for b, e in zip(cu1, cu4)])
print_latex([e.gflops / b.gflops for b, e in zip(cu1, cu8)])
print_latex([e.gflops / b.gflops for b, e in zip(cu1, cu16)])
print_latex([e.gflops / b.gflops for b, e in zip(cu1, cu32)])

print()
print('#########')
print('# float6:')
print_latex([e.gflops / b.gflops for b, e in zip(nofloat6, full)])

blockratio = [e.blocks / b.blocks for b, e in zip(nofloat6, full)]
print(f"blockratio: {1-sum(blockratio)/len(blockratio)} {max(blockratio)}")
gflopsratio = [e.gflops / b.gflops for b, e in zip(nofloat6, full)]
print(f"gflopsratio: {sum(gflopsratio)/len(gflopsratio)} {max(gflopsratio)}")
print('')
ratio = [e.float6lastfail / (e.float6 + e.float6lastfail) for e in full]
print(f'float6lastfail: {sum(ratio)/len(ratio)} {max(ratio)}')
ratio = [e.bank_conflicts / e.nnz for e in v400]
print(f"bank_conflicts: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.y_conflicts / e.nnz for e in v400]
print(f"y_conflicts: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.bank_conflict_zeroes / e.values for e in v400]
print(f"bank_conflict_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.y_conflict_zeroes / e.values for e in v400]
print(f"y_conflict_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.trampolin_zeroes / e.values for e in v400]
print(f"trampolin_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.endoftile_zeroes / e.values for e in v400]
print(f"endoftile_zeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")
ratio = [e.dummyzeroes / e.values for e in v400]
print(f"dummyzeroes: {sum(ratio)/len(ratio):.4f} {max(ratio):.4f}")

print()
print('#######')
print('# acc6:')
print_latex([e.gflops / b.gflops for b, e in zip(acc1, full)])
blockratio = [e.blocks / b.blocks for b, e in zip(acc1, full)]
print(f"blockratio: {1-sum(blockratio)/len(blockratio)} {max(blockratio)}")
gflopsratio = [e.gflops / b.gflops for b, e in zip(acc1, full)]
print(f"gflopsratio: {sum(gflopsratio)/len(gflopsratio)} {max(gflopsratio)}")
