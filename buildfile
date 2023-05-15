c.std = c17
cxx.std = c++17

config.c = riscv64-linux-gnu-gcc-10
config.cxx = riscv64-linux-gnu-g++-10
cc.coptions += -nostdlib

config.rust = env RUSTC_BOOTSTRAP=1 rustc
config.rust += --target=riscv64gc-unknown-none-elf --edition 2021
config.rust += -Clink-arg=-Tqemu.ld

using c
using cxx
using rust

[rule_hint=rust] exe{hello}: rs{hello more}