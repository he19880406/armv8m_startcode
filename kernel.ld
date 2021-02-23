/* Linker script to configure memory regions. */
MEMORY
{
   NS_CODE (rx)     : ORIGIN = 0x00000000, LENGTH = 512K
   S_CODE_BOOT (rx) : ORIGIN = 0x10000000, LENGTH = 512k
   NS_RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 512k
   S_RAM (rwx) : ORIGIN = 0x30000000, LENGTH = 512k
}

/* Entry Point */
ENTRY(Reset_Handler)

__STACK_SIZE = 1K;

SECTIONS
{

    .text :
    {
        KEEP(*(.vectors))
        *(.text)
    } > S_CODE_BOOT

    .data :
    {
        . = ALIGN(4);
        __data_begin = .;
        *(.data)
        __data_end = .;
    } > S_RAM AT > S_CODE_BOOT

    .bss :
    {
        . = ALIGN(4);
        __bss_begin = .;
        *(.bss)
        __bss_end = .;
    } > S_RAM

    .stack :
    {
        . = ALIGN(0x1000);
        __StackLimit = .;
        . = . + __STACK_SIZE;
        . = ALIGN(8);
        __StackTop = .;
    } > S_RAM
}


