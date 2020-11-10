; ------------------------------------------------------------------------------
; 0x02b
;                              RegValue.asm
; ------------------------------------------------------------------------------
; This will print out value of GPR Data Registers.
; Testing the Addressing Modes.
; ------------------------------------------------------------------------------
; It uses only plain Win32 system calls from kernel32.dll, so it is very
; instructive to study since it does not make use of a C library.
; Because system calls from kernel32.dll are used, you need to link with an
; import library.
; We also have to specify the starting address ourself.
; To assemble to .obj: nasm -f win32 0x02b.asm
; To compile to .exe:  gcc 0x02b.obj -o 0x02b.exe
; ------------------------------------------------------------------------------

global  _main
  extern  _ExitProcess@4
  extern  _GetStdHandle@4
  extern  _WriteConsoleA@20

section .data
  msg:      db 'Input Words.', 0xA, 0
  len1 EQU $-msg
  wtable:   dw 134, 345, 564, 123, 0xA, 0
  len2 EQU $-wtable
  strtable: db 'test1', 0xA, 'text2', 0xA, 'doit3', 0xA, 0
  len3 EQU $-strtable
  handle:   db      0
  written:  db      0

section .text
_main:
  ; handle = GetStdHandle(-11)
  push    dword -11
  call    _GetStdHandle@4
  mov     [handle], eax

  ; WriteConsole(handle, &msg[0], Lenght, &written, 0)
  push    dword 0
  push    written
  push    dword len1
  push    msg
  push    dword [handle]
  call    _WriteConsoleA@20

;--------------------------------------------------------
  push    dword -11
  call    _GetStdHandle@4
  mov     [handle], eax

  push    dword 0
  push    written
  push    dword len2
  push    wtable
  push    dword [handle]
  call    _WriteConsoleA@20

  push    dword -11
  call    _GetStdHandle@4
  mov     [handle], eax

  push    dword 0
  push    written
  push    dword len3
  push    strtable
  push    dword [handle]
  call    _WriteConsoleA@20

  ; ExitProcess(0)
  push    dword 0
  call    _ExitProcess@4


; ------------------------------------------------------------------------------
; Output:
; [BLUE3]>nasm -fwin32 0x02b.asm
; [BLUE3]>gcc 0x02b.obj -o 0x02b.exe
; [BLUE3]>0x02b.exe
; test1
; text2
; doit3
; ☺ ☻ Y☺ ☻ Input Words.
; ------------------------------------------------------------------------------
