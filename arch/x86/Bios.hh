
#ifndef OCTETOS_OS_KERNEL_BIOS_HH
#define OCTETOS_OS_KERNEL_BIOS_HH

/*
 * Copyright (C) 2022 Azael Reyes Mtz. <azael.devel@gmail.com>
 * All rights reserved
 */

#include "../../meta/defines.hh"


namespace kernel
{

class Bios
{
public:
	void print(char);
	void print(const char*);
	void print_ln(const char*);
	void print_error(const char*);
	void outb(uint16 port, uint8 val);
	uint8 inb(uint16 port);
	bool read_disk(byte length, byte cylinder,byte head,byte sector,byte unit,uint16 load);
	
private:
	inline void interrup(byte service,byte function,byte parameter);
};


}
#endif
