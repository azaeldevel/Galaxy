.code16
.section .data
    
.section .text
.global loading
.type loading, @function
.globl loading;

loading:
	movb $'B' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'o' , %al
	movb $0x0e, %ah
	int  $0x10

	movb $'o' , %al
	movb $0x0e, %ah
	int  $0x10
