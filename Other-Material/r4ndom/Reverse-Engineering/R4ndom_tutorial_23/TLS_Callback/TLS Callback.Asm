
.586
.model flat, stdcall
option casemap :none

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Includes                                                    ;
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comdlg32.inc
	
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib
	

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Data                                                        ;
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
.data
	DbgNotFoundTitle db "Debugger status:",0h
	DbgFoundTitle db "Debugger status:",0h
	DbgNotFoundText db "Debugger not found!",0h
	DbgFoundText db "Debugger found!",0h

;	TLS Structure

	dd offset 	StartAddress
	dd offset 	EndAddress
	dd offset 	AddressOfIndex
	dd offset 	TlsCallBack
	
	TlsCallBack dd  offset TLS			; Address of our callback
    dd 0								; Spacer
    dd 0								; Spacer
    StartAddress	 dd     0
    EndAddress 		 dd     0
    AddressOfIndex 	 dd     0
    TlsCallBack2 	 dd  offset TLS
    SizeOfZeroFill	 dd     0
    Characteristics	 dd     0
	
.data?
	TLSCalled db ?						; Flag for if TLS has been called


;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; Code                                                        ;
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;	
.code

start:
	invoke ExitProcess,0				; Main routine does nothing
	ret
	
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
; TLSCallback                                                 ;
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;	

TLS:
	
	CMP BYTE PTR[TLSCalled],1			; If callback has already been run
	JE @exit							;   ignore it
	MOV BYTE PTR[TLSCalled],1			; Set flag for next time
	CALL IsDebuggerPresent
	
	CMP EAX,1							; Are we being debugged?
	JE @DebuggerDetected				;   yes
	
	PUSH 40h							; Show goodboy
	PUSH offset DbgNotFoundTitle
	PUSH offset DbgNotFoundText
	PUSH 0
	CALL MessageBox
	JMP @exit
	
@DebuggerDetected:
	PUSH 30h							; Show badboy
	PUSH offset DbgFoundTitle
	PUSH offset DbgFoundText
	PUSH 0
	CALL MessageBox
	
@exit:
	RET

end start