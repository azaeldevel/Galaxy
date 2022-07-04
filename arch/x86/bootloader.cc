#include "../../meta/defines.hh"
#include "Bios.hh"

extern "C" void bootloader()
{
	kernel::Bios bios;
	bios.print('I');
	bios.print('n');
	bios.print('i');
	bios.print('c');
	bios.print('i');
	bios.print('a');
	bios.print('n');
	bios.print('d');
	bios.print('o');
	bios.print('.');
	bios.print('.');
	bios.print('.');
	//cheers();
	
	/*asm volatile ("movb $0x0E, %%ah;" : : : "%ah");
	asm volatile ("movb $'I', %%al;" : : : "%al");
	asm volatile ("int $0x10;" );
	
	
	asm volatile ("movb $0x0E, %%ah;" : : : "%ah");
	asm volatile ("movb $'n', %%al;" : : : "%al");
	asm volatile ("int $0x10;" );
	
	
	asm volatile ("movb $0x0E, %%ah;" : : : "%ah");
	asm volatile ("movb $'i', %%al;" : : : "%al");
	asm volatile ("int $0x10;" );*/
}
