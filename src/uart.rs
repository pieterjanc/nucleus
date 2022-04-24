use core::fmt;

pub struct Uart {}

impl fmt::Write for Uart {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for c in s.chars() {
            unsafe {
                core::ptr::write_volatile(0x3f201000 as *mut u8, c as u8);
            }
        }

        Ok(())
    }
}
