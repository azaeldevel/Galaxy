
#include "memory.hh"

namespace kernel
{


unsigned char Segment::operator[](Index i)
{
	unsigned char* byte = reinterpret_cast<unsigned char*>(this);//page 0;	
	return byte[i];
}



Segment& Page::operator[](Index i)
{
	return *(Segment*)((Word)this + (i * PAGE_SIZE));
}


Page& Book::operator[](Index i)
{
	return *(Page*)((Word)this + (i * PAGE_SIZE));
}





Memory::Memory(void* b,void* e,Word bks) : begin(b),end(e),books(bks)
{
	size = ((Word)e - (Word)b) / books;
}

Book& Memory::operator[](Index i)
{
	return *(Book*)((Word)begin + (i * size));
}

}
