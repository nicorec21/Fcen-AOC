extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[EDI], x2[ESI], x3[EDX], x4[ECX], x5[R8D], x6[R9D], x7[rsp + 16], x8[rsp + 8]
alternate_sum_8:
	; ;prologo
  ;   push RBP
  ;   mov RBP, RSP

	; ;suma ;se podria hacer con un call a alternate 4
  ;  sub EDI, ESI ;x1 = x1 - x2
  ;  sub EDX, ECX ;x3 = x3 - x4
  ;  sub R8D, R9D ;x5 = x5 - x6
   
  ;  mov ESI, [RSP + 16] ; ESI = x7
  ;  mov ECX, [RBP + 8] ; EXC = x8
  ;  sub ESI, ECX 

  ;  add EDI, EDX
  ;  add R8D, ESI
  ;  add EDI, R8D

  ;  mov EAX, EDI 

	; ;epilogo
  ;   pop RBP
	;   ret

  ;prologo
    push rbp ; alineado a 16
    mov rbp,rsp
	  call alternate_sum_4 ; (x1 - x2 + x3 - x4) en rax (los params ya vienen pasados)

	;preparamos todo para hacer el call que guarde (x5 - x6 + x7 - x8)
    mov rdi , r8
    mov rsi, r9
    mov rdx, [rbp + 16]
    mov rcx, [rbp + 24]
    mov r9,rax ; muevo el resultado de la primera suma porque voy a pisar rax
    call alternate_sum_4
    add rax,r9

	;epilogo
    pop rbp
    ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[xmm0]
product_2_f:
  ;prologo
    push RBP
    mov RBP, RSP

  ;prod
  
  cvtsi2ss XMM1, RSI ;Convert Doubleword Integer to Scalar Single Precision Floating-Point Value
  mulss XMM0, XMM1 ;multiplico 
  cvttss2si RAX, XMM0 ;Convert With Truncation Scalar Single Precision Floating-Point Value to Integer

  mov [RDI], EAX ;escribo el contenido del puntero

	;epilogo
    pop RBP
	  ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila:  destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[rbp+16], f6[xmm5], x7[rbp+24], f7[xmm6], x8[rbp+32], f8[xmm7],
;	, x9[rbp + 40], f9[rbp+ 48]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp
	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0,xmm0
	cvtss2sd xmm1,xmm1
	cvtss2sd xmm2,xmm2
	cvtss2sd xmm3,xmm3
	cvtss2sd xmm4,xmm4
	cvtss2sd xmm5,xmm5
	cvtss2sd xmm6,xmm6
	cvtss2sd xmm7,xmm7
	;me falta f9 que esta en la pila

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0,xmm1
	mulsd xmm0,xmm2
	mulsd xmm0,xmm3
	mulsd xmm0,xmm4
	mulsd xmm0,xmm5
	mulsd xmm0,xmm6
	mulsd xmm0,xmm7

	;traemos de la pila a f9
	movss xmm1, [rbp + 48]
	cvtss2sd xmm1,xmm1
	mulsd xmm0, xmm1


	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd xmm1, rsi
	cvtsi2sd xmm2, rdx
	cvtsi2sd xmm3, rcx
	cvtsi2sd xmm4, r8
	cvtsi2sd xmm5, r9

	mulsd xmm0,xmm1
	mulsd xmm0,xmm2
	mulsd xmm0,xmm3
	mulsd xmm0,xmm4
	mulsd xmm0,xmm5
	
	;traemos de la pila y convertimos los enteros que quedaron
	mov rsi, [rbp + 16]
	mov rdx, [rbp + 24]
	mov rcx, [rbp + 32]
	mov r8, [rbp + 40]
	
	cvtsi2sd xmm1, rsi
	cvtsi2sd xmm2, rdx
	cvtsi2sd xmm3, rcx
	cvtsi2sd xmm4, r8
	
	mulsd xmm0,xmm1
	mulsd xmm0,xmm2
	mulsd xmm0,xmm3
	mulsd xmm0,xmm4
	
	movsd [rdi], xmm0
	; epilogo
	pop rbp
	ret
