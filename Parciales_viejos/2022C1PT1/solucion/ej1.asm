global strArrayNew
global strArrayGetSize
global strArrayAddLast
global strArraySwap
global strArrayDelete

extern malloc
extern calloc
extern free

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; str_array_t* strArrayNew(uint8_t capacity)
;(rdi de 8bits)dil->capacity
strArrayNew:
    ;prologo:
        push rbp
        mov rbp, rsp

        push rdi
        sub rsp, 8 ;preservo param original y alineo pila

        mov rdi, 16 ;son los 16bytes que ocupa el struct, se los paso como param a malloc
        call malloc
        mov rcx, rax
        ;ahora en rcx tengo el puntero a mi struct (strarray)

        add rsp, 8
        pop rdi ;restauro capacity y alineo pila

        mov byte [rcx], 0 ;setteo size en 0
        mov byte [rcx + 1], dil ;setteo capacity con lo q me pasan por param

        ;el primer parametro ya esta pasado en rdi (8bits mas bajos)
        ;deberia limpiar los bits altos? -> si con movzx
        movzx rdi, dil ;extiendo de 8 a 64 para que calloc me lo tome bien
        mov rsi, 8 ; son los 8bytes que ocupa un char*, segundo param para el calloc
        call calloc
        ;en rax viene el array de strings de tamaño capacity

        mov [rcx + 8], rax ;setteo data al puntero q devolvio el calloc
        mov rax, rcx ;vuelvo a poner en rax el puntero al struct

    ;epilogo:
        pop rbp
        ret

; uint8_t  strArrayGetSize(str_array_t* a)
;rdi->a
strArrayGetSize:
    ;prologo:
        push rbp
        mov rbp, rsp

        movzx byte rax, [rdi] ;leo el size y extiendo (el size queda en los 8 bits mas bajos)

   ;epilogo:
        pop rbp
        ret


; void  strArrayAddLast(str_array_t* a, char* data)
;rdi->a
;rsi->data
strArrayAddLast:
    ;prologo:
        push rbp
        mov rbp, rsp
    
        movzx rcx, byte [rdi] ;rcx = (uint8_t)a->size
        movzx rdx, byte [rdi + 1] ; rdx = (uint8_t)a->capacity
        
        cmp rcx, rdx
        jae .epilogo ;a->size >=) a->capacity (Jump if Above or Equal)

        mov rdx, [rdi + 8] ;rdx = a->data (array de strings)
        mov [rdx + rcx*8], rsi ;a->data[i] = data (que me pasaron por param)

        inc rcx ;size++
        mov byte [rdi], cl ;a->size++ actualizado en el struct
    
    ;epilogo:
        pop rbp
        ret


;void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
;rdi- a
;rsi - i (sil)
;rdx - j (dl)
strArraySwap:
    ;prologo:
        push rbp
        mov rbp, rsp
        xor rcx, rcx

        movzx rcx, byte[rdi] ;rcx = (uint8_t)a->size
        cmp sil, cl ;i >? a->size
        ja .epilogo
        cmp dl, cl ;j>?a->size
        ja .epilogo 

        mov r8, [rdi + 8] ;r8 = a->data (puntero a strings)

        movzx rcx, sil ; extiendo a 64 el i en rcx
        mov r9, [r8 + rcx*8 ] ;r9=a->data[i] (puntero al string i)

        movzx rcx, dl ;extiendo a 64 el j en rcx
        mov r10, [r8 + rcx*8] ;r10=a->data[j] (puntero al string j)

        movzx rcx, sil  ;extiendo a 64 el i en rcx (de nuevo)
        mov [r8 + rcx*8], r10 ; data[i] = puntero a string j

        movzx rcx, dl           ; j de nuevo
        mov [r8 + rcx*8], r9    ; data[j] = puntero a string i

    .epilogo:
        pop rbp
        ret



; void  strArrayDelete(str_array_t* a)
;;rdi- a
strArrayDelete:
    ;prologo:
        push rbp
        mov rbp, rsp
        
    .preciclo:
        xor rcx, rcx;i=0
        movzx rdx, byte[rdi] ;rdx = (uint8_t)a->size

        mov r9, rdi ;me guardo en r9 una copia de rdi
        mov r8, [r9 + 8] ;r8 = a->data

    .ciclo:
        cmp rcx, rdx ;i ==? a->size
        je .fin

        mov rdi, [r8 + rcx*8] ;rdi=a->data[i]
        call free ;parametro pasado
        inc rcx ;i++

        jmp .ciclo

    .fin:
        mov rdi, r8 ;free a->data
        call free

        mov rdi, r9 ;free rd a (el struct)
        call free

    .epilogo:
        pop rbp
        ret

