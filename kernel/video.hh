
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
	enum colors 
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
public:
	VGA();
	VGA(uint8 fore_color,uint8 back_color);
	
	uint16& get(uint16);
	
	void clear(uint8 fore_color, uint8 back_color);
	
	
	static uint16 convert(unsigned char ch, uint8 fore_color, uint8 back_color);
	
private:
	static uint16* vga_addres;
	static const uint16 vga_zise;
};

}

#endif
