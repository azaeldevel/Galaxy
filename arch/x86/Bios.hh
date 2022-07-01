

#ifndef OCTETOS_OS_KERNEL_BIOS_HH
#define OCTETOS_OS_KERNEL_BIOS_HH

#include "../../kernel/defines.hh"

namespace kernel
{
class Bios
{
public:

public:	
	void interrup(unsigned char service, unsigned char ah,unsigned char al);	
	void print(char);
	void print(const char*);
	
};

}
#endif
