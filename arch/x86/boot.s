.code16
.section .text
.global booting
.type booting, @function


booting:	
	xor %ax, %ax
	mov %ax, %ds
	mov %ax, %ss	
	mov $0x8000, %sp
	
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
	
	
	mov $0x02, %ah
	movb 2, %al     
	movb 0, %ch     
	movb 2, %cl
	movb 0, %dh
	movb 0, %dl
	xor %bx, %bx
	mov %bx, %es
	mov 0x8000, %bx
	int $0x13
	jmp 0x8000
		
	ret
