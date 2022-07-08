ifndef BUILD_DIR
	BUILD_DIR=build
endif
ifndef EMULATOR
	EMULATOR = qemu
endif
ifndef DISK_TYPE
	DISK_TYPE = floppy
endif
BOOT_TYPE = cc
BOOT_ADDRESS = 0x7c00
LOADER_ADDRESS = 0x8000
LOOP_FDA = $(shell losetup -f)

CC = i386-elf-gcc
AS = i386-elf-as
LD = i386-elf-ld

FLAGS_GENERIC = -O2 -nostdlib -fomit-frame-pointer -fno-builtin -nodefaultlibs -fno-exceptions -fno-rtti -ffreestanding -fno-stack-protector
CFLAGS =  $(FLAGS_GENERIC) -w -trigraphs -nostartfiles
CCFLAGS = $(CFLAGS)
CFLAGS_32 = -m32 $(CFLAGS)
CCFLAGS_32 = $(CFLAGS_32)

SECTION_MBR =-Wl,-e,$(BOOT_ADDRESS) -Wl,-Tbss,$(BOOT_ADDRESS) -Wl,-Tdata,$(BOOT_ADDRESS) -Wl,-Ttext,$(BOOT_ADDRESS)
LFLAGS_MBR=-Wl,--oformat=binary $(CCFLAGS) $(SECTION_MBR) -m16

LOADER_SECTION =-Wl,-e,$(LOADER_ADDRESS) -Wl,-Tbss,$(LOADER_ADDRESS) -Wl,-Tdata,$(LOADER_ADDRESS) -Wl,-Ttext,$(LOADER_ADDRESS)
LFLAGS_LOADER=-Wl,--oformat=binary $(CCFLAGS) $(LOADER_SECTION) -m16

.PRECIOUS : build/x86-16/Bios-boot.s build/x86-16/boot-boot.s





$(BUILD_DIR)/x86-16/boot.cc.o : arch/x86/boot.cc
	$(CC) -c -O2 -ffreestanding -Wall -Werror $^ -o $@
	
$(BUILD_DIR)/x86-16/boot-boot-cc : $(BUILD_DIR)/x86-16/boot.cc.o
	$(LD) -static -Tarch/x86/boot.ld -nostdlib --nmagic -o $@ $^

$(BUILD_DIR)/x86-16/boot-cc : $(BUILD_DIR)/x86-16/boot-boot-cc
	objcopy -O binary $^ $@
	






$(BUILD_DIR)/x86-16/boot-boot-c.o : arch/x86/boot.c
	$(CC) -c -O2 -ffreestanding -Wall -Werror $^ -o $@
	
$(BUILD_DIR)/x86-16/boot-boot-c : $(BUILD_DIR)/x86-16/boot-boot-c.o
	$(LD) -static -Tarch/x86/boot.ld -nostdlib --nmagic -o $@ $^

$(BUILD_DIR)/x86-16/boot-c : $(BUILD_DIR)/x86-16/boot-boot-c
	objcopy -O binary $^ $@












$(BUILD_DIR)/x86-16/boot-nasm : arch/x86/boot.asm
	nasm $^ -f bin -o $@









show: $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE)
	@cat $^|hexdump -C
	@ndisasm -b 16 $^



$(BUILD_DIR)/bootloader.img : $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE)
	dd if=/dev/zero of=$@ bs=512 count=2880
	printf '\x55' | dd bs=1 count=1 of=$@ conv=notrunc seek=510 count=1
	printf '\xAA' | dd bs=1 count=1 of=$@ conv=notrunc seek=511 count=1
	dd if=$< bs=510 count=1 of=$@ conv=notrunc
	#dd if=$(BUILD_DIR)/x86-16/loader of=$@ conv=notrunc seek=512
	

	
booting : $(BUILD_DIR)/bootloader.img
	qemu-system-i386 -fda $^ -boot a



.PHONY:  clean

clean :
	rm -rf $(BUILD_DIR)/x86-16/*
	rm -rf $(BUILD_DIR)/x86-32/*
	rm -rf $(BUILD_DIR)/floppy.img
	
