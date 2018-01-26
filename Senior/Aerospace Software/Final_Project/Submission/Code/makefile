# This is a makefile. I'm sure we'll need / want this at some point

.PHONY: clean

CC = gcc
LFLAGS = -Wall -Os -g
CFLAGS = -Wall -Os -g -c

stock_predictor: main.o ReadFile.o beta.o alpha.o Output.o
	$(CC) $(LFLAGS) -o $@ $^ -fopenmp -pg

main.o: main.c ReadFile.h beta.h alpha.h Output.h
	$(CC) $(CFLAGS) $< -fopenmp -pg

ReadFile.o: ReadFile.c ReadFile.h
	$(CC) $(CFLAGS) $< -pg

beta.o: beta.c beta.h
	$(CC) $(CFLAGS) $< -pg

alpha.o: alpha.c alpha.h beta.h
	$(CC) $(CFLAGS) $< -pg

Output.o: Output.c Output.h
	$(CC) $(CFLAGS) $< -pg

clean:
	rm -rf *.o stock_predictor

# This is the slow code makefile
# .PHONY: clean

# CC = gcc
# LFLAGS = -Wall -g
# CFLAGS = -Wall -g -c

# stock_predictor_slow: slow_main.o ReadFile.o beta.o alpha.o Output.o
# 	$(CC) $(LFLAGS) -o $@ $^ -fopenmp -pg

# slow_main.o: slow_main.c ReadFile.h beta.h alpha.h Output.h
# 	$(CC) $(CFLAGS) $< -fopenmp -pg

# ReadFile.o: ReadFile.c ReadFile.h
# 	$(CC) $(CFLAGS) $< -pg

# beta.o: beta.c beta.h
# 	$(CC) $(CFLAGS) $< -pg

# alpha.o: alpha.c alpha.h beta.h
# 	$(CC) $(CFLAGS) $< -pg

# Output.o: Output.c Output.h
# 	$(CC) $(CFLAGS) $< -pg

# clean:
# 	rm -rf *.o stock_predictor