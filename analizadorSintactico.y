%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "lex.yy.h"
#include "tablasimbolos.h"
#include "definiciones.h"

extern int yylex();
void yyerror(char* s);
void verAyuda();

%}

%union{
double num;
char *lexema;
};

%start input;

%token  <num> NUM
%token  <lexema>  IDENTIFICADOR
%token  <lexema>  ARCHIVO

%token  VARIABLES
%token  TABLA
%token  AYUDA
%token  LEER
%token  CLEAR

%token  ASIGNACION
%token  SUMA_ASIGNACION
%token  MAS_MAS
%token  MENOS_MENOS
%token  RESTA_ASIGNACION
%token  MULT_ASIGNACION
%token  DIV_ASIGNACION
%token  DESIGUALDAD
%token  IGUALDAD
%token  MENOR_IGUAL
%token  MAYOR_IGUAL

%right ASIGNACION
%right '^'
%left '+'
%left '-'
%left '*'
%left '/'
%left '%'
%left '<'
%left '>'
%left MAYOR_IGUAL
%left DESIGUALDAD
%left IGUALDAD
%left MENOR_IGUAL
%left NEG
%left SUMA_ASIGNACION
%left MAS_MAS
%left MENOS_MENOS
%left RESTA_ASIGNACION
%left MULT_ASIGNACION
%left DIV_ASIGNACION

%type <num> expresion
%type <num> igualacion
%type <num> comparacion
%type <num> operacion
%type <num> funcion


%%
input:   /**/ {printf(">>>>");}
        | input line
;

line:
        '\n'
        | expresion '\n'{printf("\n>>>>");}
            | expresion ';' '\n' {if(!isnan($1)){printf("%lf",$1);}printf("\n>>>>");}
            | error{yyclearin;printf(">>>>");}
;

expresion:
              NUM {$$ = $1;}
              | IDENTIFICADOR {if(existe_id($1,ID) || existe_id($1,CONST)){
              $$ = recupera_valor($1);
              }else {yyerror("Variable sin inicializar");$$=NAN;}free($1);}
              | VARIABLES {imprimirVariables();}
              | TABLA {imprimirTabla();}
              | AYUDA {verAyuda();}
              | igualacion
              | comparacion
              | operacion
              | funcion
              | '(' expresion ')' {$$ = $2;}
              | limpiar {$$=NAN;}
              | LEER ARCHIVO {printf("Ejecutando script %s\n",$2);leer($2);free($2);}

;

limpiar:  CLEAR {restauraEstado();}
;

igualacion: IDENTIFICADOR ASIGNACION expresion {if(!existe_id($1,CONST)){
                                                  insertar_id($1,$3);
                                                  $$ = $3;
                                                }else yyerror("No se puede modificar una constante");free($1);}
          | IDENTIFICADOR MAS_MAS {if(existe_id($1,ID)){
                                    insertar_id($1,recupera_valor($1)+1);
                                    $$ = recupera_valor($1);
                                  }else yyerror("Variable no inicializada");free($1);}
          | IDENTIFICADOR MENOS_MENOS {if(existe_id($1,ID)){
                                    insertar_id($1,recupera_valor($1)-1);
                                    $$ = recupera_valor($1);
                                  }else yyerror("Variable no inicializada");free($1);}
          | IDENTIFICADOR SUMA_ASIGNACION expresion {if(existe_id($1,ID)){
                                    insertar_id($1,recupera_valor($1)+$3);
                                    $$ = recupera_valor($1);
                                  }else yyerror("Variable no inicializada");free($1);}
          | IDENTIFICADOR RESTA_ASIGNACION expresion {if(existe_id($1,ID)){
                                    insertar_id($1,recupera_valor($1)-$3);
                                    $$ = recupera_valor($1);
                                  }else yyerror("Variable no inicializada");free($1);}
          | IDENTIFICADOR MULT_ASIGNACION expresion {if(existe_id($1,ID)){
                                    insertar_id($1,recupera_valor($1)*$3);
                                    $$ = recupera_valor($1);
                                  }else yyerror("Variable no inicializada");free($1);}
          | IDENTIFICADOR DIV_ASIGNACION expresion {if(existe_id($1,ID)){
                                    insertar_id($1,recupera_valor($1)/$3);
                                    $$ = recupera_valor($1);
                                  }else yyerror("Variable no inicializada");free($1);}


comparacion: expresion '<' expresion {if($1<$3 && !isnan($1) && !isnan($3)){printf("True\n");
                                    }else if(!isnan($1) && !isnan($3)){printf("False\n");}else{
                                    yyerror("Error sintáctico en la igualdad");
                                    }$$=NAN;}
             | expresion '>' expresion {if($1>$3 && !isnan($1) && !isnan($3)){printf("True\n");
                                      }else if(!isnan($1) && !isnan($3)){printf("False\n");}else{
                                      yyerror("Error sintáctico en la igualdad");
                                      }$$=NAN;}
             | expresion MENOR_IGUAL expresion {if($1<=$3 && !isnan($1) && !isnan($3)){printf("True\n");
                                      }else if(!isnan($1) && !isnan($3)){printf("False\n");}else{
                                      yyerror("Error sintáctico en la igualdad");
                                      }$$=NAN;}
             | expresion MAYOR_IGUAL expresion {if($1>=$3 && !isnan($1) && !isnan($3)){printf("True\n");
                                      }else if(!isnan($1) && !isnan($3)){printf("False\n");}else{
                                      yyerror("Error sintáctico en la igualdad");
                                      }$$=NAN;}
             | expresion DESIGUALDAD expresion {if($1!=$3 && !isnan($1) && !isnan($3)){printf("True\n");
                                      }else if(!isnan($1) && !isnan($3)){printf("False\n");}else{
                                      yyerror("Error sintáctico en la igualdad");
                                      }$$=NAN;}
             | expresion IGUALDAD expresion {if(fabs($1-$3)<=0.00001 && !isnan($1) && !isnan($3)){printf("True\n");
                                      }else if(!isnan($1) && !isnan($3)){printf("False\n");}else{
                                      yyerror("Error sintáctico en la igualdad");
                                      }$$=NAN;}

operacion: expresion '+' expresion{$$ = $1 + $3;}
          | expresion '-' expresion{$$ = $1 - $3;}
          | expresion '*' expresion{$$ = $1 * $3;}
          | expresion '/' expresion{if($3!=0){$$ = $1 / $3;}else {yyerror("No se puede realizar una division con un 0 en el denominador");$$=NAN;}}
          | expresion '%' expresion{$$ = (int)$1 % (int)$3;}
          | '-' expresion %prec NEG{$$=-$2;}
          | '+' expresion %prec NEG{$$=$2;}

funcion:  IDENTIFICADOR '(' expresion ')' {if(existe_id($1,FUNC)){
                                            $$ = ejecutaFuncionUnParametro($1,$3);
                                          }else yyerror("Esta funcion no existe");free($1);}
         | IDENTIFICADOR '(' expresion ',' expresion ')' {if(existe_id($1,FUNC)){
                                                     $$ = ejecutaFuncionDosParametro($1,$3,$5);
                                                   }else yyerror("Esta funcion no existe");free($1);}
         | expresion '^' expresion {if(existe_id("^",FUNC)){
                                                     $$ = ejecutaFuncionDosParametro("^",$1,$3);
                                                   }else yyerror("Esta funcion no existe");}
%%

void yyerror(char* s){
  printf("Error: %s\n",s);
}

void verAyuda(){
  printf("\n--------FUNCIONALIDADES---------\n"
        "\nEsta calculadora soporta funciones matemáticas básicas, declaración de variables y la ejecución de algunas funciones matemáticas básicas\n"
        "No soporta operaciones con matrices ni vectores.\nLa ejecucion normal se realiza mediante la consola de comandos o si el usuario lo desea mediante la carga de un script.\n\n"
        "\n-----ARGUMENTOS DE EJECUCION------\n"
        "\nAl ejecutar esta aplicacion mediante la consola de comandos, esta permite ejecutar con diferentes opciones:\n"
        "\t-Opcion \"-h\": Muestra este mensaje de ayuda por pantalla\n"
        "\t-Opcion \"-f\": Permite cargar un script al inicio de la ejecucion\n\n"
        "\n----------PALABRAS CLAVE----------\n"
        "\n\t\"verInfoTabla\": Muestra por pantalla el contenido de toda la tabla de simbolos\n"
        "\t\"verVariables\": Muestra por pantalla el contenido de las variables declaradas\n"
        "\t\"VerInfoTabla\": Muestra por pantalla el contenido de toda la tabla de simbolos\n"
        "\t\"leer\": Carga un script (tiene que usarse con el siguiente formato \"leer nombrescript\")\n"
        "\t\"clear\": Limpia el workspace en mitad de la ejecucion, destruyendo todas las variables declaradas\n"
        "\t\"salir\": Termina la ejecucion del programa\n\n"
        "\n----------COMPARACIONES-----------\n"
        "\n\tMayor >\n"
        "\tMayor igual >=\n"
        "\tMenor <\n"
        "\tMenor igual <=\n"
        "\tIgual ==\n"
        "\tDiferente !=\n\n"
        "\n-------------VARIABLES------------\n"
        "\nPara declara una variable se necesita seguir el siguiente patron: \"nombre_variable = valor\"\n"
        "\nDestacar que el nombre de la variable tiene que ser una cadena alfanumerica (tambien admite _)\n\n"
        "\n-------------CONSTANTES------------\n"
        "\n\tpi = 3.14159265359\n"
        "\te = 2.71828182845\n\n"
        "\n-------------FUNCIONES------------\n"
        "\n\tsin()\tCalcula el seno en radianes\n"
        "\tcos()\tCalcula el coseno en radianes\n"
        "\ttan()\tCalcula la tangente en radianes\n"
        "\tasin()\tCalcula el arcoseno en radianes\n"
        "\tacos()\tCalcula el arcocoseno en radianes\n"
        "\tatan()\tCalcula la arcotangente en radianes\n"
        "\tsinh()\tCalcula el seno hiperbolico en radianes\n"
        "\tcosh()\tCalcula el coseno hiperbolico en radianes\n"
        "\ttanh()\tCalcula la tangente hiperbolica en radianes\n"
        "\tlog10()\tCalcula el logaritmo en base 10\n"
        "\tln()\tCalcula el logaritmo neperiano\n"
        "\texp()\tEleva \"e\" al exponente indicado\n"
        "\tsqrt()\tCalcula la raiz cuadrada de un numero\n"
        "\tceil()\tCalcula el redondeo a la alta de un numero\n"
        "\tfloor()\tCalcula el redondeo a la baja de un numero\n"
        "\tfabs()\tCalcula el valor absoluto de un numero\n"
        "\tpow( , )\tCalcula la potencia del primer parametro elevado al segundo parametro\n"
        "\tfmod( , )\tCalcula el modulo del primer argumento entre el segundo\n\n\n"
      );
}
