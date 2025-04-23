CROSS_COMPILE = riscv32-unknown-elf-

TARGET_ELF = main.elf
TARGET_HEX = main.hex
TARGET_DUMP = main.dump
TARGET_MAP = main.map

CFLAGS := -Werror -Wall -Wextra -Werror -Wformat -Wunused -pedantic -Wconversion
CFLAGS += -fno-builtin-printf -fno-common -g -O0 -ffreestanding -march=rv32imf -mabi=ilp32f -I ./ -I ./common -I ./drivers
# LDFLAGS := -static -lgcc -Tlink.lds -march=rv32imf -mabi=ilp32f -Wa,-march=rv32imf -nostartfiles -Wl,-Map=main.map
AFLAGS := -g -march=rv32imf -mabi=ilp32f
GCCFLAGS := -Wl,-Map=$(TARGET_MAP) -nostdlib -Wl,-melf32lriscv -Wl,--build-id=none -Wl,--print-memory-usage -Wl,--print-gc-sections -Wl,--gc-sections

APP_SRC := $(wildcard ./applications/sample/*.c) $(wildcard ./applications/sample/*.s)
APP_HDR := $(wildcard ./applications/sample/*.h)

DRV_SRC := $(wildcard ./drivers/*.c)
DRV_HDR := $(wildcard ./drivers/*.h) $(wildcard ./common/*.h)

SRC := $(APP_SRC) $(DRV_SRC)
LNK := applications/sample/link.lds
OBJ := $(SRC:.c=.o)
OBJ := $(OBJ:.s=.o)

$(TARGET_ELF): $(OBJ) $(LNK)
	$(CROSS_COMPILE)gcc $(OBJ) $(GCCFLAGS) -T$(LNK) -o $(TARGET_ELF)
	$(CROSS_COMPILE)objcopy --gap-fill 0 -O verilog $(TARGET_ELF) $(TARGET_HEX)
	$(CROSS_COMPILE)objdump -D $(TARGET_ELF) > $(TARGET_DUMP)

uart.c: uart.h

%.o: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CROSS_COMPILE)as $(AFLAGS) $< -o $@

check:
	./formater/checkpatch.pl --ignore SPDX_LICENSE_TAG --no-tree --quiet --strict -f $(APP_SRC) $(APP_HDR) $(DRV_SRC) $(DRV_HDR)

clean:
	rm -f *.elf *.hex *.dump *.map $(OBJ)

print-sections: $(TARGET_ELF)
	$(CROSS_COMPILE)objdump -h $(TARGET_ELF)

run:
	@# qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -kernel $(TARGET_ELF) -bios none
	qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -bios $(TARGET_ELF)

debug:
	qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -bios $(TARGET_ELF) -s -S