#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "lifo.h"

struct _lifo {
  unsigned capacity;
  unsigned head;
  unsigned tail;
  void * data[1];
};

lifo newLifo(int capacity) {
  lifo q;
  assert(capacity > 0);

  /* The capacity of a circular buffer is one less than
   * one would think: if the user wants a given
   * capacity, the required array is one cell larger.
   */
  capacity++;

  /* allocate one chunk of memory */
  q = (lifo) malloc(sizeof(struct _lifo) +
                    (capacity-1) * sizeof(void *));
  q->capacity = (unsigned) capacity;
  q->head = 0;
  return q;
}

void deleteLifo(lifo q) {
  free(q);
}

int isEmptyLifo(const_lifo q) {
  assert(q);
  return q->head == 0;
}

int putLifo(lifo q, void * e) {
  assert(q);
  if ((q->head+1) >= q->capacity) /* full? */
    return -1;
  q->data[q->head] = e;
  q->head++;
  return 0;
}

int getLifo(lifo q, void ** e) {
  assert(q);
  if (!e) return -1;
  if (isEmptyLifo(q)) {
    *e = NULL;
    return -2;
  }
  while(q->head > 0){
    *e = q->data[q->head-1];
    q->head--;
    return 0;
  }
  return -1;
}

int printLifo(const_lifo q, printLn l) {
  unsigned i, cnt;
  assert(q);
  if (!l) return -1;
  cnt = 1;
  for (i = q->head; i > 0; i--) {
    printf(" %d:", cnt);
    l(q->data[q->head-i]);
    cnt++;
  }
  printf("\n");
  return 0;
}
