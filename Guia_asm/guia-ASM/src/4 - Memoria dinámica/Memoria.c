#include "Memoria.h"

char* strClone(char* a){
    uint32_t len = strlen(a);
    char* new_str_addr = malloc( sizeof(char) * (len + 1));
    for(uint32_t i = 0; i < (len + 1); i++){
        new_str_addr[i] = a[i];
    }
    return new_str_addr;

}
