# Calculadora-Bison
Este es un interprete matemático básico que permite el uso de scripts
y entrada de comandos por línea de comandos.

Usar opción -h para ver ayuda.
Usar opción -f para usar un fichero como script.


Version gcc 9.4.0

Version bison 3.5.1

Version flex 2.6.4

Version valgrind 3.15.0

Para compilar utiliza el comando "make"

Si compilas flex o bison tienes que insertar en el .h las macros de las funciones declaradas en estos
archivos para evitar warnings.

Para compilar flex: "flex --header-file="lex.yy.h" analizadorLexico.l"

Para compilar bison: "bison -d -Wconflicts-sr analizadorSintactico.y"

Para ejecutar: "./interpretematematico"

Para ejecutar para ver el uso de memoria: "valgrind --leak-check=full -s ./interpretematematico"


