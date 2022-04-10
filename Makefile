CC= gcc -Wall
HEADER_FILES_DIR = .
INCLUDES = -I $(HEADER_FILES_DIR)
MAIN= interpretematematico
SRCS = main.c estructura.c tablasimbolos.c gestionerrores.c analizadorSintactico.tab.c lex.yy.c
DEPS = $(HEADER_FILES_DIR)/estructura.h definiciones.h tablasimbolos.h gestionerrores.h analizadorSintactico.tab.h lex.yy.h
OBJS = $(SRCS:.c=.o)
$(MAIN): $(OBJS)
	$(CC) -o $(MAIN) $(OBJS) -lm
	rm -f *.o *~
%.o: %.c $(DEPS)
	$(CC) -c $< $(INCLUDES)
cleanall: clean
	rm -f $(MAIN)
clean:
	rm -f *.o *~
