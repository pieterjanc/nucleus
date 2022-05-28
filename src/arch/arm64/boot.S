.section ".text.boot"

.global _start

_start:
        // check cpu number and only start cpu 0
        mrs     x0, mpidr_el1
        and     x0, x0, #3
        cbz     x0, _el3_entry
        // busy loop for other cores
0:      wfi                         // wfe = nop in qemu :(
        b       0b

_el3_entry:
        // NEON and floating point
        // disable trapping of accessing in EL3 and EL2
        msr     cptr_el3, xzr
        msr     cptr_el2, xzr
        // disable access trapping in EL1 and EL0
        mov     x1, #(0x3 << 20)    // FPEN disables trapping to EL1
        msr     cpacr_el1, x1
        isb

        // drop to EL2
        msr     sctlr_el2, xzr
        msr     hcr_el2, xzr

        mrs     x0, scr_el3
        orr     x0, x0, #(1<<10)    // RW EL2 execution state is aarch64.
        orr     x0, x0, #(1<<0)     // NS EL1 is non-secure world.
        msr     scr_el3, x0
        mov     x0, #0b01001        // DAIF=0000
        msr     spsr_el3, x0        // m[4:0]=01001 el2h must match scr_el3.rw

        adr     x0, _el2_entry
        msr     elr_el3, x0
        eret

_el2_entry:
        // drop to EL1
        msr     sctlr_el1, xzr

        mrs     x0, hcr_el2
        orr     x0, x0, #(1<<31)    // RW=1 EL1 execution state is aarch64.
        msr     hcr_el2, x0
        mov     x0, #0b00101        // DAIF=0000
        msr     spsr_el2, x0        // m[4:0]=00101 el1h must match hcr_el2.rw.

        adr     x0, _el1_entry
        msr     elr_el2, x0
        eret

_el1_entry:
        // setup stack pointer
        ldr     x0, =_start
        mov     sp, x0

        // setup vector table for handling exceptions
        ldr     x1, = _vector_table
        msr     vbar_el1, x1

        // clear BSS
        ldr     x0, =__bss_start
        ldr     w1, =__bss_size
3:      cbz     w1, 4f
        str     xzr, [x0], #8
        sub     w1, w1, #1
        cbnz    w1, 3b

        // jump to rust code
4:      bl      kernel_init
        b       .
