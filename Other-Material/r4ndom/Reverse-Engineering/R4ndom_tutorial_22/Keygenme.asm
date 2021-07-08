<405000>

cld					; Make direction forward
mov esi, 403114 	; ESI = source string
mov edi, @serial	; EDI = destination

@loop:
movsb				; Copy a byte of the string
cmp byte ptr[esi], 0;  until we hit zero
jne @loop			; Loop until done

push 10				; MB_OK
push @caption		; Title of box
push @text			; Text of box
xor eax, eax		; EAX = 0
push eax			; Handle to box = NULL
jmp 40117a			; Return to our target

@caption:
	"Correct serial.\0"

@text:
	"The correct serial is: "
	
@serial:
db 00