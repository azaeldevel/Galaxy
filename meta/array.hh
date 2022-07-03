


#ifndef OCTETOS_OS_ARRAY_HH
#define OCTETOS_OS_ARRAY_HH

/*
 * Copyright (C) 2022 Azael R. <azael.devel@gmail.com>
 *
 * octetos-os is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * octetos-os is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "defines.hh"
#include <concepts>

namespace kernel
{

template <typename I> concept Index = std::unsigned_integral<I>;

template <typename S> concept Data = requires (S data,S comp)
{
	data < comp;
	data > comp;
	data == comp;
	std::default_initializable<S>;
};


template <Data S, Index I = unsigned int> class Array
{
public:
	S& operator [](I index)
	{
		return block[index];
	}
	const S& operator [](I index) const
	{
		return block[index];
	}

private:
	S[MEMORY_INPUTS] block;
};

}

#endif
