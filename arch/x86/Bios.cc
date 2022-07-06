
/*
 * Copyright (C) 2022 Azael R. <azael.devel@gmail.com>
 * All rights reserved
 */

#include "Bios.hh"




namespace kernel
{


void Bios::print(char c)
{
	interrup(0x10,0x0E,c);
}







/*void Bios::print(const char* string)
{
	asm volatile ("mov %[string], %%si;":: [string] "m" (string):"%si");
	asm volatile ("movb 0x0E, %%ah;"	: : :"%ah");
	uint8 i = 0;
	while(string[i])
	{
		asm volatile ("lodsb;":::"%si");
		asm volatile ("int $0x10": : :);
		i++;
	}
}*/
void Bios::print(const char* string)
{
	uint8 i = 0;
	while(string[i])
	{
		print(string[i]);
		i++;
	}
}
void Bios::outb(uint16 port, uint8 val)
{
    asm volatile ( "outb %0, %1" : : "a"(val), "Nd"(port) );
}
uint8 Bios::inb(uint16 port)
{
    uint8 ret;	
    asm volatile ( "inb %1, %0" : "=a"(ret) : "Nd"(port) );
    return ret;
}
void Bios::interrup(kernel::byte service,kernel::byte function,kernel::byte parameter)
{
	asm volatile ("movb %[function], %%ah;": : [function] "g" (function) :"%ah");
	asm volatile ("movb %[parameter], %%al;": : [parameter] "g" (parameter) :"%al");
	asm volatile ("int %[service];": : [service] "g" (service) :);
}

}
