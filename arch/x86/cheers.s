# https://stackoverflow.com/questions/13901261/calling-assembly-function-from-c
.section .data
    
.section .text
.global cheers
.type cheers, @function

cheers:
	mov $0xB8000, %edi
	
	movb $'I', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'n', (%edi)
	inc %edi
	movb $15, (%edi)
		
	inc %edi
	movb $'i', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'c', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'i', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'a', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'n', (%edi)
	inc %edi
	movb $15, (%edi)
		
	inc %edi
	movb $'d', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'o', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'.', (%edi)
	inc %edi
	movb $15, (%edi)
	
	inc %edi
	movb $'.', (%edi)
	inc %edi
	movb $15, (%edi)
	
	ret
