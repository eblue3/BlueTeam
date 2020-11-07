; ------------------------------------------------------------------------------
; 0x01a
;                              HelloWorld.asm
;
; This is a Win32 console program that writes "Hello World" on a single line and
; then exits.
;
; To assemble to .obj: nasm -f win32 0x01a.asm
; To compile to .exe:  gcc 0x01a.obj -o 0x01a.exe
; ------------------------------------------------------------------------------

        global    _main                 ; declare main() method
        extern    _printf               ; link to external library

        segment   .data
        message:  db   'Hello world', 0xA, 0  ; text message
                  ; 0xA (10) is hex for (NL = New Line), carriage return
                  ; 0 terminates the line
        ; message:  db   'Hello world', 0      => Terminate without new line

        ; code is put in the .text section
        section .text
_main:                            ; the entry point! void main()
        push    message           ; save message to the stack
        call    _printf           ; display the first value on the stack
        add     esp, 4            ; clear the stack
        ret                       ; return

; ------------------------------------------------------------------------------
; Output:
; [BLUE3]>dir /b
; 0x01a.asm
; 0x01a.exe
; 0x01a.obj
; [BLUE3]>nasm -f win32 0x01a.asm
; [BLUE3]>gcc 0x01a.obj -o 0x01a.exe
; [BLUE3]>0x01a.exe
; Hello world
; ------------------------------------------------------------------------------
