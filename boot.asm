; boot.asm
[BITS 16]
[ORG 0x7C00]
;mov ax, 0x07c0
;mov ds, ax
;mov si, msg
;cld

;ch_loop:lodsb
;   or al, al ; zero=end of str
;   jz hang   ; get out
;   mov ah, 0x0E
;   mov bh, 0
;   int 0x10
;   jmp ch_loop

cli ; disable interrupts
xor ax,ax 
mov ds, ax ; set the ds register to the ds descriptor at idx 1

lgdt [gtd_desc] ; load the descriptor table descriptor (base, limit)

; enter protectd mode by setting bit 0 in cr0
mov eax, cr0
or eax, 1
mov cr0, eax

jmp 0x10:clear_pipe

[BITS 32]

clear_pipe:
;jump to the code segment, we are now in 32 bit protected mode




hang: 
	jmp 10h:hang


;visual marker for gdt start
dd 0xdeadbeef
gdt_start:
   ; Set Up the Global Descriptor Table
   ; 32bit protected mode, with overlapping segments (flattened model)
   ; cs - base: 0x0 limit 0xFFFFFFFF
   ; ds - base: 0x0 limit 0xFFFFFFFF
   ; ss - base: 0x0 limit 0xFFFFFFFF
   ;null descriptor
   dq 0

   ;data segment
   dw 0ffffh ; limit 4GB 
   dw 0 ; base
   db 0 ; base 
   ; 15 P 14:13 DPL 12 S 11:8 Type
   db 11110011b
   ; 31:24 base 23 G 22 D/B 21 L 20 AVL 19:16 Seg Limit
   db 11011111b
   db 0 

   ;code segment
   dw 0ffffh ; limit 4GB 
   dw 0 ; base
   db 0 ; base 
   ; 15 P 14:13 DPL 12 S 11:8 Type
   db 11111111b
   ; 31:24 base 23 G 22 D/B 21 L 20 AVL 19:16 Seg Limit
   db 11011111b
   db 0

   ; stack segment 
gdt_end: ; symbol for end of gdt table

;mark table end
dd 0xdeadbeef



gtd_desc: 
   dw gdt_end - gdt_start
   dd gdt_start


msg db "Switching to protected 32bit mode!", 13, 10, 0
times 510-($-$$) db 0 ; 2 bytes less now
db 0x55
db 0xAA
