#![no_main]
#![no_std]
#![feature(lang_items)] // for what
#![feature(panic_info_message)]
// #![warn(missing_docs)]


use os::printk::{
    print,
    println,
    debug_print as dprint,
    debug_println as dprintln,
};
mod os;
mod arch;

// use crate::task::{Signals, SignalStack};
// use riscv::register::sstatus::{self, set_spp, Sstatus, SPP};

/// TODO
/// 
use core::arch::global_asm;
global_asm!(include_str!("./arch/riscv_sbi/entry.asm"));

#[no_mangle]
pub fn __startup_os() -> ! {
    // clear_bss();
    println!("Hello, world!");
    panic!("Shutdown machine!");
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}
