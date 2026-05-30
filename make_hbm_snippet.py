#!/usr/bin/env python3

import sys

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <count>", file=sys.stderr)
    sys.exit(1)

count = int(sys.argv[1])

with open("suspmv_io_hbm_snippet.sus_snippet", "r") as f:
    template = f.read()

for idx in range(count):
    print(template.replace("{HBM_IDX}", f"{idx:02d}"), end="")
