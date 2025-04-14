#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "type.h"

typedef struct node {
    void* data;           // Pointer to data (generic)
    struct node* next;    // Pointer to the next node
} node_t;

typedef struct list {
    type_t type;          // The type of data stored in the list (probably a custom type)
    uint8_t size;         // The size of the list (number of elements)
    node_t* first;        // Pointer to the first node in the list
} list_t;


int intercambiar_nodos(list_t* lista, int i, int j) {
    if (!lista || lista->size <= 1 || i == j || i < 0 || j < 0 || i >= lista->size || j >= lista->size)
        return 0;

    if (i > j) { // Always make i < j to simplify
        int temp = i;
        i = j;
        j = temp;
    }

    node_t* nodo_i = lista->first;
    node_t* nodo_j = lista->first;

    for (int idx = 0; idx < i; idx++)
        nodo_i = nodo_i->next;

    for (int idx = 0; idx < j; idx++)
        nodo_j = nodo_j->next;

    void* tmp = nodo_i->data;
    nodo_i->data = nodo_j->data;
    nodo_j->data = tmp;

    return 1;
}







    



}

int main() {

}