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
;a->rsi b->rdi
strCmp:
	;prologo
		push rbp
		mov rbp, rsp

		xor rax, rax ; rax = 0 (caso default para el return)

	.ciclo_igual:
		mov cl, byte [rsi]
		mov dl, byte [rdi] 

		cmp cl, 0 ;a[i] ==? '\0' chequeo que no haya terminado el string
		je .epilogo

		cmp cl, dl ;a[i] ==? b[i]
		jne .decision

		add rsi, 1 ;avanzo siguiente caracter
		add rdi, 1

		jmp .ciclo_igual ;si llegue aca es que los caracteres i son iguales

	.decision:
		cmp cl, dl ;a>?b
		jg .a_es_mas_grande
		mov eax, 1 ;a < b → return 1
		jmp .epilogo

	.a_es_mas_grande:
		mov eax, -1 ; a > b → return -1

	.epilogo:
		pop rbp
		ret

; char* strClone(char* a)
; a->rdi
strClone:
	;prologo
		push rbp
		mov rbp, rsp

	;preciclo
		mov rsi, rdi ;me guardo el puntero original
		call strLen ;el parametro ya viene pasado (tengo en eax la len)

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


