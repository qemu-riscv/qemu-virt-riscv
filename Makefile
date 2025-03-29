CROSS_COMPILE = riscv32-unknown-elf-

CFLAGS += -fno-builtin-printf -fno-common -g -O0 -ffreestanding -march=rv32imf -mabi=ilp32f 
# LDFLAGS := -static -lgcc -Tlink.lds -march=rv32imf -mabi=ilp32f -Wa,-march=rv32imf -nostartfiles -Wl,-Map=main.map
AFLAGS := -g -march=rv32imf -mabi=ilp32f
LDFLAGS := -Wl,-Map=main.map -nostdlib -Wl,-melf32lriscv -Wl,--build-id=none

TARGET = main.elf

SRC = $(wildcard *.c)  $(wildcard *.s)
OBJ := $(SRC:.c=.o)
OBJ := $(OBJ:.s=.o)

$(TARGET): $(OBJ) link.lds
	$(CROSS_COMPILE)gcc $(OBJ) $(LDFLAGS) -Tlink.lds -o main.elf
	$(CROSS_COMPILE)objcopy --gap-fill 0 -O verilog main.elf main.hex
	$(CROSS_COMPILE)objdump -D main.elf > main.dump

%.o: %.s
	$(CROSS_COMPILE)as $(AFLAGS) $< -o $@

clean:
	rm *.elf *.hex *.dump *.map *.o

run:
	@# qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -kernel $(TARGET) -bios none
	qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -bios $(TARGET)

debug:
	qemu-system-riscv32 -machine virt -nographic -d in_asm -D log/log -serial mon:stdio -bios $(TARGET) -s -S