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

	
$(BUILD_DIR)/meta/%.o : meta/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/x86-16/%-boot.s : arch/x86/%.cc
	$(CC) -S $(LFLAGS_MBR) -o $@ $<

$(BUILD_DIR)/x86-16/%-loader.s : arch/x86/%.cc
	$(CC) -S $(LFLAGS_LOADER) -o $@ $<

$(BUILD_DIR)/x86-16/boot-cc : $(BUILD_DIR)/x86-16/boot-boot.o  $(BUILD_DIR)/x86-16/Bios-boot.o
	$(LD) -o $@ --oformat binary -e booting -Ttext $(BOOT_ADDRESS) $^
	
$(BUILD_DIR)/x86-16/loader : $(BUILD_DIR)/x86-16/loader-loader.o  $(BUILD_DIR)/x86-16/Bios-loader.o
	$(LD) -o $@ --oformat binary -e loading -Ttext $(LOADER_ADDRESS) $^

$(BUILD_DIR)/x86-16/boot-s : arch/x86/boot.s
	$(AS) $< -o $(BUILD_DIR)/x86-16/boot.o
	$(LD) -o $@ --oformat binary -Ttext $(BOOT_ADDRESS) $(BUILD_DIR)/x86-16/boot.o

show: $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE)
	@cat $^|hexdump -C
	@ndisasm -b 16 $^

$(BUILD_DIR)/bootloader.img : $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE) $(BUILD_DIR)/x86-16/loader
	dd if=/dev/zero of=$@ bs=512 count=2880
	printf '\x55' | dd bs=1 count=1 of=$@ conv=notrunc seek=510 count=1
	printf '\xAA' | dd bs=1 count=1 of=$@ conv=notrunc seek=511 count=1
	dd if=$< bs=510 count=1 of=$@ conv=notrunc
	dd if=$(BUILD_DIR)/x86-16/loader of=$@ conv=notrunc seek=512
	

$(BUILD_DIR)/kernel.img : $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE) $(BUILD_DIR)/x86-16/loader
	dd if=/dev/zero of=$@ bs=512 count=2880
	sudo sudo mkfs -t ext2 $@
	echo -e "n\np\n1\n1\n2879\na\nw" | fdisk $@
	sudo losetup $(LOOP_FDA) $@
	dd if=$< bs=510 count=1 of=$@ conv=notrunc
	sudo mount -t ext2 $(LOOP_FDA) /mnt/floppy
	sudo mkdir /mnt/floppy/boot
	sudo cp $(BUILD_DIR)/x86-16/loader /mnt/floppy/boot/ 
	sudo umount $(LOOP_FDA)
	sudo losetup -d $(LOOP_FDA)
	
booting : $(BUILD_DIR)/bootloader.img
	qemu-system-i386 -fda $^ -boot a





	
$(BUILD_DIR)/x86-32/%.o : kernel/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/x86-32/%.o : arch/x86/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)
	
$(BUILD_DIR)/x86-32/%.o : meta/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/x86-32/kernel.o : arch/x86/kernel.s
	$(AS) --32 $^ -o $@
	
$(BUILD_DIR)/x86-32/kernel : linker.ld $(BUILD_DIR)/x86-32/memory.o $(BUILD_DIR)/x86-32/kernel.o $(BUILD_DIR)/x86-32/VGA.o $(BUILD_DIR)/x86-32/kernel.o  $(BUILD_DIR)/x86-32/Bios.o
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
	
