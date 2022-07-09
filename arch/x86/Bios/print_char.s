.code16

print_char:
	movb $'X' , %al
	movb $0x0e, %ah
	int  $0x10	
	ret
