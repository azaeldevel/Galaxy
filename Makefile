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

CC = i386-elf-gcc
AS = i386-elf-as
LD = i386-elf-ld


CFLAGS = -O2 -w -trigraphs -fno-builtin  -fno-exceptions -fno-stack-protector -fno-rtti -nostdlib -nodefaultlibs -fomit-frame-pointer
CCFLAGS = $(CFLAGS) -std=c++20
CFLAGS_32 = -m32 $(CFLAGS)
CCFLAGS_32 = $(CFLAGS_32) -std=c++20

ENTRY_POINT=-Wl,-e,0x7c00 -Wl,-Tbss,0x7c00 -Wl,-Tdata,0x7c00 -Wl,-Ttext,0x7c00
LFLAGS=-Wl,--oformat=binary -nostdlib -fomit-frame-pointer -fno-builtin -nostartfiles -nodefaultlibs $(ENTRY_POINT)


.PRECIOUS: $(BUILD_DIR)/x86-16/%.s

	
$(BUILD_DIR)/meta/%.o : meta/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/x86-16/%.s : arch/x86/%.cc
	$(CC) -m16 -O2 -S $(LFLAGS) -o $@ $<

$(BUILD_DIR)/x86-16/%.o : $(BUILD_DIR)/x86-16/%.s
	$(AS) $< -o $@

$(BUILD_DIR)/x86-16/bootloader-cc : $(BUILD_DIR)/x86-16/bootloader.o  $(BUILD_DIR)/x86-16/Bios.o
	$(LD) -o $@ --oformat binary -e bootloader -Ttext 0x7c00 $^

$(BUILD_DIR)/x86-16/bootloader-s : arch/x86/bootloader.s
	$(AS) $< -o $(BUILD_DIR)/x86-16/bootloader.o
	$(LD) -o $@ --oformat binary -Ttext 0x7c00 $(BUILD_DIR)/x86-16/bootloader.o

show: $(BUILD_DIR)/bootloader-$(BOOTLOADER)
	@cat $^|hexdump -C
	@ndisasm -b $(WIDTH) $^

$(BUILD_DIR)/floppy.img : $(BUILD_DIR)/x86-16/bootloader-$(BOOTLOADER)
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img count=1440 bs=1k
	parted -s $@ mktable msdos
	parted -s $@ mkpart primary fat32 1 "100%"
	parted -s $@ set 1 boot on
	dd if=$< bs=510 count=1 of=$@ conv=notrunc

booting : $(BUILD_DIR)/floppy.img
	qemu-system-i386 -fda $^ -boot a





	
$(BUILD_DIR)/x86-32/%.o : kernel/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/x86-32/%.o : arch/x86/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/x86-32/%.o : meta/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/x86-32/boot.o : arch/x86/boot.s
	$(AS) --32 $^ -o $@
	
	
$(BUILD_DIR)/x86-32/kernel : linker.ld $(BUILD_DIR)/x86-32/memory.o $(BUILD_DIR)/x86-32/boot.o $(BUILD_DIR)/x86-32/VGA.o $(BUILD_DIR)/x86-32/kernel.o  $(BUILD_DIR)/x86-32/Bios.o
	$(LD) -m elf_i386 -T $^ -o $@ -nostdlib
	grub-file --is-x86-multiboot $@
	
$(BUILD_DIR)/Meta-SO.iso : $(BUILD_DIR)/x86-32/kernel
	mkdir -p $(BUILD_DIR)/x86-32/isodir/boot/grub
	cp $(BUILD_DIR)/x86-32/kernel $(BUILD_DIR)/x86-32/isodir/boot/
	cp grub.cfg $(BUILD_DIR)/x86-32/isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(BUILD_DIR)/x86-32/Meta-SO.iso $(BUILD_DIR)/x86-32/isodir
	
run : $(BUILD_DIR)/Meta-SO.iso
	qemu-system-i386 -cdrom $(BUILD_DIR)/x86-32/Meta-SO.iso
	
build : $(BUILD_DIR)/kernel

.PHONY:  clean

clean :
	rm -rf $(BUILD_DIR)/x86-16/*
	rm -rf $(BUILD_DIR)/x86-32/*
	rm -rf $(BUILD_DIR)/floppy.img
	
