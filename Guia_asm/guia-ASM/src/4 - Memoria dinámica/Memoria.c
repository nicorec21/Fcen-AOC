#include "Memoria.h"

char* strClone(char* a){
    uint32_t len = strlen(a);
    char* new_str_addr = malloc( sizeof(char) * (len + 1));
    for(uint32_t i = 0; i < (len + 1); i++){
        new_str_addr[i] = a[i];
    }
    return new_str_addr;

}
// Compara dos strings en orden lexicográfico. Ver https://es.wikipedia.org/wiki/Orden_lexicografico.
// Debe retornar:
// 0 si son iguales
// 1 si a < b
//-1 si a > b
int32_t strCmp(char *a, char *b){
    int32_t i = 0;
    while(a[i] == b[i]){
        if(a[i] == '\0'){
            return 0;
        }
        i++;
    }
    if(a[i] < b[i]){
        return -1;
    }
    else{
        return 0;
    }

}
