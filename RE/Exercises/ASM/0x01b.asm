; ------------------------------------------------------------------------------
; 0x01b
;                              HelloWorld.asm
; ------------------------------------------------------------------------------
; This is a Win32 console program that writes "Hello World" on a single line and
; then exits.
; ------------------------------------------------------------------------------
; C Library used: "printf"
; To assemble to .obj: nasm -f win32 0x01b.asm
; To compile to .exe:  gcc 0x01b.obj -o 0x01b.exe
; ------------------------------------------------------------------------------

        global    _main                 ; declare main() method
        extern    _printf               ; link to external C library

        segment   .data
        message:  db   'Hello, world!', 0xA, 0  ; text message
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
; [BLUE3]>nasm -fwin32 0x01b.asm
; [BLUE3]>gcc 0x01b.obj -o 0x01b.exe
; [BLUE3]>0x01b.exe
; Hello, world!
; <New blank line>
; ------------------------------------------------------------------------------
