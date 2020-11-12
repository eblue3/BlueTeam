; ------------------------------------------------------------------------------
; 0x01
;                              HelloWorld.asm
; ------------------------------------------------------------------------------
; This is a Win32 console program that writes "Hello World" on a single line and
; then exits.
; ------------------------------------------------------------------------------
; C Library used: "printf"
; To assemble to .obj: nasm -f win32 0x01.asm
; To compile to .exe:  gcc 0x01.obj -o 0x01.exe
; ------------------------------------------------------------------------------

  global _main
;  global _add
;  global _sub
;  global _multiply
;  global _divide
;  global _exit
  extern _printf

section .text
_main:
  mov eax, 34h
  mov ebx, 32h
  add eax, ebx
;  add eax, '0'
;  mov ecx, eax
  push eax
  call _printf
; ------------------------------------------------------------------------------
; Output:
; [BLUE3]>nasm -fwin32 0x01.asm
; [BLUE3]>gcc 0x01.obj -o 0x01.exe
; [BLUE3]>0x01.exe
; Hello, world!
; <New blank line>
; ------------------------------------------------------------------------------
