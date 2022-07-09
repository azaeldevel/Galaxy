.code16
.section .data
    
    
.section .text
.global print_string
.type print_string, @function
.globl print_string

print_string:
	lodsb
    orb  %al, %al
	jz   done
	movb $0x0e, %ah
	int  $0x10
	jmp  print_string
	done:
	ret
