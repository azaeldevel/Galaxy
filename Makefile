
boot.o : boot.s
	as --32 boot.s -o boot.o

kernel.o : kernel.c
	gcc -m32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

kernel : linker.ld kernel.o boot.o
	ld -m elf_i386 -T linker.ld kernel.o boot.o -o kernel -nostdlib
	grub-file --is-x86-multiboot kernel

Meta-SO.iso : kernel
	mkdir -p isodir/boot/grub
	cp kernel isodir/boot/kernel
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o Meta-SO.iso isodir

run : Meta-SO.iso
	qemu-system-x86_64 -cdrom Meta-SO.iso

.PHONY:  clean

clean :
	rm *.o
	rm *.iso
	rm kernel
	rm -r isodir
