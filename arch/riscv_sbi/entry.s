# Ref <https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md>
# Thanks to <https://gitlab.eduxiji.net/scPointer/maturin/-/blob/master/kernel/src/arch/riscv/mod.rs>
# Assembly script that works with qemu.ld
# No prefix mangle in this file, to distinguish it with rust or cpp code. No preprocessor directives.
    .section .text.entry
    .globl _start
_start:
    # li x1, 100
    call set_stack
    call startup_os
    li   t1, 0xffffffff00000000
    add  t0, t0, t1
    add  sp, sp, t1
    jr   t0
set_stack:
    add  t0, a0, 1
    slli t0, t0, 18
    la   sp, boot_stack_top
    add  sp, sp, t0
    ret
set_boot_pt:
    la   t0, boot_page_table_sv39
    srli t0, t0, 12
    li   t1, 8 << 60
    or   t0, t0, t1
    csrw satp, t0
    ret

    .section .data
    .align 12
boot_page_table_sv39:
    .quad 0
    .quad 0
    # 0x00000000_80000000 -> 0x80000000 (1G, VRWXAD)
    .quad (0x80000 << 10) | 0xcf
    # removed
    #.quad 0
    .zero 8 * 507
    # 0xffffffff_80000000 -> 0xffffffff_80000000 (1G, VRWXAD)
    .quad (0x80000 << 10) | 0xcf
    .quad 0

    .section .bss.stack
    # .globl boot_stack
boot_stack:
    .space 4096 * 16
    # .globl boot_stack_top
boot_stack_top: