












#include <stdio.h>
#include <stdlib.h>

// Agregá enumeración de cada línea de un archivo.
// Vim agrega un salto de línea siempre al final, 
// por lo tanto usaremos echo: 
// echo -n -e "Hola\nEsto es\nuna prueba"
int main(void){
    FILE *fp = fopen("/tmp/asdf", "rw+");
    int lineas = 1;

    int c;
    printf("%d: ",lineas);
    while (( c = getc(fp) ) != EOF){
        printf("%c",c);
        if ( c == '\n'){ 
            lineas++;
            printf("%d: ",lineas);
        }
    }
    printf("\n");
    printf("Cantidad de lineas: %d\n",lineas);

    return 0;
}
