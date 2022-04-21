SECTIONS
{
    . = 0x80000; /* load addr */
    .text : { *(.text.boot) }

   /*/DISCARD/ : { *(.comment) *(.gnu*) *(.note*) *(.eh_frame*) }*/
}
