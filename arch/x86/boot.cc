
__asm__(".code16\n");
__asm__("jmpl $0x0000, $main\n");

#include "Bios.cc"


void main() 
{
     kernel::bios::print_ln("Booting..");
     if(not	kernel::bios::read_disk(128/*1024k * 2 = 1M*/,0,1,2,0,0x8000)) kernel::bios::print_error("Fallo la descarga del loader...");
     
     //asm volatile ("jmp 0x8000;": ::);
} 
