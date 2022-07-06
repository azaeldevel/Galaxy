

/*
 * Copyright (C) 2022 Azael R. <azael.devel@gmail.com>
 * All rights reserved
 */
 
 
#include "Bios.hh"

extern "C" void booting()
{
	kernel::Bios bios;
	/*bios.print('B');
	bios.print('o');
	bios.print('o');
	bios.print('t');
	bios.print('i');
	bios.print('n');
	bios.print('g');
	bios.print('.');
	bios.print('.');
	bios.print('.');*/
	bios.print("Booting...");
}
