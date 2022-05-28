.macro z_arm64_enter_exc handler
        // ARMv8 Programmer's Guide section 10.5

        sub	    sp, sp, #16 * 11

        stp     x0, x1, [sp, #16 * 0]
        stp     x2, x3, [sp, #16 * 1]
        stp	    x4, x5, [sp, #16 * 2]
        stp	    x6, x7, [sp, #16 * 3]
        stp	    x8, x9, [sp, #16 * 4]
        stp	    x10, x11, [sp, #16 * 5]
        stp	    x12, x13, [sp, #16 * 6]
        stp	    x14, x15, [sp, #16 * 7]
        stp	    x16, x17, [sp, #16 * 8]
        stp	    x18, lr, [sp, #16 * 9]
        // x19 -> x29 are callee-saved registers, or at least with extern "C"

        mrs	    x0, spsr_el1   // only needed for nested interrupts
        mrs	    x1, elr_el1
        stp	    x0, x1, [sp, #16 * 10]

        bl      \handler

        ldp	    x0, x1, [sp, #16 * 10]
        msr	    spsr_el1, x0
        msr	    elr_el1, x1

        ldp	    x0, x1, [sp, #16 * 0]
        ldp	    x2, x3, [sp, #16 * 1]
        ldp	    x4, x5, [sp, #16 * 2]
        ldp	    x6, x7, [sp, #16 * 3]
        ldp	    x8, x9, [sp, #16 * 4]
        ldp	    x10, x11, [sp, #16 * 5]
        ldp	    x12, x13, [sp, #16 * 6]
        ldp	    x14, x15, [sp, #16 * 7]
        ldp	    x16, x17, [sp, #16 * 8]
        ldp	    x18, lr, [sp, #16 * 9]

        add	    sp, sp, #16 * 11
        eret
.endm

.global _vector_table
_vector_table:
        .align 11 // align 2K

        // Current EL with SP0
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler

        // Current EL with SPx
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler

        // Lower EL using AArch64
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler
        .align 7
        z_arm64_enter_exc exception_handler

        // Lower EL using AArch32
        .align 7
        b   .
        .align 7
        b   .
        .align 7
        b   .
        .align 7
        b   .
