; ------------------------------------------------------------------------------
; 0x02b
;                              WinAPI-parameter.asm
; ------------------------------------------------------------------------------
; In every WinAPI function (GetStdHandle or WriteConsole, ...), they all have
; parameters that needs input value (Similar to Python when create new function)
; having or not the parameter/variable inside it.
; For ex:
; GetStdHandle Syntax C:
; HANDLE WINAPI GetStdHandle(
;    _In_ DWORD nStdHandle
; );
; => GetStdHandle(nStdHandle)
; .code
;   push    dword -11           ; Send value -11 to nStdHandle
;   call    _GetStdHandle@4     ; Call the function GetStdHandle
; => GetStdHandle(-11)
; => GetStdHandle(nStdHandle = -11)
;
; For ex2:
; WriteConsole Syntax C:
;  BOOL WINAPI WriteConsole(
;    _In_             HANDLE  hConsoleOutput,
;    _In_       const VOID    *lpBuffer,
;    _In_             DWORD   nNumberOfCharsToWrite,
;    _Out_opt_        LPDWORD lpNumberOfCharsWritten,
;    _Reserved_       LPVOID  lpReserved
;  );
; => WriteConsole(handle, &msg[0], Lenght, &written, 0)
; .code
;  push    dword 0              ; Send value 0 to parameter "Reserved"
;  push    written              ; Send value 0 to parameter "NumberOfCharsWritten"
;  push    dword len1           ; Send value equal to lenght of msg ($-msg) to parameter "NumberOfCharsToWrite"
;  push    msg                  ; Send value 'Input Words.' , 0xA , 0 to parameter "Buffer?", this is the message
;  push    dword [handle]       ; Get the value of [handle] = eax to parameter "ConsoleOutput"
;  call    _WriteConsoleA@20
; => WriteConsole(0, 'Input Words', $-msg, 0, 0)
; (Because written db 0 and handle db 0)
; ------------------------------------------------------------------------------
; To assemble to .obj: nasm -fwin32 WinAPI-parameter.asm
; To compile to .exe:  gcc WinAPI-parameter.obj -o WinAPI-parameter.exe
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
  mov     [handle], eax        ; Set the size of [handle] to eax size

  ; WriteConsole(handle, &msg[0], Lenght, &written, 0)
  push    dword 0              ; Send value 0 to parameter "Reserved"
  push    written              ; Send value 0 to parameter "NumberOfCharsWritten"
  push    dword len1           ; Send value equal to lenght of msg ($-msg) to parameter "NumberOfCharsToWrite"
  push    msg                  ; Send value 'Input Words.' , 0xA , 0 to parameter "Buffer?", this is the message
  push    dword [handle]       ; Get the value of [handle] = eax to parameter "ConsoleOutput"
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
; [BLUE3]>nasm -fwin32 WinAPI-parameter.asm
; [BLUE3]>gcc WinAPI-parameter.obj -o WinAPI-parameter.exe
; [BLUE3]>WinAPI-parameter.exe
; Input Words.
; åY☺☻
; test1
; text2
; doit3
; ------------------------------------------------------------------------------
