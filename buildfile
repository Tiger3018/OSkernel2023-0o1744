c.std = c17
cxx.std = c++17

config.c = riscv64-linux-gnu-gcc
config.cxx = riscv64-linux-gnu-g++
cc.coptions += -nostdlib

#config.import.libbuild2_rust = /root/bpkg-ws
config.rust = env RUSTC_BOOTSTRAP=1 rustc
config.rust += --target=riscv64gc-unknown-none-elf --edition 2021
config.rust += -Clink-arg=-T./arch/qemu.ld

using c
using cxx
using rust

#lib{os}: rs{os/panic.rs}
[rule_hint=rust] exe{kernel_qemu}: rs{hello}