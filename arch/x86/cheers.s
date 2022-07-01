# https://stackoverflow.com/questions/13901261/calling-assembly-function-from-c
.section .data
    string: .ascii  "Hello from assembler.."
    length: .quad   . - string

.section .text
.global cheers
.type cheers, @function

cheers:
	mov $0xB8000, %edi
	
	mov $'I', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'n', (%edi)
	inc %edi
	mov $15, (%edi)
		
	inc %edi
	mov $'i', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'c', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'i', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'a', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'n', (%edi)
	inc %edi
	mov $15, (%edi)
		
	inc %edi
	mov $'d', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'o', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'.', (%edi)
	inc %edi
	mov $15, (%edi)
	
	inc %edi
	mov $'.', (%edi)
	inc %edi
	mov $15, (%edi)
	
	ret
