[ORG 0x7c00]
 
   xor ax, ax ; make it zero
   mov ds, ax
 
   mov si, msg
   cld
next:
	lodsb
   	or al, al
   	jz done
   	mov ah, 0x0E
   	mov bh, 0
   	int 0x10
   	jmp next
done:
   jmp done
   
   
msg   db 'Booting..', 13, 10, 0
 
   times 510-($-$$) db 0
   db 0x55
   db 0xAA
