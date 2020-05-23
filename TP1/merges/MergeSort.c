
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "MergeSort.h"

int *arr_merge(int *vector1, size_t n1, int *vector2, size_t n2) {

	//Posiciones relativas de cada vector
	int p1 = 0;
	int p2 = 0;
	int *merged = malloc(sizeof(int) * (n1 + n2));

	for (int i = 0; i < n1 + n2; i++) {

		//Si la p1 alcanzo n1 entonces termine de iterar el primero vector
		if (p1 == n1) {
			merged[i] = vector2[p2++];
			//Si la p2 alcanzo n2 entonces termine de iterar el segundo vector
		} else if (p2 == n2) {
			merged[i] = vector1[p1++];
		} else if (vector1[p1] < vector2[p2]) {
			merged[i] = vector1[p1++];
		} else {
			merged[i] = vector2[p2++];
		}
	}

	return merged;
}

//probar diferencias entre int* vector y int vector[]
int *merge_sort(int *vector, size_t n) {

	//Ordenar nada no sirve
	if (n < 1 || !vector) return NULL;

	//Caso base, se devuelve un nuevo vector con el unico elem de entrada 
	if (n == 1) {

		int *vector_ordenado = malloc(sizeof(int));
		vector_ordenado[0] = vector[0];
		return vector_ordenado;
	}

	//Dividimos el arreglo en do de tamaño n1 y n2 / n1 + n2 = n
	size_t n1 = n / 2;
	size_t n2 = n - n1;

	//Merge con las dos mitades
	//"vector" si gue siendo un puntero a la primera posicion de la primera mitad
	//"vector + n1" es un puntero a la primera posicion de la segunda mitad
	int *vector1_ord = merge_sort(vector, n1);
	int *vector2_ord = merge_sort(vector + n1, n2);

	//Merge
	int *vector_ordenado = arr_merge(vector1_ord, n1, vector2_ord, n2);

	//Libero las dos mitades que ya no me sirven
	free(vector1_ord);
	free(vector2_ord);

	return vector_ordenado;

}

