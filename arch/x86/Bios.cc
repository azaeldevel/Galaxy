
/*
 * Copyright (C) 2022 Azael Reyes Mtz. <azael.devel@gmail.com>
 * All rights reserved
 */

#include "Bios.hh"




namespace kernel
{


void Bios::print(char c)
{
	interrup(0x10,0x0E,c);
}
void Bios::print(const char* string)
{
	uint8 i = 0;
	while(string[i])
	{
		print(string[i]);
		i++;
	}
}
void Bios::print_ln(const char* string)
{
	uint8 i = 0;
	while(string[i])
	{
		print(string[i]);
		i++;
	}
	print('\n');
	print('\r');
}
void Bios::print_error(const char* string)
{
	print_ln(string);
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
bool Bios::read_disk(byte length, byte cylinder,byte head,byte sector,byte unit,uint16 load)
{
	bool status;
	asm volatile ("movb 0x02, %%ah;": ::"%ah");
	asm volatile ("movb %[length], %%al;": : [length] "g" (length) :"%al");
	asm volatile ("movb %[cylinder], %%ch;": : [cylinder] "g" (cylinder) :"%ch");
	asm volatile ("movb %[sector], %%cl;": : [sector] "g" (sector) :"%cl");
	asm volatile ("movb %[head], %%dh;": : [head] "g" (head) :"%dh");
	asm volatile ("movb %[unit], %%dl;": : [unit] "g" (unit) :"%dl");
	asm volatile ("mov %[load], %%bx;": : [load] "g" (load) :"%bx");
	asm volatile ("int $0x13;": : :);
	
	asm volatile ("movb %%ah, %[status]" : [status]  "=g"(status) : );	
	if(not status) return true;
	
	return false;
}












void Bios::interrup(kernel::byte service,kernel::byte function,kernel::byte parameter)
{
	asm volatile ("movb %[function], %%ah;": : [function] "g" (function) :"%ah");
	asm volatile ("movb %[parameter], %%al;": : [parameter] "g" (parameter) :"%al");
	asm volatile ("int %[service];": : [service] "g" (service) :);
}

}
