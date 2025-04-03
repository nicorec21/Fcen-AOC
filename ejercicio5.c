#include <stdio.h>

int main() {
    // Definir el valor como float y double
    float f = 0.1f;
    double d = 0.1;

    // Imprimir el valor de 0.1 como float y double
    printf("Valor de 0.1 como float: %f\n", f);
    printf("Valor de 0.1 como double: %lf\n", d);

    // Realizar el cast de float a int
    int f_to_int = (int)f;

    // Realizar el cast de double a int
    int d_to_int = (int)d;

    // Imprimir los resultados del cast
    printf("Valor de float convertido a int: %d\n", f_to_int);
    printf("Valor de double convertido a int: %d\n", d_to_int);


    // se redondeaa
    
    return 0;
}
