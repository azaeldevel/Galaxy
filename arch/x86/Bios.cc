
#include "Bios.hh"




namespace kernel
{

//https://wiki.osdev.org/Inline_Assembly/Examples



/*void get_cursor_position(uint8& x, uint8& y)
{
    uint16 pos = 0;
    outb(0x3D4, 0x0F);
    pos |= inb(0x3D5);
    outb(0x3D4, 0x0E);
    pos |= ((uint16)inb(0x3D5)) << 8;
    return pos;
}*/

void Bios::outb(uint16 port, uint8 val)
{
    asm volatile ( "outb %0, %1" : : "a"(val), "Nd"(port) );
    /* There's an outb %al, $imm8  encoding, for compile-time constant port numbers that fit in 8b.  (N constraint).
     * Wider immediate constants would be truncated at assemble-time (e.g. "i" constraint).
     * The  outb  %al, %dx  encoding is the only option for all other cases.
     * %1 expands to %dx because  port  is a uint16_t.  %w1 could be used if we had the port number a wider C type */
}
uint8 Bios::inb(uint16 port)
{
    uint8 ret;
    asm volatile ( "inb %1, %0"
                   : "=a"(ret)
                   : "Nd"(port) );
    return ret;
}
void Bios::interrup(unsigned char service, unsigned char function, unsigned char parameter)
{
	asm volatile ("mov %%ah, %[function];" : : [function] "r" (function) : "%ah");
	asm volatile ("mov %%al, %[parameter];" : : [parameter] "r" (parameter) : "%al");
	//asm volatile ("mov %[service], %%bh;" : : [service] "r" (service) : "%bh");
	//asm volatile ("int %[service];" :  : [service] "r"(service) : );
	asm volatile ("int $0x10;" );
	/*asm volatile (
	"mov %[function],%%ah;"
	"mov %[parameter],%%al;"
	"int $10;" 
	: 
	: [function] "r" (function), [parameter] "r" (parameter)
	: 
	"%ah","%al"
	);*/
}
void Bios::print(char c)
{
	interrup(0x10,0x0E,c);
}
void Bios::print(const char* str)
{
	
}

}
