use core::panicking::unreachable_display;
use crate::arch::riscv_sbi::*;

pub fn shutdown() -> ! {
    let ret = sbi_call(SBI_SHUTDOWN, 0, 0, 0, 0);
    crate::dprintln!("shutdown ret code: {}", ret);
    unreachable_display(&"sbi_call should call shutdown, but this unreachable code executed!");
}