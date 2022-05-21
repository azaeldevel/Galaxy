
#include "video.hh"


namespace kernel
{



//VGA
uint16* VGA::vga_addres = (uint16*)0xB8000;
VGA::Cell* VGA::vga_addres_cells = (VGA::Cell*)0xB8000;
const uint16 VGA::vga_zise = 2200;

VGA::VGA()
{
	//clear(WHITE, BLACK);
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

}
