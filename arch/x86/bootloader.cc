#include "../../meta/defines.hh"

extern "C" inline void bios_interrup(kernel::byte service,kernel::byte function,kernel::byte parameter)
{
	asm volatile ("movb %[function], %%ah;"
				: 
				: [function] "g" (function) 
				:"%ah");
	asm volatile ("movb %[parameter], %%al;"
				: 
				: [parameter] "g" (parameter) 
				:"%al");
	asm volatile ("int %[service];"
				: 
				: [service] "g" (service) 
				:"%ah","%al");
}

extern "C" void cheers();


extern "C" inline void print(char c)
{
	bios_interrup(0x10,0x0E,c);
}


extern "C" void bootloader(void)
{
	print('I');
	print('n');
	print('i');
	print('c');
	print('i');
	print('a');
	print('n');
	print('d');
	print('o');
	print('.');
	print('.');
	print('.');
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
