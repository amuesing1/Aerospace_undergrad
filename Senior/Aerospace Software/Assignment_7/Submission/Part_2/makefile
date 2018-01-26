# Makefile for Assignment 7

.PHONY: clean

CC = gcc
LFLAGS = -Wall -O3
CFLAGS = -Wall -O3 -c

heat_solve: main.o BC.o Source.o Conductivity.o Build_LHS.o Build_RHS.o Output.o
	$(CC) $(LFLAGS) -o $@ $^ -lm -llapack -lblas -lgfortran

main.o: main.c Build_RHS.h Build_LHS.h Output.h
	$(CC) $(CFLAGS) $<

BC.o: BC.c
	$(CC) $(CFLAGS) $<

Source.o: Source.c
	$(CC) $(CFLAGS) $<

Conductivity.o: Conductivity.c
	$(CC) $(CFLAGS) $<

Build_LHS.o: Build_LHS.c Conductivity.h
	$(CC) $(CFLAGS) $<

Build_RHS.o: Build_RHS.c BC.h Source.h
	$(CC) $(CFLAGS) $<

Output.o: Output.c
	$(CC) $(CFLAGS) $<

clean:
	rm -rf *.o heat_solve
