import subprocess
import os
from time import sleep

iter = 5
subprocess.run(f'rm -r build && mkdir build && cd build && cmake .. && make', shell=True)

##########
# HiHiSpMV
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
    text += "\nEndtest\n"
    sleep(0.5)

with open('bench_hihispmv.txt', 'w') as file:
    file.write(text)
