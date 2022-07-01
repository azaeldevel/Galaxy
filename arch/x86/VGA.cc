
#include "VGA.hh"


namespace kernel
{



//VGA
/*
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

VGA::VGA()
{
}
VGA::VGA(uint8 fc,uint8 bc)
{
	clear(fc,bc);
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

void VGA::print(const char* str)
{
	uint16 i = 0;
	while(str[i] != '\0')
	{
		vga_addres_cells[i].letter = str[i];
		i++;
	}
}
void VGA::print(uint8 val)
{
	
}
void VGA::new_line()
{
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
void VGA::update_cursor(uint8 x, uint8 y)
{
	uint16 pos = y * width + x;
 
	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8) (pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8) ((pos >> 8) & 0xFF));
}
}
