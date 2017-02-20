CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -pedantic -g

SRC = lifo_test.c buffer.c
HDR = lifo.h
OBJ = $(SRC:.c=.o)
TARGET = lifo_test

$(TARGET): $(OBJ)
$(OBJ): $(HDR)
TAGS: $(SRC) $(HDR)
	etags $^
tags: $(SRC) $(HDR)
	ctags $^
.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJ)
