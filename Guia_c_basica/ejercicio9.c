#include <stdint.h>

int main(){

    uint32_t a = 0b0000000000000000000000000000111;
    uint32_t b = 0b11100000000000000000000000000000;

    //uint32_t c = 0;
    
    uint32_t a_shifted = a << 29;

    uint32_t mascara_para_b = 0b11100000000000000000000000000000;

    uint32_t b_enmascarado = b & mascara_para_b;

    printf(" %d \n", a_shifted == b_enmascarado);






    return 0;

}