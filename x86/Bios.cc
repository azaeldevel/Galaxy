
#include "Bios.hh"


namespace kernel
{

void Bios::interrup(unsigned char service, unsigned char ah,unsigned char al)
{
	
}
void Bios::print(char c)
{
	interrup(0x10,0x0E, c);
}


}
