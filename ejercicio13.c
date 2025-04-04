#include <stdint.h>
#include <stdint.h>
#include <stdlib.h>

int main(){

    uint32_t contador[] = {0, 0, 0, 0, 0, 0};

    for(int i = 0; i < 60000000; i++){
        int tirada = 1 + rand() % 6;
        contador[tirada - 1] = contador[tirada-1]+1;

    }
    
    for(int i = 0; i < 6; i++){
        printf("%d \n", contador[i]);
    }
    



    return 0;
}