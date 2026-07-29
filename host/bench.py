import subprocess
import os
from time import sleep

matrix_path = 'data'

def bench(bench_path, shuffle, cus, acc, float6):
    # override settings
    with open('src/consts.h', 'r') as fa, open('src/main.cpp', 'r') as fb:
        lines_a = fa.readlines()
        lines_b = fb.readlines()

    lines_a[9] = f'const uint64_t COMPUTE_UNITS = {cus};\n'
    lines_a[14] = f'const bool ENABLE_FLOAT6 = {float6};\n'
    lines_a[15] = f'const uint64_t ACC_ROWS = {acc};\n'
    lines_b[65] = f'{"" if shuffle else "//"} m.shuffle_random();\n'

    with open('src/consts.h', 'w') as fa, open('src/main.cpp', 'w') as fb:
        fa.writelines(lines_a)
        fb.writelines(lines_b)

    # recompile
    iter = 10
    subprocess.run(f'rm -r build && mkdir build && cd build && cmake .. && make', shell=True)

    # run benchmarks
    print(f'# HiHiSpMV {bench_path}')
    text = ""
    i = 0

    for mtx in os.listdir(matrix_path):
        print(f'{i}: {mtx}')
        if cus != 32 and mtx == 'dw8192':
            # for some reason, this matrix breaks with the latest hardware version when not all 32 CUs are enabled
            continue
        i += 1
        path = os.path.join(matrix_path, mtx, f'{mtx}.mtx')
        text += f'\n## Test {mtx}\n'
        p = subprocess.Popen(f'build/suspmv {path} {iter}', shell=True, stdout=subprocess.PIPE)
        stdout, stderr = p.communicate()
        text += stdout.decode("utf-8")
        text += "\nEndtest\n"
        sleep(0.5)

    # save results
    print(f'write {bench_path}')
    with open(bench_path, 'w') as file:
        file.write(text)

bench('full.txt', False, 32, 6, 'true')
bench('shuffle.txt', 'true', 32, 6, 'true')
for i in range(4):
    bench(f'shuffle_{i}.txt', 'true', 32, 6, 'true')

bench('nofloat6.txt', False, 32, 6, 'false')
bench('acc1.txt', False, 32, 1, 'true')

bench('cu1.txt', False, 1, 6, 'true')
bench('cu2.txt', False, 2, 6, 'true')
bench('cu4.txt', False, 4, 6, 'true')
bench('cu8.txt', False, 8, 6, 'true')
bench('cu16.txt', False, 16, 6, 'true')
