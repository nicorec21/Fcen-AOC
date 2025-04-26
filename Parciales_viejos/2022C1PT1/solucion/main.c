#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ejs.h"

int main (void){
	// Crear array con capacidad 5
    str_array_t* arr = strArrayNew(5);
    assert(arr != NULL);
    assert(strArrayGetSize(arr) == 0);

    // Agregar algunos strings
    strArrayAddLast(arr, strdup("Hola"));
    strArrayAddLast(arr, strdup("Mundo"));
    strArrayAddLast(arr, strdup("C!"));

    // Verificar size
    assert(strArrayGetSize(arr) == 3);
    printf("Size actual: %d\n", strArrayGetSize(arr));

    // Verificar contenido
    printf("Elemento 0: %s\n", arr->data[0]); // debería decir "Hola"
    printf("Elemento 1: %s\n", arr->data[1]); // debería decir "Mundo"
    printf("Elemento 2: %s\n", arr->data[2]); // debería decir "C!"

    // Swapear "Hola" y "C!"
    strArraySwap(arr, 0, 2);
    printf("\nDespués del swap:\n");
    printf("Elemento 0: %s\n", arr->data[0]); // debería decir "C!"
    printf("Elemento 2: %s\n", arr->data[2]); // debería decir "Hola"

    // Agregar más hasta llenar
    strArrayAddLast(arr, strdup("Test"));
    strArrayAddLast(arr, strdup("Otro"));

    assert(strArrayGetSize(arr) == 5);

    // Intentar agregar uno más (no debería hacer nada)
    strArrayAddLast(arr, strdup("Fuera de capacidad"));

    printf("\nDespués de llenar:\n");
    for (int i = 0; i < strArrayGetSize(arr); i++) {
        printf("Elemento %d: %s\n", i, arr->data[i]);
    }

    // Borrar todo
    strArrayDelete(arr);
    printf("\nArray borrado correctamente.\n");

    return 0; 
}


