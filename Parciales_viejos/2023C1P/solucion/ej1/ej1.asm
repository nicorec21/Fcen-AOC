global templosClasicos
global cuantosTemplosClasicos



;########### SECCION DE TEXTO (PROGRAMA)
section .text
;uint32_t cuantosTemplosClasicos_c(templo *temploArr, size_t=64bits temploArr_len){
;rdi->*temploArr
;rsi->temploArr_len
templosClasicos:
    ;prologo:
        push rbp
        mov rbp, rsp

        xor rax, rax ; clasicos = 0
        xor r9, r9; i = 0

    ciclo:
        cmp rax, rsi ; i <? temploArr_len
        jl .fin 

        xor rcx, rcx
        xor rdx, rdx
        mov cl, [rdi] ; cl=temploarr[i].clarga
        mov dl, [rdi + 16] ;dl=temploarr[i].ccorta

        inc r9 ;i++
        add rdi, 24 ;paso al sig templo

    ;cuenta:

        add dl, 1 ;dl=temploarr[i].ccorta + 1
        shl dl, 1 ;dl=temploarr[i].ccorta * 2
        cmp cl, dl ;cl == ? dl
        jne .ciclo

        inc rax ;clasicos++

    .epilogo:
        pop rbp
        ret



cuantosTemplosClasicos:


