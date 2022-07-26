.code16
.section .data
    
    
.section .text
.global print_char
.type print_char, @function


print_char:
	mov %ss, %ax
	mov %al, %al
	mov $0x0e, %ah
	int $0x10	
	ret
