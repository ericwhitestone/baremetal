; boot.asm


; Register componets for reference:
; [31:0]    [15:8]   [7:0]
; EAX       AH       AL
; EBX       BH       BL
; ECX       CH       CL
; EDX       DH       DL

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
mov ds, ax ; set the ds register to 0 - not sure why yet

lgdt [gdt_desc] ; load the descriptor table descriptor (base, limit)

; Use BIOS routines for loading the second 
; stage loader before entering protected mdoe
mov ah, 0x8
mov dl, 0x80
int 13h

; enter protectd mode by setting bit 0 in cr0
mov eax, cr0
or eax, 1
mov cr0, eax
jmp 0x10: dword clear_pipe ; set code segment selector to idx 2
                           ; dword required, nasm docs describe that it allows
                           ; the jump instruction to be encoded as a 32 instruction 
                           ; since we're now in protected mode



clear_pipe:
[BITS 32]
   mov eax, 0x08 ; offset 8 is 1 segment descriptor
   mov ds, eax ; set data segment selector to idx 1 
   mov ss, eax ; set stack segment selector to idx 1
   mov eax, 0
   mov es,  eax
   mov fs, eax
   mov gs, eax

    jmp clear_pipe 

;jump to the code segment, we are now in 32 bit protected mode
;hang: 
;	jmp hang


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
   ;Note: To make things simple, set the descriptor
   ;privilege leve of the data segment to be 0. 
   ;Loading SS with this segment is a special case, and
   ;CPL must == DPL when the stack segment is loaded.
   db 10010011b
   ; 31:24 base 23 G 22 D/B 21 L 20 AVL 19:16 Seg Limit
   db 11011111b
   db 0 

   ;code segment
   dw 0ffffh ; limit 4GB 
   dw 0 ; base
   db 0 ; base 
   ; 15 P 14:13 DPL 12 S 11:8 Type
   ; Note: the DPL is set to 0
   ; The DPL of a segment is the lowest privilege 
   ; level that is allowed to access this segment. 
   ; For eaxample, a CPL of 0 (highest priv) 
   ; would not be permitted to access a CS with DPL 
   ; 3. This appears to set the trust level of the code
   ; segment, maybe to prevent untrusted code from being
   ; run in ring 0. 
   ; Type read/write (1010b)
   db 10011010b
   ; 31:24 base 23 G 22 D/B 21 L 20 AVL 19:16 Seg Limit
   db 11011111b
   db 0

gdt_end: ; symbol for end of gdt table



gdt_desc: 
   dw gdt_end - gdt_start
   dd gdt_start


msg db "Switching to protected 32bit mode!", 13, 10, 0
times 510-($-$$) db 0 ; 0 out the rest of mem till the boot signature
db 0x55
db 0xAA
