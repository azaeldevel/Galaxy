ifndef BUILD_DIR
	BUILD_DIR=build
endif
ifndef WIDTH
	WIDTH = 32
endif
CC = gcc
CFLAGS = -O2 -w -trigraphs -fno-builtin  -fno-exceptions -fno-stack-protector -fno-rtti -nostdlib -nodefaultlibs -fomit-frame-pointer
CCFLAGS = $(CFLAGS) -std=c++20

CFLAGS_32 = -m32 $(CFLAGS)
CCFLAGS_32 = $(CFLAGS_32) -std=c++20


ENTRY_POINT=-Wl,-e,0x7c00 -Wl,-Tbss,0x7c00 -Wl,-Tdata,0x7c00 -Wl,-Ttext,0x7c00
LFLAGS=-Wl,--oformat=binary -nostdlib -fomit-frame-pointer -fno-builtin -nostartfiles -nodefaultlibs $(ENTRY_POINT)


$(BUILD_DIR)/bootloader-32.o : arch/x86/bootloader.s
	as $^ -o $@
$(BUILD_DIR)/bootloader-32 : $(BUILD_DIR)/bootloader-32.o
	ld -o $@ --oformat binary -e init -Ttext 0x7c00 $(BUILD_DIR)/bootloader-$(WIDTH).o


$(BUILD_DIR)/bootloader-16.bin : arch/x86/bootloader.cc
	$(CC) $(LFLAGS) -Oz -std=c++1z -m16 -o $@ $^
$(BUILD_DIR)/bootloader-16 : $(BUILD_DIR)/bootloader-16.bin
	mv $^ $@

show: $(BUILD_DIR)/bootloader-$(WIDTH)
	@cat $^|hexdump -C
	@ndisasm -b $(WIDTH) $^

$(BUILD_DIR)/floppy.img : $(BUILD_DIR)/bootloader-$(WIDTH)
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=1024 count=1440
	dd if=$^ of=$(BUILD_DIR)/floppy.img bs=1 count=512 conv=notrunc
booting : $(BUILD_DIR)/floppy.img
	qemu-system-i386 -fda $^ -boot a




$(BUILD_DIR)/%.o : kernel/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/%.o : arch/x86/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/boot.o : arch/x86/boot.s
	as --32 arch/x86/boot.s -o $@

$(BUILD_DIR)/kernel : linker.ld $(BUILD_DIR)/boot.o  $(BUILD_DIR)/Bios.o $(BUILD_DIR)/Video.o $(BUILD_DIR)/VGA.o $(BUILD_DIR)/kernel.o
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
