#include "kernel.hh"
#include "../meta/memory.hh"
#include "../arch/x86/VGA.hh"
#include "../arch/x86/Bios.hh"

//extern "C" void cheers(void);

extern "C" void kernel_entry()
{
	
	kernel::VGA vga(kernel::VGA::Colors::WHITE,kernel::VGA::Colors::BLUE);
	
  	//bios.print("Loading BIOS funtion..");
  	/*bios.print('A');
  	bios.print('A');
  	bios.print('A');
  	bios.print('A');
  	*/
  	
  	//vga.disable_cursor();
  	vga.print("Iniciando..\n");
  	/*vga.print("Iniciando..\n");
  	vga.print("Iniciando..\n");
  	vga.print("Iniciando..\n");*/
  	
  	//vga.get_cursor_position(vx,vy);
  	vga.print((kernel::uint8)vga.get_width());
  	//cheers();
  	/*vga.print('I');
  	vga.print('n');
  	vga.print('i');
  	vga.print('c');
  	vga.print('i');
  	vga.print('a');
  	vga.print('n');
  	vga.print('d');
  	vga.print('o');
  	vga.print('.');
  	vga.print('.');*/
  	vga.new_line();
  	vga.print((unsigned char)73);
  	vga.new_line();
  	vga.print((signed char)-73);
  	vga.new_line();
  	vga.print((unsigned char)128);
  	vga.new_line();
  	vga.print((unsigned char)129);
  	vga.new_line();
  	vga.print((unsigned short)513);
  	
  	kernel::Memory memory((void*)0x09FFF0000, (void*) 0x09FFF0000 + 0x0F0000000,3);
}
