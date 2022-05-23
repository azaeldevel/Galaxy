
#ifndef OCTETOS_OS_KERNEL_VIDEO_HH
#define OCTETOS_OS_KERNEL_VIDEO_HH

#include "defines.hh"

namespace kernel
{

class Video
{
public:
	virtual void print(const char*) = 0;
};

}

#endif
