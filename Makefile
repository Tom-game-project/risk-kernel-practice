.PHONY: run clean dump debug

CC=riscv64-unknown-elf-gcc

CFLAGS=

KERNEL_SRC=kernel.c
KERNEL_OBJ=$(KERNEL_SRC:%.c=%.o)

ENTRY=entry.S
ENTRY_OBJ=$(ENTRY:%.S=%.o)

OBJS= \
	  $(ENTRY_OBJ) \
	  $(KERNEL_OBJ)

KERNEL_LD=kernel.ld

KERNEL=kernel.elf

# 環境によってgdb-multiarchなどに書き換える
GDB=gdb
GDB_SETUP=setup.gdb

debug: CFLAGS+=-g

%.o: %.c
	$(CC) $(CFLAGS) -c -mcmodel=medany -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) -c -mcmodel=medany -o $@ $<

$(KERNEL): $(OBJS) $(KERNEL_LD)
	riscv64-unknown-elf-ld -T $(KERNEL_LD) -o $(KERNEL) $(OBJS)

run: $(KERNEL)
	qemu-system-riscv64 -machine virt -bios none -nographic -kernel $(KERNEL) -s -S

dump: $(KERNEL)
	riscv64-linux-gnu-objdump -d $(KERNEL)

# debugコマンドは以下の環境を要求する
#
# - https://github.com/bata24/gef/tree/dev
# -
debug: $(KERNEL)
	@echo 
	zellij run -f --name "QEMU (RISC-V)" -- make run
	@sleep 0.5
	$(GDB) -q -x $(GDB_SETUP) $(KERNEL)

clean:
	rm -f $(OBJS) $(KERNEL)
