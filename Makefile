CROSS_COMPILE = riscv32-unknown-elf-

CFLAGS := -Wall -Wextra -Werror -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-unused-but-set-variable -Wno-unused-value -Wno-unused-label -Wno-unused-result
CFLAGS += -fno-builtin-printf -fno-common -g -O0 -ffreestanding -march=rv32imf -mabi=ilp32f -I ./ -I ./common -I ./drivers
# LDFLAGS := -static -lgcc -Tlink.lds -march=rv32imf -mabi=ilp32f -Wa,-march=rv32imf -nostartfiles -Wl,-Map=main.map
AFLAGS := -g -march=rv32imf -mabi=ilp32f
LDFLAGS := -Wl,-Map=main.map -nostdlib -Wl,-melf32lriscv -Wl,--build-id=none

TARGET = main.elf

APP_SRC := $(wildcard ./applications/sample/*.c) $(wildcard ./applications/sample/*.s)
DRV_SRC := $(wildcard ./drivers/*.c)

SRC := $(APP_SRC) $(DRV_SRC)
LNK := applications/sample/link.lds
OBJ := $(SRC:.c=.o)
OBJ := $(OBJ:.s=.o)

$(TARGET): $(OBJ) $(LNK)
	$(CROSS_COMPILE)gcc $(OBJ) $(LDFLAGS) -T$(LNK) -o $(TARGET)
	$(CROSS_COMPILE)objcopy --gap-fill 0 -O verilog $(TARGET) main.hex
	$(CROSS_COMPILE)objdump -D $(TARGET) > main.dump

uart.c: uart.h

%.o: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CROSS_COMPILE)as $(AFLAGS) $< -o $@

clean:
	rm -f *.elf *.hex *.dump *.map $(OBJ)

run:
	@# qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -kernel $(TARGET) -bios none
	qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -bios $(TARGET)

debug:
	qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -bios $(TARGET) -s -S