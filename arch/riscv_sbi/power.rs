use core::panicking::unreachable_display;
use crate::arch::riscv_sbi::*;

/// Power Operation
pub enum Operation {
    Reboot,
    Shutdown,
}

/// Perform board specific power operations
/// See <https://docs.rs/rustsbi/latest/rustsbi/#discrete-rustsbi-package-on-bare-metal-risc-v-hardware>
///
/// The function here provides a stub to example power operations.
/// Actual board developers should provide with more practical communications
/// to external chips on power operation.
pub fn finalize(op: Operation) -> ! {
    match op {
        Operation::Shutdown => {
            let ret = sbi_call(SBI_SHUTDOWN, 0, 0, 0, 0);
            crate::dprintln!("shutdown ret code: {}", ret);
            unreachable_display(&"sbi_call should call shutdown, but this unreachable code executed!");
        }
        Operation::Reboot => {
            crate::startup_os();
        }
    }
}