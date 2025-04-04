#include <stdint.h>
#include <stdint.h>
#include <stdlib.h>

int main(){

    printf("%d\n",factorial(5));
    return 0;
}

int factorial(int n){

    int factorial = 1;

    for(int i = 1; i < n; i++){
        factorial = factorial * i;
    }

    return factorial;
    
}