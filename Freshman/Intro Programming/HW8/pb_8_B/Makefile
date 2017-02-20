# Variables
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -pedantic -g
LDLIBS = -lm
PROG = coord_test
SRC = $(PROG).c coord.c
HDR = coord.h
OBJ = $(SRC:.c=.o)

# Targets
$(PROG): $(OBJ)
$(OBJ): $(HDR)
TAGS: $(SRC) $(HDR)
	etags $^
.PHONY: clean
clean:
	$(RM) $(PROG) $(OBJ)
