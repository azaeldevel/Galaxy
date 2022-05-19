 ifndef  BUILD
 BUILD=build
 endif

$(BUILD)/boot.o : x86/boot.s
	as --32 x86/boot.s -o $(BUILD)/boot.o

$(BUILD)/kernel.o : kernel/kernel.cc
	gcc -m32 -c kernel/kernel.cc -o $(BUILD)/kernel.o -ffreestanding -O2 -Wall -Wextra

$(BUILD)/kernel : linker.ld $(BUILD)/kernel.o $(BUILD)/boot.o
	ld -m elf_i386 -T linker.ld $(BUILD)/kernel.o $(BUILD)/boot.o -o $(BUILD)/kernel -nostdlib
	grub-file --is-x86-multiboot $(BUILD)/kernel

$(BUILD)/Meta-SO.iso : $(BUILD)/kernel
	mkdir -p $(BUILD)/isodir/boot/grub
	cp $(BUILD)/kernel $(BUILD)/isodir/boot/
	cp grub.cfg $(BUILD)/isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(BUILD)/Meta-SO.iso $(BUILD)/isodir

run : $(BUILD)/Meta-SO.iso
	qemu-system-x86_64 -cdrom $(BUILD)/Meta-SO.iso

.PHONY:  clean

clean :
	rm -r $(BUILD)/*
