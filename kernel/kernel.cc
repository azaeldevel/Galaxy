#include "kernel.hh"
#include "../arch/x86/VGA.hh"
//#include "../arch/x86/Bios.hh"

extern "C" void kernel_entry()
{
	kernel::VGA vga;
	vga.print("OS iniciando..");
	
  	//kernel::Bios bios;
  	//bios.print("Loading BIOS funtion..");
  	/*bios.print('A');
  	bios.print('A');
  	bios.print('A');
  	bios.print('A');*/
}
