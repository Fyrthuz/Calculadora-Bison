//Puntero a una direccion de memoria es un tipo opaco desde fuera no se sabe la estructura del abb
typedef void* abb;

//Creamos el arbol binarios de busqueda
void crea(abb *a);
//Destruimos yel arbol binario y liberamos la memoria
void destruye(abb *a);
//Inserta y busca (sirve para ambas funciones)un lexema en la tabla de símbolos cuando se lee un lexema durante la ejecución del compildor
void inserta_identificador(abb *a, char *lexema,double value);
void inserta_funcion(abb *a, char *lexema,double(*funcion)());
void inserta_constante(abb *a, char *lexema,double flotante);
//Imprimimos el arbol binario
void imprimirArbol(abb a);

void imprimirVariablesArbol(abb a);

void existe(abb a,char *lexema,short tipo,short *n);

double recupera(abb a,char *lexema);

double funcionUnParametro(abb a,char *lexema,double input,double *result);

void funcionDosParametro(abb a,char *lexema,double input1,double input2,double *result);

void restauraEstadoArbol(abb *a);

void eliminaVariables(abb *a,int *n);
