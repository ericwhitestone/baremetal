; boot.asm

mov ax, 0x07c0
mov ds, ax
mov si, msg
cld

ch_loop:lodsb
   or al, al ; zero=end of str
   jz hang   ; get out
   mov ah, 0x0E
   mov bh, 0
   int 0x10
   jmp ch_loop

; Set Up the Global Descriptor Table
; - use a fully segmented memory model, separate data, stack and code segments 
; We will use the multi-segment mode in 32bit protected mode
;
; Segment Descriptors (High Level)
; cs - base: 0x40000000 limit 0x3FFFFFFF (4MB)
; ds - base: 0x80000000 limit 0xFFFFFFFE
; ss - base: 0xC0000000 limit 0xFFFFFFFE
; 
; Segment Descriptors
;  Code Segment
;  Bytes 0-3
;
;  Bytes 4-7
;
;  Data Segment 
;  Bytes 0-3
;
;  Bytes 4-7
;
;  Stack Segment 
;  Bytes 0-3
;
;  Bytes 4-7

; switch to 32bit protected mode
; 
; 
; probaby going to have to load the compiled file from outside the boot sector
; - start out with same floppy and jump to a compiled location on the floppy 
; then update to load from a hard drive 

hang: 
	jmp hang

msg db "Switching to protected 32bit mode!", 13, 10, 0

times 510-($-$$) db 0 ; 2 bytes less now
db 0x55
db 0xAA
