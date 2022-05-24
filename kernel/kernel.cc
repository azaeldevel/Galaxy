#include "kernel.hh"
#include "../x86/Bios.hh"

extern "C" void kernel_entry()
{
  	kernel::Bios bios;
  	
  	bios.print('A');
  	bios.print('A');
  	bios.print('A');
  	bios.print('A');
}
