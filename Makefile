ifndef BUILD_DIR
	BUILD_DIR=build
endif
ifndef EMULATOR
	EMULATOR = qemu
endif
ifndef DISK_TYPE
	DISK_TYPE = floppy
endif


BOOT_SUFFIX = cc
BOOT_ADDRESS = 0x7c00
LOADER_ADDRESS = 0x8000
LOOP_FDA = $(shell losetup -f)

CC = i386-elf-gcc
AS = i386-elf-as
LD = i386-elf-ld

.PRECIOUS : $(BUILD_DIR)/x86-16/%.cc.s

$(BUILD_DIR)/x86-16/%.cc.s : arch/x86/%.cc
	$(CC) -S -O2 -ffreestanding -Wall -Werror $^ -o $@

$(BUILD_DIR)/x86-16/%.cc.o : $(BUILD_DIR)/x86-16/%.cc.s
	$(CC) -c -O2 -ffreestanding -Wall -Werror $^ -o $@
	
$(BUILD_DIR)/x86-16/boot-cc.bin : $(BUILD_DIR)/x86-16/boot.cc.o
	$(LD) -static -Tarch/x86/boot.ld -nostdlib --nmagic -o $@ $^

$(BUILD_DIR)/x86-16/boot-cc : $(BUILD_DIR)/x86-16/boot-cc.bin
	objcopy -O binary $^ $@
	
	
$(BUILD_DIR)/x86-16/loader-cc : $(BUILD_DIR)/x86-16/loader.cc.o
	$(LD) -static -Tarch/x86/loader.ld -nostdlib --nmagic -o $@ $^

$(BUILD_DIR)/x86-16/loader-cc : $(BUILD_DIR)/x86-16/loader-cc
	objcopy -O binary $^ $@




$(BUILD_DIR)/x86-16/boot-c.o : arch/x86/boot.c
	$(CC) -c -O2 -ffreestanding -Wall -Werror $^ -o $@
	
$(BUILD_DIR)/x86-16/boot-c.bin : $(BUILD_DIR)/x86-16/boot-c.o
	$(LD) -static -Tarch/x86/boot.ld -nostdlib --nmagic -o $@ $^

$(BUILD_DIR)/x86-16/boot-c : $(BUILD_DIR)/x86-16/boot-c.bin
	objcopy -O binary $^ $@












$(BUILD_DIR)/x86-16/boot-nasm : arch/x86/boot.asm
	nasm $^ -f bin -o $@









show: $(BUILD_DIR)/x86-16/boot-$(BOOT_SUFFIX)
	@cat $^|hexdump -C
	@ndisasm -b 16 $^



$(BUILD_DIR)/bootloader.img : $(BUILD_DIR)/x86-16/boot-$(BOOT_SUFFIX) $(BUILD_DIR)/x86-16/loader-$(BOOT_SUFFIX)
	dd if=/dev/zero of=$@ bs=512 count=2880
	printf '\x55' | dd bs=1 count=1 of=$@ conv=notrunc seek=510 count=1
	printf '\xAA' | dd bs=1 count=1 of=$@ conv=notrunc seek=511 count=1
	dd if=$< bs=510 count=1 of=$@ conv=notrunc
	dd if=$(BUILD_DIR)/x86-16/loader-$(BOOT_SUFFIX) of=$@ conv=notrunc seek=512
	

	
booting : $(BUILD_DIR)/bootloader.img
	qemu-system-i386 -fda $^ -boot a



.PHONY:  clean

clean :
	rm -rf $(BUILD_DIR)/x86-16/*
	rm -rf $(BUILD_DIR)/x86-32/*
	rm -rf $(BUILD_DIR)/floppy.img
	
