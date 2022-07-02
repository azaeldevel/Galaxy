
#include "../../meta/tools.hh"
#include "VGA.hh"


namespace kernel
{



//VGA
/*
https://wiki.osdev.org/VGA_Hardware
16 bit video buffer elements
8 bits(ah) higher : 
  lower 4 bits - forec olor
  higher 4 bits - back color

8 bits(al) lower :
  8 bits : ASCII character to print
*/


uint16* VGA::vga_addres = (uint16*)0xB8000;//hasta C7FFF
VGA::Cell* VGA::vga_addres_cells = (VGA::Cell*)0xB8000;
const uint16 VGA::vga_zise = 2200;
uint8 VGA::TAB_SIZE = 4;

VGA::VGA() : x(0),y(0),video_memory((VGA::Cell*)0xB8000)
{
	
}
VGA::VGA(uint8 f,uint8 b) : fc(f), bc(b),video_memory((VGA::Cell*)0xB8000)
{
	clear(f,b);
}

uint16& VGA::word(uint16 i)
{
	return vga_addres[i];
}
VGA::Cell& VGA::cell(uint16 i)
{
	return vga_addres_cells[i];
}
void VGA::clear(uint8 fc, uint8 bc)
{
	Cell cell;	
	cell.forecolor = fc;
	cell.backcolor = bc;
	cell.letter = 0;
	for(uint16 i = 0; i < vga_zise; i++)
	{
		vga_addres_cells[i] = cell;
	}
}
uint16 VGA::convert(unsigned char ch, uint8 fc, uint8 bc)
{
	uint16 ax = 0;
  	uint8 ah = 0, al = 0;

  	ah = bc;
  	ah <<= 4;
  	ah |= fc;
  	ax = ah;
  	ax <<= 8;
  	al = ch;
  	ax |= al;

  	return ax;
}
void VGA::write(char c)
{
	if(c >= 0x20 and c <= 0x7e)
	{
		if(x < get_width())
		{
			video_memory[(y * get_width()) + x].letter = c;
			x++;
		}
		else
		{
			x = 0;
			y++;
			video_memory[(y * get_width()) + x].letter = c;
		}
	}
	else if (c == '\n')
	{
		x = 0;
		y++;
	}
	else if (c == '\t')
	{
		x += TAB_SIZE;
	}
}
void VGA::print(char c)
{
	write(c);
	update_cursor(x,y);
}

void VGA::print(const char* str)
{
	uint16 i = 0;
	while(str[i] != '\0')
	{
		print(str[i]);
		i++;
	}
	update_cursor(x,y);
}

void VGA::print(unsigned char number)
{
	const Bits* bits = reinterpret_cast<const Bits*>(&number);
	if(bits->b7)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b6)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b5)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b4)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b3)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b2)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b1)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b0)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	update_cursor(x,y);
}
void VGA::print(signed char number)
{	
	const Bits* bits = reinterpret_cast<const Bits*>(&number);
	if(bits->b7)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b6)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b5)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b4)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b3)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b2)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b1)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	if(bits->b0)
	{
		write('1');
	}
	else
	{
		write('0');
	}
	
	update_cursor(x,y);
}
void VGA::print(signed short n)
{
	unsigned char* number = (unsigned char*)&n;
	print(number[1]);
	print(number[0]);
}
void VGA::print(unsigned short n)
{
	unsigned char* number = (unsigned char*)&n;
	print(number[1]);
	print(number[0]);
}
void VGA::new_line()
{
	x = 0;
	y++;
	update_cursor(x,y);
}

void VGA::disable_cursor()
{
	outb(0x3D4, 0x0A);
	outb(0x3D5, 0x20);
}
void VGA::enable_cursor(uint8 cursor_start, uint8 cursor_end)
{
	outb(0x3D4, 0x0A);
	outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);
 
	outb(0x3D4, 0x0B);
	outb(0x3D5, (inb(0x3D5) & 0xE0) | cursor_end);
}
void VGA::get_cursor_position(uint8& x, uint8& y)
{
    outb(0x3D4, 0x0F);
    x = inb(0x3D5);
    outb(0x3D4, 0x0E);
    y = inb(0x3D5);
}
uint8 VGA::get_width()
{
	outb(0x3D4, 0x00);
    return inb(0x3D5);
}
uint8 VGA::get_height()
{
	outb(0x3D4, 0x06);
    return inb(0x3D5);
}
void VGA::update_cursor(uint8 x, uint8 y)
{
	uint16 pos = y * get_width() + x;
 
	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8) (pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8) ((pos >> 8) & 0xFF));
}
}
