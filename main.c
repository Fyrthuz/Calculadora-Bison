#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablasimbolos.h"
#include "analizadorSintactico.tab.h"
#include "lex.yy.h"


int main(int argc,char* argv[]){

  printf("\n------------------------Calculadora-------------------------\n\n"
        "Este es un mensaje de bienvenida, gracias por usar esta aplicacion\n\n"
        "Instrucciones:\n"
        "\t- Si terminas las sentencias en \";\" entonces se te mostrara el resultado de esta por pantalla\n"
        "\t- Si no colocas nada al final de las sentencias entonces no se te mostrara el resultado pero se ejecutara la operacion indicada\n"
        "\t- Puedes cargar un fichero a modo de script con la siguiente sentencia \"leer nombrefichero\"\n"
        "\t- Para pedir informacion sobre las acciones que se pueden realizar utiliza el comando \"VerAyuda\"\n"
        "\t- Para salir utiliza el comando \"salir\"\n\n"
        "--------Ya esta usted preparado para usar la aplicacion---------\n\n");
  inicializarTabla();
  if(argc>3){
    eliminarTabla();
    printf("Demasiados argumentos,vuelve a ejecutar con menos argumentos\n");
    return 0;
  }
  if(argc==2 && strcmp(argv[1],"-h")==0){
    verAyuda();
  }else if(argc==3 && strcmp(argv[1],"-f")==0){
    leer(argv[2]);
  }else if(!(argc==1)){
    eliminarTabla();
    printf("Argumentos no válidos,vuelve a ejecutar con argumentos validos\n");
    return 0;
  }
  yyparse();

  eliminarTabla();
  return 0;
}
