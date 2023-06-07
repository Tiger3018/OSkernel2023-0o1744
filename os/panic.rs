use core::panic::PanicInfo;
#[cfg(not(feature = "user_lib"))]
use crate::arch::riscv_sbi::power::*;

#[cfg(not(feature = "user_lib"))]
fn panic_print_sys_info() {
    
}

#[panic_handler]
fn panic(_panic: &PanicInfo<'_>) -> ! {
    if let Some(location) = _panic.location() {
        crate::println!(
            "Panicked at {}:{} {}",
            location.file(),
            location.line(),
            _panic.message().unwrap()
        );
    } else {
        crate::println!("Panicked: {}", _panic.message().unwrap());
    }
    #[cfg(not(feature = "user_lib"))]
    panic_print_sys_info();
    #[cfg(not(feature = "user_lib"))]
    finalize(Operation::Shutdown);
    #[cfg(any(feature = "user_lib"))]
    loop {};
}