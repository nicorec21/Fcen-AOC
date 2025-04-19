#include <stdio.h>

typedef struct  {
    char* nombre;
    int vida;
    double ataque;
    double defensa;
} mounstruo_t;

mounstruo_t evolucionar(mounstruo_t monster) {
    mounstruo_t evolucionado = monster;
    evolucionado.ataque += 10;
    evolucionado.defensa += 10;
    return evolucionado;
}

int main() {
    mounstruo_t mounstruo1 = {"Brainiac", 10, 34.0, 20.0};
    mounstruo_t evolucionado = evolucionar(mounstruo1);

    printf("Original:\n");
    printf("Defensa: %.2f\n", mounstruo1.defensa);
    printf("Ataque: %.2f\n\n", mounstruo1.ataque);

    printf("Evolucionado:\n");
    printf("Defensa: %.2f\n", evolucionado.defensa);
    printf("Ataque: %.2f\n", evolucionado.ataque);

    return 0;
}