/// This export all const value.

/// 页表中每页的大小
pub const PAGE_SIZE: usize = 0x1000; // 4 KB
/// 即 log2(PAGE_SIZE)
pub const PAGE_SIZE_BITS: usize = 0xc; // 4 KB = 2^12
/// 内核栈大小
pub const KERNEL_STACK_SIZE: usize = 0x80_000; // 512 KB
/// 内核堆的大小
pub const KERNEL_HEAP_SIZE: usize = 0xc0_0000; // 12 MB

pub const TASK_SIZE: usize = 0xc000_0000;
pub const ELF_DYN_BASE: usize = TASK_SIZE / 3 * 2;
pub const USER_STACK_BASE: usize = TASK_SIZE - PAGE_SIZE;
pub const USER_STACK_SIZE: usize = PAGE_SIZE * 40;
pub const USER_HEAP_SIZE: usize = PAGE_SIZE * 20;
