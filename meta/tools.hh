
#ifndef OCTETOS_OS_TOOLS_HH
#define OCTETOS_OS_TOOLS_HH

#include "defines.hh"

namespace kernel
{



struct Bits
{
	unsigned char b0 : 1, b1 : 1, b2 : 1, b3 : 1, b4 : 1, b5 : 1, b6 : 1, b7 : 1;
};

template<typename T>
class BitsData
{
public:
	BitsData(const T& d) : datas(reinterpret_cast<const Bits*>(&d))
	{	
	}
	
	const Bits& operator[](Index i)const
	{
		return datas[i];
	}
	
private:
	const Bits* datas;
};



template<typename T>
class String
{
public:
	String(signed char)
	{
		
	}
	String(unsigned char)
	{
	
	}
	
	
	
private:
	T* string;
};

}

#endif
