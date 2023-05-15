#![no_main]
#![no_std]
#![feature(lang_items)]

use core::panic::PanicInfo;

//fn main() {
    //println!("help");
    //0;
//}

use core::arch::global_asm;
global_asm!(include_str!("entry.asm"));

#[panic_handler]
fn panic(_panic: &PanicInfo<'_>) -> ! {
    loop {}
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}
