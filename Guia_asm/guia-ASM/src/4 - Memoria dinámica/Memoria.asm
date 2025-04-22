extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret


; uint32_t strLen(char* a)
; a-> rdi
strLen:
	;Prologo:
		push rbp
		mov rbp, rsp

		xor rax, rax

	.ciclo:
		mov dl, byte [rdi]
		cmp dl, 0
		je .epilogo

		add rax, 1
		add rdi, 1 ;paso al siguiente caracter
		jmp .ciclo

	.epilogo:
		pop rbp
		ret


