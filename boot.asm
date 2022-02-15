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


segment_descriptors:
; Set Up the Global Descriptor Table
; - use a fully segmented memory model, separate data, stack and code segments 
; We will use the multi-segment mode in 32bit protected mode
;
; Segment Descriptors (High Level)
; cs - base: 0x40000000 limit 0x0FFFFF(1MB)
; ds - base: 0x40100000 limit 0x0FFFFF
; ss - base: 0xC0200000 limit 0x0FFFFF
; 
; Segment Descriptors
;
;  Code Segment
dw 0
dw 0xFFFF ; Limit 15:0 | Base addr 15:0
db       ; base 23:16 
db       ; P 15 | DPL 14:13 | S type 8:11 
db       ; G 23 | D/B 22 | L 21 | AVL 20 | Limit 19:16
db       ; base 31:24
db 0x40  ; Base addr 31:24 0100 0000 

;  Data Segment 
;
;  Stack Segment 

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
