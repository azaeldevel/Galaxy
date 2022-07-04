ifndef BUILD_DIR
	BUILD_DIR=build
endif
ifndef EMULATOR
	EMULATOR = qemu
endif
ifndef DISK_TYPE
	DISK_TYPE = floppy
endif
BOOTLOADER = cc

CC = gcc
CFLAGS = -O2 -w -trigraphs -fno-builtin  -fno-exceptions -fno-stack-protector -fno-rtti -nostdlib -nodefaultlibs -fomit-frame-pointer
CCFLAGS = $(CFLAGS) -std=c++20

CFLAGS_32 = -m32 $(CFLAGS)
CCFLAGS_32 = $(CFLAGS_32) -std=c++20


ENTRY_POINT=-Wl,-e,0x7c00 -Wl,-Tbss,0x7c00 -Wl,-Tdata,0x7c00 -Wl,-Ttext,0x7c00
LFLAGS=-Wl,--oformat=binary -nostdlib -fomit-frame-pointer -fno-builtin -nostartfiles -nodefaultlibs $(ENTRY_POINT)


$(BUILD_DIR)/bootloader-s : arch/x86/bootloader.s
	as $< -o $(BUILD_DIR)/bootloader.o
	ld -o $@ --oformat binary -Ttext 0x7c00 $(BUILD_DIR)/bootloader.o

$(BUILD_DIR)/bootloader-cc : $(BUILD_DIR)/cheers.o arch/x86/bootloader.cc
	i386-elf-g++ -m16 -O2 -S $(LFLAGS) -std=c++1z -o $@.s arch/x86/bootloader.cc
	as $@.s -o $(BUILD_DIR)/bootloader.o
	ld -o $@ --oformat binary -e bootloader -Ttext 0x7c00 $(BUILD_DIR)/bootloader.o $(BUILD_DIR)/cheers.o
	
show: $(BUILD_DIR)/bootloader-$(BOOTLOADER)
	@cat $^|hexdump -C
	@ndisasm -b $(WIDTH) $^

$(BUILD_DIR)/floppy.img : $(BUILD_DIR)/bootloader-$(BOOTLOADER)
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img count=1440 bs=1k
	parted -s $@ mktable msdos
	parted -s $@ mkpart primary fat32 1 "100%"
	parted -s $@ set 1 boot on
	dd if=$(BUILD_DIR)/bootloader-$(BOOTLOADER) bs=510 count=1 of=$@ conv=notrunc

booting : $(BUILD_DIR)/floppy.img
	qemu-system-i386 -fda $^ -boot a


$(BUILD_DIR)/%.o : kernel/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/%.o : arch/x86/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/meta/%.o : meta/%.cc
	mkdir -p $(BUILD_DIR)/meta
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/boot.o : arch/x86/boot.s
	as --32 $^ -o $@

$(BUILD_DIR)/cheers.o : arch/x86/cheers.s
	as $^ -o $@
	
$(BUILD_DIR)/kernel : linker.ld $(BUILD_DIR)/meta/memory.o $(BUILD_DIR)/cheers.o $(BUILD_DIR)/boot.o  $(BUILD_DIR)/Bios.o $(BUILD_DIR)/VGA.o $(BUILD_DIR)/kernel.o
	ld -m elf_i386 -T $^ -o $@ -nostdlib
	grub-file --is-x86-multiboot $@




$(BUILD_DIR)/Meta-SO.iso : $(BUILD_DIR)/kernel
	mkdir -p $(BUILD_DIR)/isodir/boot/grub
	cp $(BUILD_DIR)/kernel $(BUILD_DIR)/isodir/boot/
	cp grub.cfg $(BUILD_DIR)/isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(BUILD_DIR)/Meta-SO.iso $(BUILD_DIR)/isodir

	
run : $(BUILD_DIR)/Meta-SO.iso
	qemu-system-i386 -cdrom $(BUILD_DIR)/Meta-SO.iso
	
build : $(BUILD_DIR)/kernel

.PHONY:  clean

clean :
	rm -r $(BUILD_DIR)/*
