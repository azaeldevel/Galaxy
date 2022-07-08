
__asm__(".code16\n");
__asm__("jmpl $0x0000, $main\n");

#include "Bios.cc"


void main() 
{
     kernel::bios::print("Booting..");
} 
