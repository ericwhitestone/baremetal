; boot.asm
[BITS 16]
[ORG 0x7C00]
;mov ax, 0x07c0
;mov ds, ax
;mov si, msg
;cld

ch_loop:lodsb
   or al, al ; zero=end of str
   jz hang   ; get out
   mov ah, 0x0E
   mov bh, 0
   int 0x10
   jmp ch_loop


gdt_start:
   ; Set Up the Global Descriptor Table
   ; 32bit protected mode, with overlapping segments (flattened model)
   ; cs - base: 0x0 limit 0xFFFFFFFF
   ; ds - base: 0x0 limit 0xFFFFFFFF
   ; ss - base: 0x0 limit 0xFFFFFFFF
   ;null descriptor
   dq 0
   ;code segment
   dw FFFFh ; limit 4GB 
   dw 0 ; base
   db 0 ; base 
   ; 15 P 14:13 DPL 12 S 11:8 Type
   db 11111111b
   ; 31:24 base 23 G 22 D/B 21 L 20 AVL 19:16 Seg Limit
   db 11011111b
gdt_end ; symbol for end of gdt table

gtd_desc: 
   db gdt_end - gdt_start
   dw gdt_start

cli

;;;;;;;;;;;
; Segment Descriptors (High Level)
; cs - base: 0x4000_0000 limit 0x0FFFFF(1MB)
; ds - base: 0x4010_0000 limit 0x0FFFFF
; ss - base: 0xC020_0000 limit 0x0FFFFF
; 


; old, segmented model
; Segment Descriptors
;
;  Code Segment
;dw 0
;dw 0xFFFF ; Limit 15:0 | Base addr 15:0
;#db       ; base 23:16 
;db       ; P 15 | DPL 14:13 | S type 8:11 
;db       ; G 23 | D/B 22 | L 21 | AVL 20 | Limit 19:16
;db       ; base 31:24
;db 0x40  ; Base addr 31:24 0100 0000 
;;;;;;;;

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
