
/*
 * Copyright (C) 2022 Azael Reyes Mtz. <azael.devel@gmail.com>
 * All rights reserved
 */

namespace kernel::bios
{


inline void interrup(unsigned char service,unsigned char function,unsigned char parameter)
{
	asm volatile ("movb %[function], %%ah;": : [function] "g" (function) :"%ah");
	asm volatile ("movb %[parameter], %%al;": : [parameter] "g" (parameter) :"%al");
	asm volatile ("int %[service];": : [service] "g" (service) :);
}




inline void print(char c)
{
	interrup(0x10,0x0E,c);
}
inline void print(const char* string)
{
     while(*string) 
     {
          print(*string);
          ++string;
     }
}
inline void print_ln(const char* string)
{
	print(string);
	print('\n');
	print('\r');
}
inline void print_error(const char* string)
{
	print_ln(string);
}
inline void outb(unsigned short port, unsigned char val)
{
    asm volatile ( "outb %0, %1" : : "a"(val), "Nd"(port) );
}
inline unsigned char inb(unsigned short port)
{
    unsigned char ret;	
    asm volatile ( "inb %1, %0" : "=a"(ret) : "Nd"(port) );
    return ret;
}
inline bool read_disk(unsigned char length, unsigned char cylinder,unsigned char head,unsigned char sector,unsigned char unit,unsigned short load)
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








}
