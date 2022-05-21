
#ifndef GALAXY_KERNEL_VIDEO_HH
#define GALAXY_KERNEL_VIDEO_HH

#include "defines.hh"

namespace kernel
{

class Video
{

public:

};

class VGA
{
public:
	enum Colors 
	{
		BLACK,
		BLUE,
		GREEN,
		CYAN,
		RED,
		MAGENTA,
		BROWN,
		GREY,
		DARK_GREY,
		BRIGHT_BLUE,
		BRIGHT_GREEN,
		BRIGHT_CYAN,
		BRIGHT_RED,
		BRIGHT_MAGENTA,
		YELLOW,
		WHITE,
	};
	struct Cell
	{
		uint16 letter : 8, forecolor : 4, backcolor : 4; 
	};
public:
	VGA();
	VGA(uint8 forecolor,uint8 backcolor);
	
	uint16& word(uint16);
	Cell& cell(uint16);
	
	void write(const char*);
	
	void clear(uint8 forecolor, uint8 backcolor);	
	static uint16 convert(unsigned char ch, uint8 forecolor, uint8 backcolor);
	
private:
	static uint16* vga_addres;
	static Cell* vga_addres_cells;
	static const uint16 vga_zise;
};

}

#endif
