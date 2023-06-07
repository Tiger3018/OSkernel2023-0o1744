#![no_main]
#![no_std]
#![feature(lang_items)] // for what
#![feature(core_panic)]
#![feature(panic_info_message)]
//#![feature(rustc_attrs)] // #[rustc_builtin_macro]
// #![warn(missing_docs)]

extern crate bitflags;

mod arch;
mod config;
mod os;

use os::printk::{debug_print as dprint, debug_println as dprintln, print, println};

// use arch::riscv_sbi::entry;
#[no_mangle]
pub fn startup_os() -> ! {
    crate::println!("= S Mode Kernel ({}) =", file!());
    os::mm::init();
    crate::println!("Hello, world!");
    crate::print!("{:?}\n", crate::arch::riscv_sbi::get_spec_version());
    panic!("Shutdown machine!");
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}
