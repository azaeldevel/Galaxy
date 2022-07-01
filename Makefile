 ifndef BUILD_DIR
 BUILD_DIR=build
 endif

CC = gcc
CFLAGS = -m32 -O2 -w -trigraphs -fno-builtin  -fno-exceptions -fno-stack-protector -fno-rtti -nostdlib -nodefaultlibs
CCFLAGS = $(CFLAGS) -std=c++20

$(BUILD_DIR)/bootloader.o : 
	
$(BUILD_DIR)/bootloader.o : arch/x86/bootloader.s
	as $^ -o $(BUILD_DIR)/bootloader.o
	ld -o $(BUILD_DIR)/bootloader --oformat binary -e init -Ttext 0x7c00 $(BUILD_DIR)/bootloader.o

$(BUILD_DIR)/floppy.img : $(BUILD_DIR)/bootloader.o
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=512 count=2880
	dd if=$(BUILD_DIR)/bootloader of=$(BUILD_DIR)/floppy.img
	
booting : $(BUILD_DIR)/floppy.img
	qemu-system-i386 -fda $^

$(BUILD_DIR)/%.o : kernel/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS)
	
$(BUILD_DIR)/%.o : arch/x86/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS)

$(BUILD_DIR)/boot.o : arch/x86/boot.s
	as --32 arch/x86/boot.s -o $(BUILD_DIR)/boot.o

$(BUILD_DIR)/kernel : linker.ld $(BUILD_DIR)/boot.o  $(BUILD_DIR)/Bios.o $(BUILD_DIR)/Video.o $(BUILD_DIR)/VGA.o $(BUILD_DIR)/kernel.o
	ld -m elf_i386 -T $^ -o $(BUILD_DIR)/kernel -nostdlib
	grub-file --is-x86-multiboot $(BUILD_DIR)/kernel

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
