#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct {

    char* nombre;
    int edad;

}persona_t;

persona_t* crearPersona(char* nom, int ed){
    
    persona_t* nueva_persona = malloc(sizeof(persona_t)); //guardo para la estructura
    nueva_persona->nombre = malloc(strlen(nom) + 1); //guardo para el string

    //printf("%d", sizeof(persona_t));

    strcpy(nueva_persona->nombre,nom);
    nueva_persona->edad = ed;

    return nueva_persona;

}

void eliminarPersona(persona_t* personant){
    free(personant->nombre);
    free(personant);
}




int main() {
    persona_t* persona = crearPersona("Juan", 25);

    printf("Nombre: %s\n", persona->nombre);
    printf("Edad: %d\n", persona->edad);

    // liberar memoria
    free(persona->nombre);
    free(persona);

    return 0;
}