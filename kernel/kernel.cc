#include "kernel.hh"
#include "video.hh"

extern "C" void kernel_entry()
{
  	kernel::VGA video(kernel::VGA::BLACK,kernel::VGA::BLUE);
  	
  	/*video.cell(0).letter = 'H';
  	video.cell(1).letter = 'e';
  	video.cell(2).letter = 'l';
  	video.cell(3).letter = 'l';
  	video.cell(4).letter = 'o';*/
  	video.write("Hello world...");
}
