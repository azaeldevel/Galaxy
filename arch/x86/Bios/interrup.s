# https://stackoverflow.com/questions/13901261/calling-assembly-function-from-c
.section .data
    
.section .text
.global cheers
.type bios_interrup, @function

bios_interrup:
	mov (%sp), %al;		
	movb $0x0E, %ah;
	int $0x10;	
	ret
