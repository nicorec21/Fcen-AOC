extern malloc
extern free
extern fprintf

section .data
str_null db "NULL",0

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
; a->rdi
strClone:
	;prologo
		push rbp
		mov rbp, rsp

	;preciclo
		mov rsi, rdi ;me guardo el puntero original
		call strlen ;el parametro ya viene pasado (tengo en eax la len)

		add eax, 1 ;le sumo un caracter mas a str len
		mov rdi, rax ;paso el parametro para el malloc
		call malloc ;como calcula el sizeof????

		mov r9, rax; dst, aca ya queda en rax lo que hay q return

	.ciclo:
		mov dl, byte [rsi] ; dl=cpystr_addr[i] (el caracter)
		mov [r9], byte dl ;new_str_addr[i] = a[i] (antes de chequear para que no se corte antes de copiar el caracter nulo)
		cmp dl, 0
		je .epilogo

		add rsi, 1 ;siguiente caracter addr
		add r9, 1 ;siguiente caracter dst
		jmp .ciclo

	.epilogo:
		pop rbp
		ret

; void strDelete(char* a)
strDelete:
	;prologo
		push rbp
		mov rbp, rsp

	;del:
		call free ;el parametro ya esta pasado

	;epilogo:
		pop rbp
		ret

; void strPrint(char* a, FILE* pFile)
;a->rdi, pfile->rsi
strPrint:
	;prologo
		push rbp
		mov rbp,rsp

	;print
		cmp rdi,0 ; chequea string vacio
		je .printNull
		call fprintf
		ret

	.printNull:
		mov rdi, str_null
		call fprintf
		ret

	;epilogo
	pop rbp
	ret

; ;prologo:
	; 	push rbp
	; 	mov rbp, rsp
	; 	xor rax, rax
	; .ciclo:

	; 	mov cl, byte [rdi] ;meto primer caracter
	; 	cmp cl, 0 ;chequeo que no sea el fin del string
	; 	je .epilogo

	; 	mov [rsi], byte cl 
	; 	add rdi, 1 ;paso al siguiente caracter fuente
	; 	add rsi, 1 ;paso al siguiente caracter en destino
	; 	jmp .ciclo


	; .epilogo:
	; 	pop rbp
	; 	ret


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


