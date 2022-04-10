#include <stdio.h>
#include <stdlib.h>
//Funcion que es utilizada cuando se detecta un error lexico
void errorLexico(int linea){
  printf("\nError lexico en la linea: %d\n",linea);
}
//Funcion que es utilizada cuando no se puede abrir o utilizar un archivo
void errorArchivo(char *s){
  printf("\nError al abrir el archivo: %s.....\n\n",s);
}
//FUncion que es utilizada cuando los parametros que se pasan por línea de comandos no
//son válidos
void errorParametros(){
  printf("\nIntroduzca únicamente un codigo fuente, el que quiere compilar\n\nParando ejecucion del programa...\n");
  exit(EXIT_FAILURE);
}
