#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "definiciones.h"

//Almacena el valor que guarda un elemento
union Guardado{
  double valor;
  double (*funcion)();
};
typedef union Guardado guardado;

//Estructura correspondiente a la información que guarda un nodo
typedef struct{
  guardado dato;
  char *lexema;
}elemento;

//Estructura de un nodo del arbol
struct nodo{
  elemento info;
  short tipo;
  struct nodo *izq,*der;
};

//Definimos el arbol binario como un puntero a un nodo
typedef struct nodo *abb;


//Inicializamos el nodo igualandolo a NULL
void crea(abb *a){
  *a = NULL;
}

//Función que nos sirve para liberar toda la memoria del árbol y destruírlo
void destruye(abb *a){
  if(*a != NULL){
    destruye(&(*a)->izq);
    destruye(&(*a)->der);
    (*a)->izq = NULL;
    (*a)->der = NULL;
    free(((*a)->info.lexema));
    (*a)->info.lexema = NULL;
    free(*a);
    *a = NULL;
  }
}

//Si el arbol es igual a NULL entonces esta vacío
unsigned vacio(abb a){
  return a==NULL;
}

//Esta función inserta y busca al mismo tiempo, si no encuentra el elemento
//entonces este es inserta en la tabla, si lo encuentra devuelve el tipo de componentes
//lexico que identifica al lexema
void inserta_identificador(abb *a, char *lexema,double value){
  //Si el nodo esta vacío quiere decir que no existe en el árbol por lo que hay que insertarlo
  if(vacio(*a)){
    *a = (abb)malloc(sizeof(struct nodo));
    (*a)->info.lexema = (char*)malloc(strlen(lexema)+1*sizeof(char));
    strncpy((*a)->info.lexema, lexema, strlen(lexema));
    (*a)->info.lexema[strlen(lexema)]='\0';
    (*a)->izq = NULL;
    (*a)->der = NULL;
    (*a)->info.dato.valor = value;
    (*a)->tipo = ID;
  }else if(strcmp(lexema,(*a)->info.lexema)<0){
    inserta_identificador(&(*a)->izq,lexema,value);
  }else if(strcmp(lexema,(*a)->info.lexema)>0){
    inserta_identificador(&(*a)->der,lexema,value);
  }else{
    (*a)->info.dato.valor = value;
  }
}

void inserta_funcion(abb *a, char *lexema,double(*funcion)()){
  //Si el nodo esta vacío quiere decir que no existe en el árbol por lo que hay que insertarlo
  if(vacio(*a)){
    *a = (abb)malloc(sizeof(struct nodo));
    (*a)->info.lexema = (char*)malloc(strlen(lexema)+1*sizeof(char));
    strncpy((*a)->info.lexema, lexema, strlen(lexema));
    (*a)->info.lexema[strlen(lexema)]='\0';
    (*a)->izq = NULL;
    (*a)->der = NULL;
    (*a)->info.dato.funcion = funcion;
    (*a)->tipo = FUNC;
  }else if(strcmp(lexema,(*a)->info.lexema)<0){
    inserta_funcion(&(*a)->izq,lexema,funcion);
  }else if(strcmp(lexema,(*a)->info.lexema)>0){
    inserta_funcion(&(*a)->der,lexema,funcion);
  }else{
    (*a)->info.dato.funcion = funcion;
  }
}

void inserta_constante(abb *a, char *lexema,double flotante){
  //Si el nodo esta vacío quiere decir que no existe en el árbol por lo que hay que insertarlo
  if(vacio(*a)){
    *a = (abb)malloc(sizeof(struct nodo));
    (*a)->info.lexema = (char*)malloc(strlen(lexema)+1*sizeof(char));
    strncpy((*a)->info.lexema, lexema, strlen(lexema));
    (*a)->info.lexema[strlen(lexema)]='\0';
    (*a)->izq = NULL;
    (*a)->der = NULL;
    (*a)->info.dato.valor = flotante;
    (*a)->tipo = CONST;
  }else if(strcmp(lexema,(*a)->info.lexema)<0){
    inserta_constante(&(*a)->izq,lexema,flotante);
  }else if(strcmp(lexema,(*a)->info.lexema)>0){
    inserta_constante(&(*a)->der,lexema,flotante);
  }else{
    (*a)->info.dato.valor = flotante;
  }
}

double recupera(abb a,char *lexema){
    if(strcmp(lexema,a->info.lexema)==0){
      return a->info.dato.valor;
    }else if(strcmp(lexema,a->info.lexema)>0){
      return recupera(a->der,lexema);
    }else{
      return recupera(a->izq,lexema);
    }
}

void existe(abb a,char *lexema,short tipo,short *n){
  if(vacio(a)){
    *n=0;
  }else if(strcmp(lexema,a->info.lexema)<0){
    existe(a->izq,lexema,tipo,n);
  }else if(strcmp(lexema,a->info.lexema)>0){
    existe(a->der,lexema,tipo,n);
  }else{
    if(a->tipo==tipo){
      *n=1;
    }else{
      *n=0;
    }
  }
}


//Funcion que sirve para imprimir un nodo
void imprimirNodo(abb a){
  if((a->tipo==ID)){
    printf("\tVariable:%s\t",a->info.lexema);
    printf("\t\tInfo_guardada:%f\t\n",a->info.dato.valor);
  }else if(a->tipo==FUNC){
    printf("\t%s\t\n",a->info.lexema);
  }else{
    printf("\tConstante:%s\t",a->info.lexema);
    printf("\t\tInfo_guardada:%f\t\n",a->info.dato.valor);
  }
}


void _imprimirVariablesNodo(abb a){
  if((a->tipo==ID)){
    printf("\tVariable:%s\t",a->info.lexema);
    printf("\t\tValor:%f\t\n",a->info.dato.valor);
  }
}

//Funcion que cuando es llamda imprimer todo el arbol binario en un recorrido I-R-D
void imprimir(abb a){
    if(!vacio(a->izq)){
      imprimir(a->izq);
    }
    imprimirNodo(a);
    if(!vacio(a->der)){
      imprimir(a->der);
    }
}

void _imprimirVariables(abb a){
    if(!vacio(a->izq)){
      _imprimirVariables(a->izq);
    }
    if(a->tipo==ID){
      imprimirNodo(a);
    }
    if(!vacio(a->der)){
      _imprimirVariables(a->der);
    }
}

//Funcion pública que nos permite imprimir el árbol
void imprimirArbol(abb a){
  printf("\n\n---------------------------Tabla de simbolos----------------------------\n");
  imprimir(a);
  printf("\n-----------------------------------------------------------------------\n\n");
}

void imprimirVariablesArbol(abb a){
  printf("\n\n---------------------------Variables-------------------------------------\n");
  _imprimirVariables(a);
  printf("\n-----------------------------------------------------------------------\n\n");
}

void funcionUnParametro(abb a,char *lexema,double input,double *result){
  if(strcmp(lexema,a->info.lexema)<0){
    funcionUnParametro(a->izq,lexema,input,result);
  }else if(strcmp(lexema,a->info.lexema)>0){
    funcionUnParametro(a->der,lexema,input,result);
  }else{
    *result = a->info.dato.funcion(input);
  }

}



void funcionDosParametro(abb a,char *lexema,double input1,double input2,double *result){
  if(strcmp(lexema,a->info.lexema)<0){
    funcionDosParametro(a->izq,lexema,input1,input2,result);
  }else if(strcmp(lexema,a->info.lexema)>0){
    funcionDosParametro(a->der,lexema,input1,input2,result);
  }else{
    *result = a->info.dato.funcion(input1,input2);
  }

}

void eliminaVariables(abb *a,int *n){
  int izq=0,der=0;
  if(*a != NULL){
    eliminaVariables(&(*a)->izq,&izq);
    eliminaVariables(&(*a)->der,&der);
    if(izq){
      (*a)->izq = NULL;
    }
    if(der){
      (*a)->der = NULL;
    }
    if((*a)->tipo==ID){
      free(((*a)->info.lexema));
      (*a)->info.lexema = NULL;
      free(*a);
      *a = NULL;
    }
  }
}
