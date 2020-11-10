; ------------------------------------------------------------------------------
; 0x02a
;                              RegValue.asm
; ------------------------------------------------------------------------------
; This will print out value of GPR Data Registers.
; Testing the Addressing Modes.
; ------------------------------------------------------------------------------
; C Library used: "printf"
; To assemble to .obj: nasm -f win32 0x02a.asm
; To compile to .exe:  gcc 0x02a.obj -o 0x02a.exe
; ------------------------------------------------------------------------------

        global    _main                 ; declare main() method
        extern    _printf               ; link to external C library

segment .data
    msg:  db 'Input Words.', 0xA, 0  ; text message
    ; 0xA (10) is hex for (NL = New Line), carriage return
    ; 0 terminates the line
    wtable:  dw 134, 345, 564, 123, 0xA, 0
    strtable:  db 'test1', 0xA, 'text2', 0xA, 'doit3', 0xA, 0

section .text
  _main:
    mov eax, msg
    mov ebx, strtable
    mov ecx, wtable+3
    mov edx, wtable+2

    push eax
    push edx
    push ecx
    push ebx
    call _printf
    pop ebx
    call _printf
    pop ecx
    call _printf
    pop edx
    call _printf
    pop eax

; ------------------------------------------------------------------------------
; Output:
; [BLUE3]>nasm -fwin32 0x02a.asm
; [BLUE3]>gcc 0x02a.obj -o 0x02a.exe
; [BLUE3]>0x02a.exe
; test1
; text2
; doit3
; ☺ ☻ Y☺ ☻ Input Words.
; ------------------------------------------------------------------------------
