PROJ_DIR := $(shell pwd)

CROSS_COMPILE := arm-none-eabi-

CC := ${CROSS_COMPILE}gcc
AS := ${CROSS_COMPILE}gcc -x assembler-with-cpp
LD := ${CROSS_COMPILE}ld
OBJCOPY := ${CROSS_COMPILE}objcopy
OBJDUMP := ${CROSS_COMPILE}objdump

APP_NAME := kernel
APP := ${APP_NAME}.elf
SRC_DIR := src
OBJ_DIR := obj

DEBUG_FLAGS = -g

ARMFLAGS += -mcpu=cortex-m33 -fno-exceptions -fno-unwind-tables
ASFLAGS += -nostdlib -Werror ${DEBUG_FLAGS} $(ARMFLAGS) ${INCLUDES}
CFLAGS += -nostdlib -Wall -Werror ${DEBUG_FLAGS} $(ARMFLAGS) ${INCLUDES}

LDFLAGS += --fatal-warnings -O1 -T kernel.ld

DIRS := $(shell find . -maxdepth 5 -type d)
APP_C_SRC := $(foreach SRC_DIR, $(DIRS),$(wildcard $(SRC_DIR)/*.c))
APP_C_SRC := $(subst ./,,$(APP_C_SRC))

APP_ASM_SRC := $(foreach SRC_DIR, $(DIRS),$(wildcard $(SRC_DIR)/*.s))
APP_ASM_SRC := $(subst ./,,$(APP_ASM_SRC))

OBJ_FILES := $(APP_C_SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
OBJ_FILES += $(APP_ASM_SRC:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)
DEP_FILES := $(OBJ_FILES:%=%.d)

OBJ_SUB_DIR := $(dir $(OBJ_FILES))

.PHONY: all clean

all: $(APP)

$(APP): $(OBJ_DIR) $(OBJ_FILES)
	$(LD) $(LDFLAGS) $(OBJ_FILES) -o $@
	$(OBJCOPY) -O binary $@ ${APP_NAME}.img
	$(OBJDUMP) -S -D $@ > ${APP_NAME}.dump

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	mkdir -p $(OBJ_SUB_DIR)
	$(CC) -c $(CFLAGS) -o $@ $<

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.s
	mkdir -p $(OBJ_SUB_DIR)
	$(CC) -c $(ASFLAGS) -o $@ $<

$(OBJ_DIR):
	mkdir -p $@

-include $(DEP_FILES)

clean:
	@echo "CLEAN"
	rm -rf ${OBJ_DIR} ${APP_NAME}.dump ${APP_NAME}.elf ${APP_NAME}.img
