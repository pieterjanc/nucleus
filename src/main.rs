#![no_main]
#![no_std]

use core::panic::PanicInfo;

mod arch;
mod uart;
mod console;

#[no_mangle]
fn kernel_init() -> ! {
    panic!("Hello world!")
}

#[panic_handler]
fn kernel_panic(info: &PanicInfo) -> ! {
    println!("{}", info);
    loop {}
}
