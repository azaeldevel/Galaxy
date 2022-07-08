.code16 #generate 16-bit code
.text #executable code location
.globl print_char;

print_char:
	int  $0x10
	ret
