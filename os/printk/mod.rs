use crate::arch::riscv_sbi::console_putchar;
use core::fmt::{self, Write};

struct Stdout;

impl Write for Stdout {
    /// In order to 
    /// See <https://github.com/rcore-os/rCore-Tutorial-Book-v3/issues/100#issuecomment-1127614678>
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for b in s.bytes() {
            console_putchar(b as usize);
        }
        Ok(())
    }
}
pub fn printk(args: fmt::Arguments) {
    Stdout.write_fmt(args).unwrap();
}

//#[macro_export]
macro_rules! print {
    ($fmt: literal $(, $($arg: tt)+)?) => {
        $crate::os::printk::printk(format_args!($fmt $(, $($arg)+)?));
    }
}

//#[macro_export]
macro_rules! println {
    ($fmt: literal $(, $($arg: tt)+)?) => {
        $crate::os::printk::printk(format_args!(concat!($fmt, "\n") $(, $($arg)+)?));
    }
}

// #[macro_export]
#[cfg(debug_assertions)]
macro_rules! debug_print {
    ($fmt: literal $(, $($arg: tt)+)?) => {
        $crate::os::printk::print!("[D]");
        $crate::os::printk::print!($fmt $(, $($arg)+)?);
    }
}

// #[macro_export]
#[cfg(debug_assertions)]
macro_rules! debug_println {
    ($fmt: literal $(, $($arg: tt)+)?) => {
        $crate::os::printk::print!("[D]");
        $crate::os::printk::println!($fmt $(, $($arg)+)?);
    }
}

#[doc(inline)]
pub(crate) use {
    print,
    println,
    debug_print,
    debug_println,
};