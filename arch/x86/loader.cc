
/*
 * Copyright (C) 2022 Azael R. <azael.devel@gmail.com>
 * All rights reserved
 */
 
#include "Bios.hh"

extern "C" void loading()
{
	kernel::Bios bios;
	bios.print('L');
	bios.print('o');
	bios.print('a');
	bios.print('d');
	bios.print('i');
	bios.print('n');
	bios.print('g');
	bios.print('.');
	bios.print('.');
	bios.print('.');
	
}
