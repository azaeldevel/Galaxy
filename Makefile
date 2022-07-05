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
BOOT_SECTION = 0x7c00
LOADER_SECTION = 0x8000
LOOP_FDA = $(shell losetup -f)

CC = i386-elf-gcc
AS = i386-elf-as
LD = i386-elf-ld

CFLAGS = -O2 -w -nostdlib -fomit-frame-pointer -fno-builtin -fno-stack-protector  -trigraphs  -fno-exceptions -fno-rtti -nodefaultlibs
CCFLAGS = $(CFLAGS) -std=c++20
CFLAGS_32 = -m32 $(CFLAGS)
CCFLAGS_32 = $(CFLAGS_32) -std=c++20

SECTION_MBR =-Wl,-e,$(BOOT_SECTION) -Wl,-Tbss,$(BOOT_SECTION) -Wl,-Tdata,$(BOOT_SECTION) -Wl,-Ttext,$(BOOT_SECTION)
LFLAGS_MBR=-Wl,--oformat=binary -nostdlib -fomit-frame-pointer -fno-builtin -nostartfiles -nodefaultlibs $(SECTION_MBR)

SECTION_LOADER =-Wl,-e,$(LOADER_SECTION) -Wl,-Tbss,$(LOADER_SECTION) -Wl,-Tdata,$(LOADER_SECTION) -Wl,-Ttext,$(LOADER_SECTION)
LFLAGS_LOADER=-Wl,--oformat=binary -nostdlib -fomit-frame-pointer -fno-builtin -nostartfiles -nodefaultlibs $(SECTION_LOADER)

.PRECIOUS: $(BUILD_DIR)/x86-16/%.s

	
$(BUILD_DIR)/meta/%.o : meta/%.cc
	$(CC) -c $^ -o $@ $(CCFLAGS_32)

$(BUILD_DIR)/x86-16/%-boot.s : arch/x86/%.cc
	$(CC) -m16 -O2 -S $(LFLAGS) -o $@ $<

$(BUILD_DIR)/x86-16/%-boot.o : $(BUILD_DIR)/x86-16/%.s
	$(AS) $< -o $@

$(BUILD_DIR)/x86-16/%-loader.s : arch/x86/%.cc
	$(CC) -m16 -O2 -S $(LFLAGS) -o $@ $<

$(BUILD_DIR)/x86-16/%-loader.o : $(BUILD_DIR)/x86-16/%.s
	$(AS) $< -o $@
	
$(BUILD_DIR)/x86-16/boot-cc : $(BUILD_DIR)/x86-16/boot-boot.o  $(BUILD_DIR)/x86-16/Bios-boot.o
	$(LD) -o $@ --oformat binary -e booting -Ttext $(BOOT_SECTION) $^
	
$(BUILD_DIR)/x86-16/loader : $(BUILD_DIR)/x86-16/loader-loader.o  $(BUILD_DIR)/x86-16/Bios-loader.o
	$(LD) -o $@ --oformat binary -e booting -Ttext $(LOADER_SECTION) $^

$(BUILD_DIR)/x86-16/boot-s : arch/x86/boot.s
	$(AS) $< -o $(BUILD_DIR)/x86-16/boot.o
	$(LD) -o $@ --oformat binary -Ttext $(BOOT_SECTION) $(BUILD_DIR)/x86-16/boot.o

show: $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE)
	@cat $^|hexdump -C
	@ndisasm -b 16 $^

$(BUILD_DIR)/floppy.img : $(BUILD_DIR)/x86-16/boot-$(BOOT_TYPE) $(BUILD_DIR)/x86-16/loader
	#dd if=/dev/zero of=$(BUILD_DIR)/floppy.img count=1440 bs=1k
	qemu-img create -f raw $(BUILD_DIR)/floppy.img 1440k
	mkfs.msdos -s 1 $(BUILD_DIR)/floppy.img
	sudo losetup $(LOOP_FDA) $(BUILD_DIR)/floppy.img
	#sudo mkfs -t ext2 $(LOOP_FDA)
	#sudo parted $(LOOP_FDA) mktable msdos
	#sudo parted $(LOOP_FDA) mkpart primary ext2 1 720k
	#sudo parted $(LOOP_FDA) set 1 boot on
	sudo mount $(LOOP_FDA) /mnt/floppy/
	sudo mkdir /mnt/floppy/boot
	sudo cp $(BUILD_DIR)/x86-16/loader /mnt/floppy/boot/ 
	sudo umount $(LOOP_FDA)
	sudo losetup -d $(LOOP_FDA)
	dd if=$< bs=510 count=1 of=$@ conv=notrunc
	
	

booting : $(BUILD_DIR)/floppy.img
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
	
