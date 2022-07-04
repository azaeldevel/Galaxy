

/*void print(char c)
{
	asm volatile ("movb $0x0e, %%ah;" : : : "%ah");
	asm volatile ("movb %[c], %%al;" : : [c] "r" (c) : "%al");
	asm volatile ("int $0x10;" );
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
	char* textBuffer = reinterpret_cast<char*>(0xB8000);
	textBuffer[0] = 'I';
	textBuffer[1] = (char)0x01;
}
