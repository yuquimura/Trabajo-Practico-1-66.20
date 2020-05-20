#include "testing.h"
#include <stdio.h>
#include "MergeSort.h"

void prueba_merge(void);

/* ******************************************************************
 *                        PROGRAMA PRINCIPAL
 * *****************************************************************/

int main(void) {
    /* Ejecuta todas las pruebas unitarias. */
    printf("~~~ PRUEBAS DEL MERGE ~~~\n");
    prueba_merge();



    return failure_count() > 0;
}
