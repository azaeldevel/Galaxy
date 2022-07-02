#include "kernel.hh"
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
  	vga.print("Iniciando..");
  	
  	//vga.get_cursor_position(vx,vy);
  	//vga.print((char)vga.get_width());
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
}
