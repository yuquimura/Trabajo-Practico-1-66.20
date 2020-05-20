
#include "testing.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#include "MergeSort.h"

#define VOLUMEN 2500
#define TAMANIO 10 
#define NUM_MAX 100

void arr_print(char* nombre, int* vector,size_t n){

    printf("%s => ", nombre);

    for(int i = 0; i < n ; i++){
        printf("%d ",vector[i]);
    }
    printf("\n");
}

bool is_ordered(int* vector, int n){

    for( int i = 0; i+1 < n ; i++ ){

        if(!(vector[i] <= vector[i+1]))return false;
    }

    return true;
}

bool same_elements(int* v1, int* v2, int n){

    int appearances[NUM_MAX];

    for(int k = 0; k < NUM_MAX; k++) appearances[k] = 0;

    for(int i = 0; i < n; i++) *(appearances + v1[i]) += 1;
    for(int j = 0; j < n; j++) *(appearances + v2[j]) -= 1;

    for(int k = 0; k < NUM_MAX; k++ ){
        if(appearances[k] != 0) return false;
    }

    return true; 

}


/* ******************************************************************
 *                   PRUEBAS BASICAS DE LISTA
 * *****************************************************************/


void prueba_vector_vacio(){
    
    printf("prueba_vector_vacio\n");

    int vector[0]= {};
    int* vector_ordenado = merge_sort(vector,0);

    print_test("Vector vacio", vector_ordenado == NULL);
}

void prueba_vector_fallado(){

    printf("prueba_vector_fallado\n");

    int* vector_ordenado = merge_sort(NULL,1);

    print_test("Vector fallado", vector_ordenado == NULL);
}

void prueba_vector_fallado_y_vacio(){

    printf("prueba_vector_fallado_y_vacio\n");

    int* vector_ordenado = merge_sort(NULL,0);

    print_test("Vector fallado y vacio", vector_ordenado == NULL);
}

void prueba_vector_un_elemento(){
    
    printf("prueba_vector_un_elemento\n");


    int vector[1] = {2};
    int* vector_ordenado = merge_sort(vector,1);

    print_test("Vector con un unico elemento", vector_ordenado && (vector[0] == vector_ordenado[0]));

    free(vector_ordenado);
}

void prueba_vector_pocos_elementos(){

    printf("prueba_vector_pocos_elementos\n");

    bool todo_ok;

    int vector1[2] = {3,1};
    int* vector1_ordenado = merge_sort(vector1,2);
    todo_ok = is_ordered(vector1_ordenado,2) && same_elements(vector1,vector1_ordenado,2);
    print_test("Vector con dos elementos",todo_ok);

    int vector2[3] = {5,3,8};
    int* vector2_ordenado = merge_sort(vector2,3);
    todo_ok = is_ordered(vector2_ordenado,3) && same_elements(vector2,vector2_ordenado,3);
    print_test("Vector con tres elementos",todo_ok);
    arr_print("vector",vector2,3);
    arr_print("vector_ordenado",vector2_ordenado,3);


    int vector3[4] = {4,9,2,3};
    int* vector3_ordenado = merge_sort(vector3,4);
    todo_ok = is_ordered(vector3_ordenado,4) && same_elements(vector3,vector3_ordenado,4);
    print_test("Vector con cuatro elementos",todo_ok);
    print_test("Vector con cuatro elementos is orderer",is_ordered(vector3_ordenado,4));
    print_test("Vector con cuatro elementos same elements",same_elements(vector3,vector3_ordenado,4));

    int vector4[5] = {1,0,9,8,3};
    int* vector4_ordenado = merge_sort(vector4,5);
    todo_ok = is_ordered(vector4_ordenado,5) && same_elements(vector4,vector4_ordenado,5);
    print_test("Vector con cinco elementos",todo_ok);

    free(vector1_ordenado);
    free(vector2_ordenado);
    free(vector3_ordenado);
    free(vector4_ordenado);
}

void pruebas_vector_random(){

    printf("pruebas_vector_random\n");


    bool todo_ok = true;

    int vector_random[TAMANIO];
    int* vector_random_ordenado;

    printf("INICIANDO PRUEBA DE VOLUMEN\n");
    printf("Imprimiendo una decima parte..\n");
    for(int i  = 0; i < VOLUMEN; i++){


        for(int j = 0; j < TAMANIO; j++){
            vector_random[j] = rand() % (NUM_MAX-1);
        }

        
        vector_random_ordenado = merge_sort(vector_random,TAMANIO);

        //Imprimir un decimo del volumen como muestra
        if(i%(VOLUMEN/10) == 0){

            arr_print("random",vector_random,TAMANIO);
            arr_print("random_ordenado",vector_random_ordenado,TAMANIO);
        }

        if(!is_ordered(vector_random_ordenado, TAMANIO)){
            todo_ok = false;
            break;
        }

        if(!same_elements(vector_random,vector_random_ordenado,TAMANIO)){
            todo_ok = false;
            break;
        }
    }

    print_test("Pueba de volumen random", todo_ok);

    if(!todo_ok){
        arr_print("Random",vector_random,TAMANIO);
        arr_print("Random ordenado",vector_random_ordenado,TAMANIO);
    }

    if(vector_random_ordenado) free(vector_random_ordenado);

}

void pruebas_de_funciones_de_pruebas(){

    printf("pruebas_de_funciones_de_pruebas\n");

    int vector1[2] = {3,1};
    int vector2[2] = {4,1};
    print_test("Prueba de same_elements 1",!same_elements(vector1,vector2,2));

    int vector3[5] = {3,1,8,9,3};
    int vector4[5] = {4,1,8,6,4};
    print_test("Prueba de same_elements 2",!same_elements(vector3,vector4,5));

    int vector5[2] = {3,1};
    int vector6[2] = {4,1};
    print_test("Prueba de is_ordered 1",!is_ordered(vector5,2));
    print_test("Prueba de is_ordered 2",!is_ordered(vector6,2));

    int vector7[5] = {3,1,8,9,3};
    int vector8[5] = {4,1,8,6,4};
    print_test("Prueba de is_ordered 3",!is_ordered(vector7,5));
    print_test("Prueba de is_ordered 4",!is_ordered(vector8,5));
}

/* ******************************************************************
 *                   PRUEBAS UNITARIAS
 * *****************************************************************/

void prueba_merge() {

    printf("\n");
    prueba_vector_vacio();
    printf("\n");
    prueba_vector_fallado();
    printf("\n");
    prueba_vector_fallado_y_vacio();
    printf("\n");
    prueba_vector_un_elemento();
    printf("\n");
    prueba_vector_pocos_elementos();
    printf("\n");
    pruebas_vector_random();
    printf("\n");
    pruebas_de_funciones_de_pruebas();

}
