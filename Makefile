.PHONY: run clean

CC=riscv64-unknown-elf-gcc

KERNEL_SRC=kernel.c
KERNEL_OBJ=$(KERNEL_SRC:%.c=%.o)

ENTRY=entry.S
ENTRY_OBJ=$(ENTRY:%.S=%.o)

OBJS= \
	  $(ENTRY_OBJ) \
	  $(KERNEL_OBJ)

KERNEL_LD=kernel.ld

KERNEL=kernel.elf

%.o: %.c
	$(CC) -c -mcmodel=medany -o $@ $<

$.o: %.S
	$(CC) -c -mcmodel=medany -o $@ $<


$(KERNEL): $(OBJS) $(KERNEL_LD)
	riscv64-unknown-elf-ld -T $(KERNEL_LD) -o $(KERNEL) $(OBJS)

run: $(KERNEL)
	qemu-system-riscv64 -machine virt -bios none -nographic -kernel $(KERNEL)

dump: $(KERNEL)
	riscv64-linux-gnu-objdump -d $(KERNEL)

clean:
	rm -f $(OBJS) $(KERNEL)
