

#ifndef OCTETOS_OS_KERNEL_BIOS_HH
#define OCTETOS_OS_KERNEL_BIOS_HH

#include "../../meta/defines.hh"



namespace kernel
{







class Bios
{
public:
	void print(char);
	void print(const char*);
	
private:
	inline void outb(uint16 port, uint8 val);
	inline uint8 inb(uint16 port);		
	inline void interrup(byte service,byte function,byte parameter);
	
};


}
#endif
