.section ".text.boot"

.global _start

_start:
        // check cpu number and only start cpu 0
        mrs        x0, mpidr_el1
        and        x0, x0, #3
        cbz        x0, _init
        // busy loop for other cores
0:      wfi // wfe = nop in qemu :(
        b          0b

_init:
        // setup stack pointer
        ldr        x0, =_start
        mov        sp, x0

        // clear BSS
        ldr        x0, =__bss_start
        ldr        w1, =__bss_size
3:      cbz        w1, 4f
        str        xzr, [x0], #8
        sub        w1, w1, #1
        cbnz       w1, 3b

        // jump to rust code
4:      bl         kernel_init
        b          0b
