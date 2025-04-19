#include <stdio.h>

int main() {
    struct mounstruo_t {
        char* nombre;
        int vida;
        double ataque;
        double defensa;
    };

    struct mounstruo_t mounstruo1 = {"Brainiac", 10, 34.0, 20.0};
    struct mounstruo_t mounstruo2 = {"Lex Luthor", 23, 44.0, 66.0};

    struct mounstruo_t array_monsters[] = {mounstruo1, mounstruo2};
    int cantidad_monsters = sizeof(array_monsters) / sizeof(array_monsters[0]);

    for (int i = 0; i < cantidad_monsters; i++) {
        printf("Nombre: %s\n", array_monsters[i].nombre);
        printf("Vida: %d\n", array_monsters[i].vida);
        printf("Ataque: %.2f\n", array_monsters[i].ataque);
        printf("Defensa: %.2f\n\n", array_monsters[i].defensa);
    }

    return 0;
}