mod pages;
mod vmm;

use crate::config::{KERNEL_HEAP_SIZE, PAGE_SIZE};

/// Stable slice.fill() as of Rust 1.50.0, released on 2021-02-11
/// See <https://github.com/rcore-os/rCore-Tutorial-v3/blob/main/os/src/main.rs>
fn fill_bss() {
    extern "C" {
        fn sbss();
        fn ebss();
    }
    unsafe {
        core::slice::from_raw_parts_mut(sbss as usize as *mut u8, ebss as usize - sbss as usize)
            .fill(0);
    }
}

/// fill_bss() and init_pages(), init_vmm()
pub fn init() {
    fill_bss();
    pages::init_pages();
    vmm::init_vmm();
}
