
#include "Bios.hh"

extern "C" void booting()
{
	kernel::Bios bios;
	bios.print('B');
	bios.print('o');
	bios.print('o');
	bios.print('t');
	bios.print('i');
	bios.print('n');
	bios.print('g');
	bios.print('.');
	bios.print('.');
	bios.print('.');
	
}
