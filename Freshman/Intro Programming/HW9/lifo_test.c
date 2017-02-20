#include <assert.h>
#include <stdio.h>

#include "lifo.h"

static void printString(void * e) {
  printf("%s", (char *) e);
}

static void printLong(void * e) {
  printf("%ld", (long) e);
}

int main(void) {
  lifo longq, stringq;
  void * e;
  int err;

  /* test with strings */

  stringq = newLifo(3);
  assert(isEmptyLifo(stringq));

  printf("stringq (empty): ");
  printLifo(stringq, printString);

  err = putLifo(stringq, "Hello"); assert(!err);
  err = putLifo(stringq, "there"); assert(!err);
  err = putLifo(stringq, "universe"); assert(!err);

  err = putLifo(stringq, "!"); assert(err);

  printf("stringq (3 elements): ");
  printLifo(stringq, printString);

  err = getLifo(stringq, &e); assert(!err);
  printf("from stringq (Hello): %s\n", (char *) e);

  err = putLifo(stringq, "!"); assert(!err);

  printf("stringq (3 elements): ");
  printLifo(stringq, printString);

  err = getLifo(stringq, &e); assert(!err);
  printf("from stringq (!): %s\n", (char *) e);
  err = getLifo(stringq, &e); assert(!err);
  printf("from stringq (there): %s\n", (char *) e);
  err = getLifo(stringq, &e); assert(!err);
  printf("from stringq (Hello): %s\n", (char *) e);

  assert(isEmptyLifo(stringq));
  err = getLifo(stringq, &e); assert(err);
  assert(!e);

  deleteLifo(stringq);

  /* test with longs */
  longq = newLifo(3);

  assert(isEmptyLifo(longq));

  printf("longq (empty): ");
  printLifo(longq, printLong);

  err = putLifo(longq, (void *) 1); assert(!err);
  err = putLifo(longq, (void *) 2); assert(!err);
  err = putLifo(longq, (void *) 3); assert(!err);

  err = putLifo(longq, (void *) 4); assert(err);

  printf("longq (3 elements): ");
  printLifo(longq, printLong);

  err = getLifo(longq, &e); assert(!err);
  printf("from longq (1): %ld\n", (long) e);

  err = putLifo(longq, (void *) 4); assert(!err);

  printf("longq (3 elements): ");
  printLifo(longq, printLong);

  err = getLifo(longq, &e); assert(!err);
  printf("from longq (4): %ld\n", (long) e);
  err = getLifo(longq, &e); assert(!err);
  printf("from longq (2): %ld\n", (long) e);
  err = getLifo(longq, &e); assert(!err);
  printf("from longq (1): %ld\n", (long) e);

  assert(isEmptyLifo(longq));
  err = getLifo(longq, &e); assert(err);
  assert(!e);

  deleteLifo(longq);

  return 0;
}
