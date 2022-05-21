#include "kernel.hh"
#include "video.hh"

extern "C" void kernel_entry()
{
  	kernel::VGA video(kernel::VGA::BLACK,kernel::VGA::WHITE);
  	
  	video.write("iniciando...");
}
