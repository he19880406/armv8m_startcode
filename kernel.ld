/* Linker script to configure memory regions. */
MEMORY
{
   MPC_ROM_QSPI (rx) : ORIGIN = 0x00000000, LENGTH = 0x02000000
   MPC_SRAM (rwx) : ORIGIN = 0x0a400000, LENGTH = 0x00080000
   MPC_ROM_EFLASH0 (rx) : ORIGIN = 0x0a000000, LENGTH = 0x00200000
   MPC_ROM_EFLASH1 (rx) : ORIGIN = 0x0a200000, LENGTH = 0x00200000
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
    } > MPC_ROM_EFLASH0

    .data :
    {
        . = ALIGN(4);
        __data_begin = .;
        *(.data)
        __data_end = .;
    } > MPC_SRAM AT > MPC_ROM_EFLASH0

    .bss :
    {
        . = ALIGN(4);
        __bss_begin = .;
        *(.bss)
        __bss_end = .;
    } > MPC_SRAM

    .stack :
    {
        . = ALIGN(0x1000);
        __StackLimit = .;
        . = . + __STACK_SIZE;
        . = ALIGN(8);
        __StackTop = .;
    } > MPC_SRAM
}
