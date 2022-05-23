#include "kernel.hh"
#include "VGA.hh"

extern "C" void kernel_entry()
{
  	kernel::VGA video(kernel::VGA::BLACK,kernel::VGA::WHITE);
  	
  	video.print("iniciando...");
}
