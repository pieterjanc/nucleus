#![no_main]
#![no_std]

use core::panic::PanicInfo;

core::arch::global_asm!(include_str!("boot.s"));

#[no_mangle]
fn kernel_init() -> ! {
    panic!()
}

#[panic_handler]
fn kernel_panic(_info: &PanicInfo) -> ! {
    loop {}
}
