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
