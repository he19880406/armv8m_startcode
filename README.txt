
/* Qemu: qemu-system-arm -machine musca-b1 -cpu cortex-m33 -m 16m -nographic -kernel kernel.elf -s
         arm-none-eabi-gdb  -ex "symbol kernel.elf" -ex "target remote localhost:1234"
 * The Musca boards are a reference implementation of a system using
 * the SSE-200 subsystem for embedded:
 * https://developer.arm.com/products/system-design/development-boards/iot-test-chips-and-boards/musca-a-test-chip-board
 * https://developer.arm.com/products/system-design/development-boards/iot-test-chips-and-boards/musca-b-test-chip-board
 * We model the A and B1 variants of this board, as described in the TRMs:
 * http://infocenter.arm.com/help/topic/com.arm.doc.101107_0000_00_en/index.html
 * http://infocenter.arm.com/help/topic/com.arm.doc.101312_0000_00_en/index.html
 */
