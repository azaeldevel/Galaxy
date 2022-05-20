
#ifndef GALAXY_KERNEL_VIDEO_HH
#define GALAXY_KERNEL_VIDEO_HH

#include "defines.hh"

namespace kernel
{

class Video
{

public:

};

class VGA : public Video
{

public:
	
private:
	static const unsigned short* vga_addres;
	static const unsigned short vga_zise;
};

}

#endif
