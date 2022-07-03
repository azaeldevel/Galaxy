
#ifndef OCTETOS_OS_MEMORY_HH
#define OCTETOS_OS_MEMORY_HH

#include "defines.hh"

namespace kernel
{

class Segment
{

public:
	unsigned char operator[](Index i);
	
private:
	
};

class Page
{

public:
	Segment& operator[](Index i);
private:

};

class Book
{
private:
	
public:
	Book();
	Page& operator[](Index i);
	
};

class Memory 
{

public:
	Memory(void* begin,void* end,Word books);
	
	Book& operator[](Index i);
	
private:
	void* begin;
	void* end;
	Word books;
	Word size;
};

/*class Memory
{
public:
	void* get_memory();
	bool is_free()const;
	bool is_alloc()const;

private:
	Word size;
	void* location;
};*/

}


#endif
