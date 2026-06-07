import subprocess
import os

iter = 0

subprocess.run(f'rm -r build && mkdir build && cd build && cmake .. && make', shell=True)

print('# HiHiSpMV')
text = ""
i = 0

for mtx in os.listdir('test/hihispmv'):
    print(f'{i}: {mtx}')
    i += 1
    path = os.path.join('test/hihispmv', mtx, f'{mtx}.mtx')
    text += f'\n## Test {mtx}\n'
    p = subprocess.Popen(f'build/suspmv {path} {iter}', shell=True, stdout=subprocess.PIPE)
    stdout, stderr = p.communicate()
    text += stdout.decode("utf-8")

with open('bench_hihispmv.txt', 'w') as file:
    file.write(text)

print('# HiSpMV')
text = ""
i = 0

for mtx in os.listdir('test/hispmv'):
    print(f'{i}: {mtx}')
    i += 1
    path = os.path.join('test/hispmv', mtx, f'{mtx}.mtx')
    text += f'\n## Test {mtx}\n'
    p = subprocess.Popen(f'build/suspmv {path} {iter}', shell=True, stdout=subprocess.PIPE)
    stdout, stderr = p.communicate()
    text += stdout.decode("utf-8")

with open('bench_hispmv.txt', 'w') as file:
    file.write(text)
