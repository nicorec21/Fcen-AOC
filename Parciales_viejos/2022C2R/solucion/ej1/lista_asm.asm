%define OFFSET_NEXT  0
%define OFFSET_SUM   8
%define OFFSET_SIZE  16
%define OFFSET_ARRAY 24
%define SIZE_LISTA 32

BITS 64

section .text


; uint32_t proyecto_mas_dificil(lista_t*)
;
; Dada una lista enlazada de proyectos devuelve el `sum` más grande de ésta.
;
; - El `sum` más grande de la lista vacía (`NULL`) es 0.
;
global proyecto_mas_dificil
;rdi -> lista_t*
proyecto_mas_dificil:
	;prologo:
		push rbp
		mov rbp, rsp

		xor rax, rax ;max_sum=0

	.ciclo:
		cmp rdi, 0 ;lista ==? NULL
		je .epilogo ; si lista == NULL, terminamos

		mov rsi, [rdi + OFFSET_SUM] ;rsi = lista->sum

		cmp rsi, rax ;lista->sum ≤ max_sum (unsigned)
		jbe .siguiente_nodo ;below or equal rsi<=rax

		mov rax, rsi ;max_sum = lista->sum;

	.siguiente_nodo:
		mov rdi, [rdi + OFFSET_NEXT];lista = lista->next
		jmp .ciclo

	.epilogo:
		pop rbp
		ret

; void tarea_completada(lista_t*, size_t)
;
; Dada una lista enlazada de proyectos y un índice en ésta setea la i-ésima
; tarea en cero.
;
; - La implementación debe "saltearse" a los proyectos sin tareas
; - Se puede asumir que el índice siempre es válido
; - Se debe actualizar el `sum` del nodo actualizado de la lista
;
global marcar_tarea_completada
;rdi->lista_t*
;rsi->index
marcar_tarea_completada:
	;prologo:
		push rbp
		mov rbp, rsp

		xor r9, r9 ;curr_i = 0

	.ciclo:
		cmp rdi, 0 ;lista ==? NULL
		je .saltear_while ; si lista == NULL, seguimos

		mov r10, r9 ;r10 = curr_i
		add r10, [rdi + OFFSET_SIZE] ;r10 = rcurr_i + lista->size
		cmp r10, rsi; curr_i + lista->size <=? index
		jbe .saltear_while

		add r9, [rdi + OFFSET_SIZE] ;curr_i += lista->size;
		mov rdi, [rdi] ;lista->next

	.saltear_while:
		cmp rdi, 0 ;lista ==? NULL
		je .epilogo

	;fin:
		sub rsi, r9 ;index -= curr_i;
		mov r10, rsi ;copio el index
		shl r10, 2 ;r10 *4 (tamaño de uint32 cada tarea)

		mov r11, [rdi + OFFSET_ARRAY] ;r11 = lista->array
		mov ecx, [r11 + r10]  ;ecx = lista->array[index]
		sub [rdi + OFFSET_SUM], ecx ;lista->sum -= lista->array[index];
		mov DWORD [r11 + r10], 0 ;lista->array[index] = 0;

	.epilogo:
		pop rbp
		ret

; uint64_t* tareas_completadas_por_proyecto(lista_t*)
;
; Dada una lista enlazada de proyectos se devuelve un array que cuenta
; cuántas tareas completadas tiene cada uno de ellos.
;
; - Si se provee a la lista vacía como parámetro (`NULL`) la respuesta puede
;   ser `NULL` o el resultado de `malloc(0)`
; - Los proyectos sin tareas tienen cero tareas completadas
; - Los proyectos sin tareas deben aparecer en el array resultante
; - Se provee una implementación esqueleto en C si se desea seguir el
;   esquema implementativo recomendado
;
global tareas_completadas_por_proyecto
tareas_completadas_por_proyecto:
	; COMPLETAR
	ret

; uint64_t lista_len(lista_t* lista)
;
; Dada una lista enlazada devuelve su longitud.
;
; - La longitud de `NULL` es 0
;
lista_len:
	; OPCIONAL: Completar si se usa el esquema recomendado por la cátedra
	ret

; uint64_t tareas_completadas(uint32_t* array, size_t size) {
;
; Dado un array de `size` enteros de 32 bits sin signo devuelve la cantidad de
; ceros en ese array.
;
; - Un array de tamaño 0 tiene 0 ceros.
tareas_completadas:
	; OPCIONAL: Completar si se usa el esquema recomendado por la cátedra
