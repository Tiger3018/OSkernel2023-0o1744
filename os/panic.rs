use core::panic::PanicInfo;
use crate::arch::riscv_sbi::shutdown::shutdown;

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
    shutdown();
    // loop {};
}