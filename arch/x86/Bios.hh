

#ifndef OCTETOS_OS_KERNEL_BIOS_HH
#define OCTETOS_OS_KERNEL_BIOS_HH

#include "../../meta/defines.hh"



namespace kernel
{







class Bios
{
public:

public:	
	void outb(uint16 port, uint8 val);
	uint8 inb(uint16 port);
	void interrup(unsigned char service, unsigned char ah,unsigned char al);	
	void print(char);
	void print(const char*);
	
};


}
#endif
