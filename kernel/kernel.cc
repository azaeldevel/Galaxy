#include "kernel.hh"
#include "../x86/VGA.hh"

extern "C" void kernel_entry()
{
  	kernel::VGA video(kernel::VGA::BLACK,kernel::VGA::WHITE);
  	
  	video.print("0123456789");
  	/*video.print("          ");
  	video.print("0123456789");
  	video.print("          ");
  	video.print("0123456789");
  	video.print("          ");*/
}
