     .macro mWriteString str              #macro which calls a function to print a string
          leaw  \str, %si
          call .writeStringIn
     .endm

     #function to print the string
     .writeStringIn:
          lodsb
          orb  %al, %al
          jz   .writeStringOut
          movb $0x0e, %ah
          int  $0x10
          jmp  .writeStringIn
     .writeStringOut:
     ret
