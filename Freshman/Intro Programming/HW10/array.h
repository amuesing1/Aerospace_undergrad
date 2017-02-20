#ifndef ARRAY_H_
#define ARRAY_H_

typedef struct _array * array;
typedef struct _array const * const_array;

/* Return a new array with no elements.
 * Return NULL if creation fails. */
array newArray(void);
/* Free array a. */
void deleteArray(array a);
/* Change the size of array a.
 * Return 0 if successful and -1 if resizing fails. */
int resizeArray(array a, size_t newSize);
/* Write the size of array a to the location pointed by num.
 * Return 0 if succesful and -1 if a is an invalid pointer. */
int arrayNum(const_array a, size_t * num);
/* Write the i-th element of array a to the location
 * pointed by e.  Return 0 if successful and -1 otherwise. */
int arrayGet(const_array a, size_t i, void ** e);
/* Add element e at the end of array a.  Return 0 if
 * successful and -1 otherwise. */
int arrayPushBack(array a, void * e);
/* Set the i-th element of array a to e.  Return 0 if
 * successful and -1 otherwise.  The i-th element of a
 * must already exist.  */
int arrayPut(array a, size_t i, void * e);
/* Type of function to print the content of one array cell. */
typedef void (* printFn)(void const * e);
/* Print contents of array. */
int printArray(const_array a, printFn f);
/* Type of function to compare two array elements. */
typedef int (* compareFn)(void const * x, void const * y);
/* Sort array a using f for comparisons.  Return 0 if successful and
 * -1 otherwise.  */
int sortArray(array a, compareFn f);
#endif
