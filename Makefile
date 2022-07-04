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

ENTRY_POINT=-Wl,-e,0x7c00 -Wl,-Tbss,0x7c00 -Wl,-Tdata,0x7c00 -Wl,-Ttext,0x7c00
LFLAGS=-Wl,--oformat=binary -nostdlib -fomit-frame-pointer -fno-builtin -nostartfiles -nodefaultlibs $(ENTRY_POINT)

.PRECIOUS: $(BUILD_DIR)/x86-16/%.s

	
$(BUILD_DIR)/meta/%.o : meta/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/x86-16/%.s : arch/x86/%.cc
	$(CC) -m16 -O2 -S $(LFLAGS) -o $@ $<

$(BUILD_DIR)/x86-16/%.o : $(BUILD_DIR)/x86-16/%.s
	$(AS) $< -o $@

$(BUILD_DIR)/bootloader-cc : $(BUILD_DIR)/x86-16/bootloader.o  $(BUILD_DIR)/x86-16/Bios.o
	$(LD) -o $@ --oformat binary -e bootloader -Ttext 0x7c00 $^

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

	
build : $(BUILD_DIR)/kernel

.PHONY:  clean

clean :
	rm -rf $(BUILD_DIR)/x86-16/*
	rm -rf $(BUILD_DIR)/meta/*
	
