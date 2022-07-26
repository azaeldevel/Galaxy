

/*
 * Copyright (C) 2022 Azael Reyes Mtz. <azael.devel@gmail.com>
 * All rights reserved
 */
 
#include "Bios.hh"


//typedef void (*loader)();

extern "C" void booting()
{
	kernel::uint16 loader = LOADER_ADDRESS;
	kernel::Bios bios;
	bios.print_ln("Booting...");
	
	//copiando loader desde disco hacia la ram
	if(not	bios.read_disk(1024 * 2/*1024k * 2 = 1M*/,0,1,2,0,0x8000)) bios.print_error("Fallo la descarga del loader...");
	
	//salto hacia el loader
	//loader loading = reinterpret_cast<loader>(LOADER_ADDRESS);
	//loading();
	bios.print_ln("Saltando...");
	asm volatile ("jmp 0x8000;");
}
