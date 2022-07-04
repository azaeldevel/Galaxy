
//extern "C" void bios_interrup(unsigned char service,unsigned char function, unsigned char parameter);
extern "C" void cheers();


/*extern "C" void print(char c)
{
	bios_interrup((unsigned char)0x10,(unsigned char)0x0E,c);
}*/


extern "C" void bootloader(void)
{
	/*print('I');
	print('n');
	print('i');
	print('c');
	print('i');
	print('a');
	print('n');
	print('d');
	print('o');
	print('.');
	print('.');*/
	cheers();
	
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
