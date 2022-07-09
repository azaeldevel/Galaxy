.code16
.section .data
    
.section .text
.global booting
.type booting, @function
.globl booting;

booting:
	movb $'B' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'o' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'o' , %al
	movb $0x0e, %ah
	int  $0x10
	
	movb $'t' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'i' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'n' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'g' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'.' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'.' , %al
	movb $0x0e, %ah
	int  $0x10
	
. = booting + 510
.byte 0x55
.byte 0xaa 
