
#ifndef OCTETOS_OS_KERNEL_DISK_HH
#define OCTETOS_OS_KERNEL_DISK_HH

/*
 * Copyright (C) 2022 Azael Reyes Mtz. <azael.devel@gmail.com>
 * All rights reserved
 */

#include "Bios.hh"

namespace kernel
{

enum class Unit : unsigned char
{
	
};

class Disk
{
public:
	byte read(byte length, byte cylinder,byte head,byte sector,byte unit,uint16 load);
	
private:
	Bios bios;
};


}
#endif
