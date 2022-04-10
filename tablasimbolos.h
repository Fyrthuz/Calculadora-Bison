
//Funcion que sirve para inicializar la tabla de símbolos
void inicializarTabla();
//Función que sirve para buscar o insertar un elemento en la tabla de símbolos
void insertar_id(char *cadena,double value);
//Funcion que sirve para imprimir la tabla de símbolos
void imprimirTabla();
//Función que sirve para liberar la memoria de la tabla de símbolos
void eliminarTabla();

short existe_id(char *lexema,short tipo);

void imprimirVariables();

double recupera_valor(char *lexema);

double ejecutaFuncionUnParametro(char *lexema,double input);

double ejecutaFuncionDosParametro(char *lexema,double input1,double input2);

void restauraEstado();

void eliminaVariable(char *lexema);
