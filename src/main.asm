[BITS 16]
[ORG 0x7c00]




CODE_OFFSET equ 0x8

DATA_OFFSET equ 0x10





jmp SetStack

SetStack:
  cli
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax ; sp:ss for stack
  mov sp, 0x7c00
  sti

mov bx, KERNEL_LOAD_SEG
mov dh, 0x00
mov dl, 0x80
mov cl, 0x02
mov ch, 0x00
mov ah, 0x02
mov al, 8 

in 0x13

jc disk_read_error







load_PM:
  cli
  lgdt[GDT_descriptor]
  mov eax, cr0
  or al, 1
  mov cro, eax
  jmp CODE_OFFSET:PMMain

disk_read_error:
  cli
  hlt
  jmp disk_read_error


GDT_start:
  dd 0x00000000 ; null descriptor
  dd 0x00000000
  
  ; code seg descriptor
  dw 0xFFFF ; limit
  dw 0x0000 ; base
  db 0x00 ; base
  db 10011010b ; access byte
  db 11001111b ; flags
  db 0x00 ; base

  ; data seg descriptor
  dw 0xFFFF ; limit
  dw 0x0000 ; base
  db 0x00 ; base
  db 10010010b ; access byte
  db 11001111b ; flags
  db 0x00 ; base

  GDT_end:
  
  GDT_descriptor:
    dw GDT_end - GDT_start - 1 ; size of gdt - 1
    dd GDT_start

[BITS 32]

PMMain:
  mov ax, DATA_OFFSET
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov ss, ax
  mov gs, ax
  mov ebp, 0x9c00
  mov esp, ebp

  in al, 0x92
  or al, 2
  out 0x92, al

  jmp CODE_OFFSET:KERNEL_START_ADDR

times 510-($-$$) db 0 ; fill the empty space with 0
dw 0xAA55 ; what the legacy bios lo:wqoks for to see if a disk is bootable
