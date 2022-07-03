#ifndef OCTETOS_OS_LIST_HH
#define OCTETOS_OS_LIST_HH

namespace kernel
{

template<typename T>
class Node
{

public:
	T* prev;
	T* next;
};

template<typename T>
class List
{

public:
	Node<T>* begin;
	Node<T>* end;
};

}


#endif
