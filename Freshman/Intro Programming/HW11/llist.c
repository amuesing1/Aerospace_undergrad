#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "lifo.h"

typedef struct _node{
  struct _node * next;
  void * e;
} * node;

static node newNode(void * e) {
  node n = (node) malloc(sizeof(struct _node));
  n->next = NULL;
  n->e = e;
  return n;
}

static void deleteNode(node n){
  assert (n);
  free (n);
}

struct _lifo {
  int capacity;
  int size;
  node head;
};

lifo newLifo(int capacity) {
  lifo q = (lifo) malloc(sizeof(struct _lifo));
  if (capacity <= 0) capacity = -1;
  q->capacity = capacity;
  q->head = NULL;
  q->size = 0;
  return q;
}

void deleteLifo(lifo q) {
  assert(q);
  node n = q->head;
  while (n != NULL) {
    q->head = n->next;
    deleteNode(n);
  }
  free(q);
}

int isEmptyLifo(const_lifo q) {
  assert(q);
  return (q->size == 0);
}

int putLifo(lifo q, void * e) {
  assert(q);
  if ((q->size) == q->capacity) /* full? */
    return -1;
  node n = newNode(e);
  n->next = q->head;
  q->head = n;
  q->size++;
  return 0;
}

int getLifo(lifo q, void ** e) {
  assert(q);
  if (!e) return -1;
  if (isEmptyLifo(q)) {
    *e = NULL;
    return -2;
  }
  node n = q->head;
  q->head = q->head->next;
  *e = n->e;
  deleteNode(n);
  q->size--;
  return 0;
}

int printLifo(const_lifo q, printLn l) {
  assert(q);
  if (!l) return -1;
  int cnt = 1;
  node n;
  for (n = q->head; n != NULL; n = n->next) {
    printf(" %d:", cnt);
    l(n->e);
    cnt++;
  }
  printf("\n");
  return 0;
}
