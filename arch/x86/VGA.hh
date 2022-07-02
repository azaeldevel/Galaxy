
#ifndef OCTETOS_OS_KERNEL_VGA_HH
#define OCTETOS_OS_KERNEL_VGA_HH

#include "Bios.hh"
#include "../../kernel/Video.hh"

namespace kernel
{

class VGA : protected Bios
{
public:
	enum Colors : unsigned char
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
	
	virtual void write(char);
	virtual void print(char);
	virtual void print(const char*);
	virtual void print(unsigned char);
	virtual void print(signed char);
	virtual void new_line();
	
	void clear(uint8 forecolor, uint8 backcolor);	
	static uint16 convert(unsigned char ch, uint8 forecolor, uint8 backcolor);
	
	void disable_cursor();
	void get_cursor_position(uint8& x, uint8& y);
	void enable_cursor(uint8 cursor_start, uint8 cursor_end);
	void update_cursor(uint8 x, uint8 y);
	uint8 get_width();
	uint8 get_height();
	
private:
	static uint16* vga_addres;
	static Cell* vga_addres_cells;
	static const uint16 vga_zise;
	uint8 x,y,fc,bc;
	Cell* video_memory;
	
};

}

#endif
