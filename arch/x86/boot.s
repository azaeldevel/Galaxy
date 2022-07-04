.code16 #generate 16-bit code
.text #executable code location
.globl _start;

_start: #code entry point

#print letter 'H' onto the screen
movb $'B' , %al
movb $0x0e, %ah
int  $0x10

#print letter 'e' onto the screen
movb $'o' , %al
movb $0x0e, %ah
int  $0x10

#print letter 'e' onto the screen
movb $'o' , %al
movb $0x0e, %ah
int  $0x10

#print letter 'l' onto the screen
movb $'t' , %al
movb $0x0e, %ah
int  $0x10

#print letter 'l' onto the screen
movb $'i' , %al
movb $0x0e, %ah
int  $0x10

#print letter 'o' onto the screen
movb $'n' , %al
movb $0x0e, %ah
int  $0x10

#print letter ',' onto the screen
movb $'g' , %al
movb $0x0e, %ah
int  $0x10

#print space onto the screen
movb $'.' , %al
movb $0x0e, %ah
int  $0x10

#print space onto the screen
movb $'.' , %al
movb $0x0e, %ah
int  $0x10

#print space onto the screen
movb $'.' , %al
movb $0x0e, %ah
int  $0x10


. = _start + 510 #mov to 510th byte from 0 pos
.byte 0x55 #append boot signature
.byte 0xaa #append boot signature
