#include <stdint.h>
#include <stdint.h>

int main(){

    uint32_t a[] = {1, 2, 3, 4};
    uint32_t largo_a = (sizeof(a)/4) - 1;
    uint32_t b[largo_a];

    uint32_t largo_copia = largo_a;

    for(uint32_t i = 0; i <= largo_copia; i++){

        b[i] = a[largo_a-i];
        //b[i] = a[largo_a];
        //largo_a = largo_a -1
        printf("%d \n", b[i]);
    }



    return 0;
}