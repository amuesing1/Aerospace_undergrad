#include <stdio.h>
#include <stdlib.h>
#include "array.h"

struct _array {
  size_t capacity; /* elements allocated */
  size_t inUse;    /* elements currently in use */
  void ** data;    /* actual data */
};

array newArray(void) {
  array a;
  a = (array) malloc(sizeof(struct _array));
  if (!a) return NULL;
  a->capacity = 1; /* parsimonious */
  a->inUse = 0;
  a->data = (void **) malloc(sizeof(void *) * a->capacity);
  if (!a->data) {
    free(a);
    return NULL;
  }
  return a;
}

void deleteArray(array a) {
  free(a->data);
  free(a);
}

int resizeArray(array a, size_t newSize) {
  if (newSize > a->capacity) {
    /* To avoid too many calls to realloc, we choose the larger of
     * twice the current size and the new requested size. */
    size_t newCapacity = 2 * a->capacity;
    if (newCapacity < newSize)
      newCapacity = newSize;
    void ** tmp = (void **) realloc(a->data, newCapacity * sizeof(void *));
    /* If the allocation fails, leave the array alone. */
    if (!tmp) return -1;
    a->data = tmp;
    a->capacity = newCapacity;
  }
  a->inUse = newSize;
  return 0;
}

int arrayNum(const_array a, size_t * num) {
  if (!a || !num) return -1;
  *num = a->inUse;
  return 0;
}

int arrayGet(const_array a, size_t index, void ** e) {
  if (!a || !e || index >= a->inUse) return -1;
  *e = a->data[index];
  return 0;
}

int arrayPushBack(array a, void * e) {
  if (!a || !e) return -1;
  size_t i;
  i=a->inUse+1;
  resizeArray(a,i);
  a->data[a->inUse-1] = e;
  return 0;
}

int arrayPut(array a, size_t index, void * e) {
  if (!a || !e || index >= a->inUse) return -1;
  a->data[index] = e;
  return 0;
}

int printArray(const_array a, printFn f) {
  if(a==NULL||f==NULL) return -1;
  size_t i;
  for(i=0;i<a->inUse;i++){
    printf("%zu:",i);
    f(a->data[i]);
  }
  return 0;
}

int sortArray(array a, compareFn f) {
  if(!a || !f) return -1;
  qsort(a->data, a->inUse, sizeof(void**), f);
  return 0;
}
