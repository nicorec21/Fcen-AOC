global templosClasicos
global cuantosTemplosClasicos

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;templo* templosClasicos_c(templo *temploArr, size_t temploArr_len)
;rdi->*temploArr
;rsi->temploArr_len
templosClasicos:
    .prologo:
        push rbp
        mov rbp, rsp


    .preciclo:
        push rdi
        push rsi ;preservo los parametros originales antes del call (pila alineada)

        call cuantosTemplosClasicos ;los parametros ya estan pasados ya q son los mismos
        ;en rax tengo el resultado

        mov rdi, rax ;rdi tiene la ctad de templos clasicos
        imul rdi, 24 ;multiplico los clasicos x 24bytes (calculando la cantidad de espacio para pedirle al malloc)

        call malloc ;el parametro ya esta en rdi (24*clasicos)
        ;en rax tengo el resultado

        pop rsi
        pop rdi ;restauro los params originales

        xor r9, r9; i=0
        xor r10, r10; j=0

    .ciclo:
        cmp r9, rsi ; i ==? temploArr_len
        je .epilogo 

        xor rcx, rcx
        xor rdx, rdx

        mov cl, [rdi] ; cl=temploarr[i].clarga
        mov dl, [rdi + 16] ;dl=temploarr[i].ccorta

        inc r9 ;i++
        add rdi, 24 ;paso al sig templo

    .cuenta:
        shl dl, 1 ;dl=temploarr[i].ccorta * 2
        add dl, 1 ;dl=temploarr[i].ccorta + 1

        cmp cl, dl ;cl == ? dl
        jne .ciclo

        mov rcx, [rdi] ;rcx=temploArr[i]
        mov [rax + r10 * 24], rcx  ;templos_clasicos_arr[j] = temploArr[i];
        inc r10 ;j++
        jmp .ciclo ;y vuelvo al ciclo

     .epilogo:
        pop rbp
        ret

   

;uint32_t cuantosTemplosClasicos_c(templo *temploArr, size_t=64bits temploArr_len){
;rdi->*temploArr
;rsi->temploArr_len
cuantosTemplosClasicos:
    .prologo:
        push rbp
        mov rbp, rsp

        xor rax, rax ; clasicos = 0
        xor r9, r9; i = 0

    .ciclo:
        cmp r9, rsi ; i ==? temploArr_len
        je .epilogo 

        xor rcx, rcx
        xor rdx, rdx

        mov cl, [rdi] ; cl=temploarr[i].clarga
        mov dl, [rdi + 16] ;dl=temploarr[i].ccorta

        inc r9 ;i++
        add rdi, 24 ;paso al sig templo

    .cuenta:
        shl dl, 1 ;dl=temploarr[i].ccorta * 2
        add dl, 1 ;dl=temploarr[i].ccorta + 1

        cmp cl, dl ;cl == ? dl
        jne .ciclo

        inc rax ;clasicos++
        jmp .ciclo ;y vuelvo al ciclo

    .epilogo:
        pop rbp
        ret