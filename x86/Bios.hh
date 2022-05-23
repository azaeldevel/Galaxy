

#ifndef OCTETOS_OS_KERNEL_BIOS_HH
#define OCTETOS_OS_KERNEL_BIOS_HH

namespace kernel
{
class Bios
{
public:
	struct Video
	{
		static const unsigned char PRINT_CHAR = 0x0E;
	};
public:
	Bios();
	
	void interrup(unsigned char service, unsigned char ah,unsigned char al);
	
	void print(char);
};

}
#endif
