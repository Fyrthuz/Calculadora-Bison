%{
#include "tablasimbolos.h"
#include "definiciones.h"
#include "gestionerrores.h"
#include "analizadorSintactico.tab.h"

void leer(char *fichero);
void cerrar();
void activarimpresion();
void desactivarimpresion();

%}

%option noyywrap
%option yylineno
%option nounput
%option noinput

NUEVALINEA  \n
ESPACIO [ ]
SEPARADOR (\t|\r|{ESPACIO})+
PUNTOYCOMA  ;
COMA  ,
PUNTO \.

DIGITOS [0-9]
NUMERO_ENTERO [1-9]{DIGITOS}*|0

NUMERO_FLOTANTE [1-9]{DIGITOS}*\.[0-9]*|(0)?\.[0-9]*

NUMERO_NOTACION_CIENTIFICA [1-9]\.?{DIGITOS}*[eE][+-]?{NUMERO_ENTERO}

NUMERO {NUMERO_ENTERO}|{NUMERO_FLOTANTE}|{NUMERO_NOTACION_CIENTIFICA}


CARACTER [A-Za-z]|_
IDENTIFICADOR {CARACTER}({CARACTER})*

OPERADOR  [+*/%^,.!><()-;,]
ASIGNACION  =
SUMA_ASIGNACION \+=
MAS_MAS \+\+
RESTA_ASIGNACION -=
MENOS_MENOS --
MULT_ASIGNACION \*=
DIV_ASIGNACION  \/=
MENOR_IGUAL <=
MAYOR_IGUAL >=
DESIGUALDAD !=
IGUALDAD ==


ARCHIVO ({CARACTER}|[0-9]|\.)+


%x LECTURA

%%

"echo" return(IMPRIMIR);

"off" return(OFF);

"on"  return(ON);

"salir" {yylex_destroy();yyterminate();}

"verVariables"  return(VARIABLES);

"verInfoTabla"  return(TABLA);

"verAyuda"  return(AYUDA);

"leer"  {BEGIN(LECTURA); return(LEER);}

"clear" return(CLEAR);

<LECTURA>{ARCHIVO}  {
                      yylval.lexema = (char *)malloc(strlen(yytext)+1);
                      strncpy(yylval.lexema,yytext,strlen(yytext));
                      yylval.lexema[strlen(yytext)] = '\0';
                      BEGIN(INITIAL);
                      return(ARCHIVO);
                    }

{NUEVALINEA}  return((int)*yytext);

{SEPARADOR}

{IDENTIFICADOR} {
                                  yylval.lexema = (char *)malloc((strlen(yytext)+1)*sizeof(char));
                                  strncpy(yylval.lexema,yytext,strlen(yytext));
                                  yylval.lexema[strlen(yytext)] = '\0';
                                  return(IDENTIFICADOR);
                }


{NUMERO}        {yylval.num = atof(yytext);return(NUM);}


{OPERADOR}  return(((int)*yytext));
{ASIGNACION}  return(ASIGNACION);
{SUMA_ASIGNACION} return(SUMA_ASIGNACION);
{RESTA_ASIGNACION} return(RESTA_ASIGNACION);
{MULT_ASIGNACION} return(MULT_ASIGNACION);
{DIV_ASIGNACION}  return(DIV_ASIGNACION);
{MAS_MAS} return(MAS_MAS);
{MENOS_MENOS} return(MENOS_MENOS);
{MAYOR_IGUAL} return(MAYOR_IGUAL);
{MENOR_IGUAL} return(MENOR_IGUAL);
{DESIGUALDAD}  return(DESIGUALDAD);
{IGUALDAD}  return(IGUALDAD);

. {errorLexico(yylineno);}
<<EOF>> {cerrar();return'\n';}


%%
FILE *ficheros[1000];
int fichero=-1;

int print=1;

void activarimpresion(){
  print = 1;
}

void desactivarimpresion(){
  print = 0;
}

void leer(char *file){
  fichero++;
  if((ficheros[fichero] = fopen(file,"r"))==NULL){
    fichero--;
    errorArchivo(file);
    yyin=stdin;
  }else{
    if(fichero==1000){
      errorNumeroFicheros();
      for(int i=0;i<1000;i++){
        fclose(ficheros[i]);
        ficheros[i]='\0';
      }
      fichero=-1;
      yyin=stdin;
    }else{
      yyin=ficheros[fichero];
    }
  }

}


void cerrar(){
  fclose(ficheros[fichero]);
  ficheros[fichero]='\0';
  fichero--;
  if(fichero==-1){
    yyin=stdin;
    yyrestart(stdin);
  }else{
    yyin=ficheros[fichero];
  }
}
