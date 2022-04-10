#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#include "estructura.h"
#include "gestionerrores.h"
#include "definiciones.h"

//variable global donde se almacena la tabla de símbolos
abb tabla;

void inicializarTabla(){

  //Instaciamos la tabla de símbolos
  crea(&tabla);
  //Insertamos todas las funciones que aceptará nuestro intérprete
  inserta_funcion(&tabla,"sin",sin);
  inserta_funcion(&tabla,"cos",cos);
  inserta_funcion(&tabla,"tan",tan);
  inserta_funcion(&tabla,"asin",asin);
  inserta_funcion(&tabla,"acos",acos);
  inserta_funcion(&tabla,"atan",atan);
  inserta_funcion(&tabla,"sinh",sinh);
  inserta_funcion(&tabla,"cosh",cosh);
  inserta_funcion(&tabla,"tanh",tanh);
  inserta_funcion(&tabla,"log10",log10);
  inserta_funcion(&tabla,"ln",log);
  inserta_funcion(&tabla,"exp",exp);
  inserta_funcion(&tabla,"sqrt",sqrt);
  inserta_funcion(&tabla,"ceil",ceil);
  inserta_funcion(&tabla,"floor",floor);
  inserta_funcion(&tabla,"fabs",fabs);
  inserta_funcion(&tabla,"mod",fmod);
  inserta_funcion(&tabla,"^",pow);

  inserta_constante(&tabla,"pi",3.14159265359);
  inserta_constante(&tabla,"e",2.71828182845);
}

//Imprimimos la tabla de símbolos
void imprimirTabla(){
  imprimirArbol(tabla);
}

void imprimirVariables(){
  imprimirVariablesArbol(tabla);
}

//Destruimos la tabla de simbolos
void eliminarTabla(){
  destruye(&tabla);
}

//Introducimos un elemento en la tabla de símbolos
void insertar_id(char *cadena,double value){
  inserta_identificador(&tabla,cadena,value);
}

short existe_id(char *lexema,short tipo){
  short n=0;
  existe(tabla,lexema,tipo,&n);
  return n;
}

double recupera_valor(char *lexema){
  return recupera(tabla,lexema);
}

double ejecutaFuncionUnParametro(char *lexema,double input){
  double valor = 0.0;
  funcionUnParametro(tabla,lexema,input,&valor);
  return valor;
}

double ejecutaFuncionDosParametro(char *lexema,double input1,double input2){
  double valor = 0.0;
  funcionDosParametro(tabla,lexema,input1,input2,&valor);
  return valor;
}

void restauraEstado(){
  int n=0;
  eliminaVariables(&tabla,&n);
}
