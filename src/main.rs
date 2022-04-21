#![no_main]
#![no_std]

use core::panic::PanicInfo;

core::arch::global_asm!(include_str!("boot.s"));

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
