/* Linker script to configure memory regions. */
MEMORY
{
   NS_ZBTRAM (rx) : ORIGIN = 0x00000000, LENGTH = 0x00400000
   /* S_ZBTRAM (rx) : ORIGIN = 0x10000000, LENGTH = 32k */
   NS_RAM (rwx) : ORIGIN = 0x28000000, LENGTH = 0x00200000
   /*S_RAM (rwx) : ORIGIN = 0x30000000, LENGTH = 32k */
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
    } > NS_ZBTRAM

    .data :
    {
        . = ALIGN(4);
        __data_begin = .;
        *(.data)
        __data_end = .;
    } > NS_RAM AT > NS_ZBTRAM

    .bss :
    {
        . = ALIGN(4);
        __bss_begin = .;
        *(.bss)
        __bss_end = .;
    } > NS_RAM

    .stack :
    {
        . = ALIGN(0x1000);
        __StackLimit = .;
        . = . + __STACK_SIZE;
        . = ALIGN(8);
        __StackTop = .;
    } > NS_RAM
}


