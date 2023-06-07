use crate::arch::riscv_1_11::mm;

/// init_vmm
pub fn init_vmm() {
    test_vmm();
    ()
}

// #[test]
/// may be after init_vmm
/// See <https://gitlab.eduxiji.net/scPointer/maturin/master/~/kernel/src/main.rs>
pub fn test_vmm() {
    extern "C" {
        fn stext();
        fn etext();
        fn sdata();
        fn edata();
        fn srodata();
        fn erodata();
        fn sbss();
        fn ebss();
    }
    crate::println!(
        "\
stext = {:x}
etext = {:x}
sdata = {:x}
edata = {:x}
srodata = {:x}
erodata = {:x}
sbss = {:x}
ebss = {:x}
",
        stext as usize,
        etext as usize,
        sdata as usize,
        edata as usize,
        srodata as usize,
        erodata as usize,
        sbss as usize,
        ebss as usize,
    );
}