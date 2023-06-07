#![allow(unused)]

use core::arch::asm;
#[cfg(not(feature = "user_lib"))]
pub mod power;
#[cfg(not(feature = "user_lib"))]
pub mod entry;

// legacy extensions: ignore fid
const SBI_SET_TIMER: usize = 0;
const SBI_CONSOLE_PUTCHAR: usize = 1;
const SBI_CONSOLE_GETCHAR: usize = 2;
const SBI_CLEAR_IPI: usize = 3;
const SBI_SEND_IPI: usize = 4;
const SBI_REMOTE_FENCE_I: usize = 5;
const SBI_REMOTE_SFENCE_VMA: usize = 6;
const SBI_REMOTE_SFENCE_VMA_ASID: usize = 7;

//EID = 0x10
const SBI_BASE_EXTENSION_EID: usize = 10;
const SBI_GET_SPEC_VERSION_FID: usize = 10;

// system reset extension
const SRST_EXTENSION: usize = 0x53525354;
// const SBI_SHUTDOWN: usize = 0;
const SBI_SHUTDOWN: usize = 8;

/// from crate semver
#[derive(Debug)]
pub struct Version {
    pub major:u64,
    pub minor:u64,
    pub patch:u64,
}

pub fn console_putchar(c: usize) {
    sbi_call(SBI_CONSOLE_PUTCHAR, 0, c, 0, 0);
}

#[cfg(not(feature = "user_lib"))]
pub fn get_spec_version() -> Version {
    let version_raw:usize = sbi_call(SBI_BASE_EXTENSION_EID, SBI_GET_SPEC_VERSION_FID, 0, 0, 0);
    Version { major: (0), minor: (0), patch: (0) }
}

/// See <https://github.com/rcore-os/rCore-Tutorial-Book-v3/issues/100#issuecomment-1475877352>
#[inline(always)]
fn sbi_call(eid: usize, fid: usize, arg0: usize, arg1: usize, arg2: usize) -> usize {
    let mut ret;
    unsafe {
        asm!(
            "ecall",
            inlateout("x10") arg0 => ret,
            in("x11") arg1,
            in("x12") arg2,
            in("x16") fid,
            in("x17") eid,
        );
    }
    ret
}