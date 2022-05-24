
#include "Bios.hh"


namespace kernel
{

void Bios::interrup(unsigned char service, unsigned char function, unsigned char parameter)
{
	asm volatile ("mov %%ah, %[function];" : : [function] "r" (function) : "%ah");
	asm volatile ("mov %%al, %[parameter];" : : [parameter] "r" (parameter) : "%al");
	//asm volatile ("mov %[service], %%bh;" : : [service] "r" (service) : "%bh");
	//asm volatile ("int %[service];" :  : [service] "r"(service) : );
	asm volatile ("int $10;" );
}
void Bios::print(char c)
{
	interrup(0x10,0x0E,c);
}


}
