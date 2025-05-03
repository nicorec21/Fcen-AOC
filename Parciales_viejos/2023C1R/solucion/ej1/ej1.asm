global acumuladoPorCliente_asm
global en_blacklist_asm
global blacklistComercios_asm

extern calloc
extern malloc

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; uint32_t* acumuladoPorCliente(uint8_t cantidadDePagos, pago_t* arr_pagos)
; dil (rdi)->cantidadDePagos
; rsi -> arr_pagos
acumuladoPorCliente_asm:
	prologo:
		push rbp
		mov rbp, rsp
		push r12
		push r13

		xor r12, r12
		mov r12b, dil
		mov r13, rsi

		mov rdi, 10
		mov rsi, 4
		call calloc

		xor r10, r10
		xor r11, r11
		xor rcx, rcx

	.ciclo:
		mov r10b, byte [r13 + 17]
		cmp r10, 1
		jne .siguiente_pago


		mov r11b, byte [r13 + 16]
		mov cl, byte [r13 + 0]
		add dword [rax + r11*4], ecx

	.siguiente_pago:
		add r13, 24
		dec r12
		cmp r12, 0
		jne .ciclo

	.epilogo:
		pop r13
		pop r12	
		pop rbp
		ret

en_blacklist_asm:
	ret

blacklistComercios_asm:
	ret
