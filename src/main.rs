#![no_main]
#![no_std]

use core::panic::PanicInfo;

mod uart;
mod console;

core::arch::global_asm!(include_str!("boot.s"));

#[no_mangle]
fn kernel_init() -> ! {
    panic!("Hello world!")
}

#[panic_handler]
fn kernel_panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
