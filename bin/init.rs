#![no_std]
#![no_main]
#![feature(panic_info_message)]

// #[path = "../hello.rs"]
// mod hello;
// extern crate bitflags;

#[path = "../os/mod.rs"]
mod os;
#[path = "../arch/mod.rs"]
mod arch;
use os::printk::{
    print,
    println,
    debug_print as dprint,
    debug_println as dprintln,
};

#[export_name = "_start"]
fn start() {
    crate::println!("init called");
    ()
}