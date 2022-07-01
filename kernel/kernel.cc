#include "kernel.hh"
#include "../arch/x86/VGA.hh"
#include "../arch/x86/Bios.hh"

//extern "C" void cheers(void);

extern "C" void kernel_entry()
{
	
	kernel::VGA vga;
	
  	//bios.print("Loading BIOS funtion..");
  	/*bios.print('A');
  	bios.print('A');
  	bios.print('A');
  	bios.print('A');
  	*/
  	
  	vga.disable_cursor();
  	vga.print("Iniciando..");
  	
  	uint8 vx,vy;
  	vga.get_cursor_position(vx,vy);
  	vga.print(vx);
  	//cheers();
}
