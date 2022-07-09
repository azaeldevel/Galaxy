.code16
.section .data
    msg: .asciz "Booting.."
    
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
	
	call print_char 
	
	ret
