

void print(char c)
{
	asm volatile ("movb $0x0e, %%ah;" : : : "%ah");
	asm volatile ("movb %[c], %%al;" : : [c] "r" (c) : "%al");
	asm volatile ("int $0x10;" );
}



void bootloader(void)
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
}
