# CSR Layout

The CSR (Control & Status Registers) of the SUSpMV unit have the following layout.

Address         | Bits | Function
----------------|------|----------
0x00            |  1   | start bit
0x20            | 64   | x_vec address
0x30            | 64   | y_vec address
0x40            | 64   | x_tiles per row
0x50            | 64   | y_repeats
0x60 + 0x20 * n | 64   | hbm[n] base address
0x70 + 0x20 * n | 64   | hbm[n] element count

