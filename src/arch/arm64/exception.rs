use core::arch::asm;

use crate::println;

#[no_mangle]
extern "C" fn exception_handler() {
    let esr: u64;
    unsafe { asm!("mrs {}, esr_el1", out(reg) esr, options(nomem, nostack, preserves_flags)) };
    let elr: u64;
    unsafe { asm!("mrs {}, elr_el1", out(reg) elr, options(nomem, nostack, preserves_flags)) };
    let exception_class = (esr >> 26) & 0x3f;
    let exception_str = match exception_class {
        0b000000 => "Unknown reason",
        0b001101 => "Branch Target Exception",
        0b001110 => "Illegal Execution state",
        0b010101 => "SVC instruction execution in AArch64 state",
        0b100101 => "Data Abort taken without a change in Exception level",
        _ => "???",
    };
    let iss = esr & 0xffffff;

    println!("Caught exception: 0x{:x} ({})", exception_class, exception_str);
    println!("    PC  0x{:x}", elr);
    println!("    ISS 0x{:x}", iss);
    loop {}
}
