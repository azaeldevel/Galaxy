# https://stackoverflow.com/questions/13901261/calling-assembly-function-from-c
.section .data
    
.section .text
.global cheers
.type cheers, @function

cheers:
		
	movb $0x0E, %ah
	movb $'I' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'n' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'i' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'c' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'i' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'a' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'n' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'d' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'o' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'.' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'.' , %al
	int  $0x10
		
	movb $0x0E, %ah
	movb $'.' , %al
	int  $0x10
	
	ret
