IMAGE := kernel.elf

CROSS_COMPILE = armv8l-linux-gnueabihf-

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
GDB = $(CROSS_COMPILE)gdb
OBJDUMP = $(CROSS_COMPILE)objdump
READELF = $(CROSS_COMPILE)readelf

CFLAGS = -mcpu=cortex-m33 -g -nostdlib -nostartfiles -ffreestanding

all: $(IMAGE)

OBJS = main.o

boot.o: boot.s
	$(CC) -mcpu=cortex-m33 -g -c boot.s -o boot.o

$(IMAGE): kernel.ld boot.o $(OBJS)
	$(LD) boot.o $(OBJS) -T kernel.ld -o $(IMAGE)
	$(OBJDUMP) -D $(IMAGE) > kernel.list
	$(OBJDUMP) -t $(IMAGE) | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > kernel.sym
	$(READELF) -A $(IMAGE)

dumpvmstate:
	qemu-system-arm -machine mps2-an505 -cpu cortex-m33 \
	                    -m 1024 \
			    -nographic -serial mon:stdio \
	                    -kernel $(IMAGE) \
			    -dump-vmstate vmstate.json 

qemu:
	qemu-system-arm -machine mps2-an505 -cpu cortex-m33 \
	                    -m 16m \
			    -nographic \
	                    -kernel $(IMAGE)

gdbserver:
	qemu-system-arm -machine mps2-an505 -cpu cortex-m33 \
	                    -m 4096 \
			    -nographic -serial mon:stdio \
	                    -kernel $(IMAGE) \
			    -S -s
gdb: $(IMAGE)
	$(GDB) $^ -ex "target remote:1234"


gdbqemu:
	gdb --args qemu-system-arm -machine mps2-an505 -cpu cortex-m33  -m 4096  -nographic -serial mon:stdio -kernel kernel.elf

clean:
	rm -f $(IMAGE) *.o *.list *.sym

.PHONY: all qemu clean
