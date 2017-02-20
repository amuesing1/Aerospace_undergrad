#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

typedef struct  {
  int rows, cols;
  double * data;
} matrix;

matrix * newMatrix(int rows, int cols);
void deleteMatrix(matrix * mtx);
int setElement(matrix * mtx, int row, int col,
               double val);
int getElement(matrix const * mtx, int row, int col,
               double * val);
int printMatrix(matrix const * mtx);
int isSquare(matrix const * mtx);
int product(matrix const * mtx1, matrix const * mtx2,
            matrix * prod);
int isIdentity(matrix const * m);
/* Copies a submatrix of A to B starting at element
 * (row,col) and filling B.  Returns 0 if successful
 * and -1 otherwise.
 */
int submatrix(matrix const * A, matrix * B, int row, int col);
/* Performs Gauss-Jordan elimination of A putting
 * result in GJ.  Matrix A should have at least as
 * many columns as rows.  Matrix GJ should have the
 * same dimensions as A.  Returns 0 if successful
 * and -1 otherwise. */
int gaussJordan(matrix const * A, matrix * GJ);

int main(void) {
  matrix * R, * GJ, * Ad, * Ai, * I;
  int err;

  R = newMatrix(6, 12); assert(R);
  err = setElement(R, 2, 1, 2.0); assert(!err);
  err = setElement(R, 1, 2, 1.0); assert(!err);
  err = setElement(R, 3, 2, 3.0); assert(!err);
  err = setElement(R, 2, 3, 2.0); assert(!err);
  err = setElement(R, 4, 3, 1.0); assert(!err);
  err = setElement(R, 3, 4, 1.0); assert(!err);
  err = setElement(R, 5, 4, 3.0); assert(!err);
  err = setElement(R, 4, 5, 2.0); assert(!err);
  err = setElement(R, 6, 5, 2.0); assert(!err);
  err = setElement(R, 5, 6, 1.0); assert(!err);

  err = setElement(R, 1, 7,  1.0); assert(!err);
  err = setElement(R, 2, 8,  1.0); assert(!err);
  err = setElement(R, 3, 9,  1.0); assert(!err);
  err = setElement(R, 4, 10, 1.0); assert(!err);
  err = setElement(R, 5, 11, 1.0); assert(!err);
  err = setElement(R, 6, 12, 1.0); assert(!err);

  GJ = newMatrix(6, 12); assert(GJ);
  err = gaussJordan(R, GJ); assert(!err);
  Ad = newMatrix(6, 6); assert(Ad);
  Ai = newMatrix(6, 6); assert(Ai);
  I = newMatrix(6, 6); assert(I);
  printf("\nOriginal Matrix:\n");
  printMatrix(R);
  printf("\nHere is the Inverse matrix: \n");
  printMatrix(GJ);
  printf("\n");
  err = submatrix(R, Ad, 1, 1); assert(!err);
  err = submatrix(GJ, Ai, 1, 7); assert(!err);
  printf("\nAd:\n");
  err = printMatrix(Ad); assert(!err);
  printf("\nAi:\n");
  err = printMatrix(Ai); assert(!err);
  err = product(Ad, Ai, I); assert(!err);
  if (isIdentity(I)) {
    printf("\nAi is the inverse of Ad\n");
  } else {
    /* The problem may be rounding. Let's look at the result. */
    printf("\nAi is not the inverse of Ad.  Their product is:\n");
    err = printMatrix(I); assert(!err);
  }
  deleteMatrix(Ad);
  deleteMatrix(Ai);
  deleteMatrix(I);
  deleteMatrix(R
      );
  deleteMatrix(GJ);

  return 0;
}

/* Library implementation. */

double getE(matrix const * mtx, int row, int col) {
  return mtx->data[(col-1) * mtx->rows + row - 1];
}

void setE(matrix * mtx, int row, int col, double val) {
  mtx->data[(col-1) * mtx->rows + row - 1] = val;
}

int badArgs(matrix const * mtx, int row, int col) {
  if (!mtx || !mtx->data)
    return -1;
  if (row <= 0 || row > mtx->rows ||
      col <= 0 || col > mtx->cols)
    return -2;
  return 0;
}

matrix * newMatrix(int rows, int cols) {
  int i;
  matrix * m;
  if (rows <=0 || cols <= 0) return NULL;

  /* allocate a matrix structure */
  m = (matrix *) malloc(sizeof(matrix));
  if (!m) return NULL;

  /* set dimensions */
  m->rows = rows;
  m->cols = cols;

  /* allocate a double array of length rows * cols */
  m->data = (double *)malloc(rows*cols*sizeof(double));
  if (!m->data) {
    free(m);
    return NULL;
  }
  /* set all data to 0 */
  for (i = 0; i < rows*cols; i++)
    m->data[i] = 0.0;

  return m;
}

void deleteMatrix(matrix * mtx) {
  if (mtx) {
    /* free mtx's data */
    free(mtx->data);
    /* free mtx itself */
    free(mtx);
  }
}

int setElement(matrix * mtx, int row, int col,
               double val) {
  int err = badArgs(mtx, row, col);
  if (err) return err;
  setE(mtx, row, col, val);
  return 0;
}

int getElement(matrix const * mtx, int row, int col,
               double * val) {
  int err = badArgs(mtx, row, col);
  if (err) return err;
  if (!val) return -1;

  *val = getE(mtx, row, col);
  return 0;
}

int printMatrix(matrix const * mtx) {
  int row, col;

  if (!mtx) return -1;

  for (row = 1; row <= mtx->rows; row++) {
    for (col = 1; col <= mtx->cols; col++) {
      /* Print the floating point element with
       *  - either a - if negative of a space if positive
       *  - at least 3 spaces before the .
       *  - precision to the hundredths place */
      printf("% 6.2f ", getE(mtx, row, col));
    }
    /* separate rows by newlines */
    printf("\n");
  }
  return 0;
}

int isSquare(matrix const * mtx) {
  return mtx && mtx->rows == mtx->cols;
}

int product(matrix const * mtx1, matrix const * mtx2,
            matrix * prod) {
  int row, col, k;
  if (!mtx1 || !mtx2 || !prod) return -1;
  if (mtx1->cols != mtx2->rows ||
      mtx1->rows != prod->rows ||
      mtx2->cols != prod->cols)
    return -2;

  for (col = 1; col <= mtx2->cols; col++)
    for (row = 1; row <= mtx1->rows; row++) {
      double val = 0.0;
      for (k = 1; k <= mtx1->cols; k++)
        val += getE(mtx1, row, k) * getE(mtx2, k, col);
      setE(prod, row, col, val);
    }
  return 0;
}

int isIdentity(matrix const * m) {
  int row, col;
  if (!isSquare(m)) return 0;
  for (col = 1; col <= m->cols; col++)
    for (row = 1; row <= m->rows; row++)
      if (row != col) {
        if (getE(m, row, col) != 0.0)
          return 0;
      } else {
        if (getE(m, row, col) != 1.0)
          return 0;
      }
  return 1;
}

int submatrix(matrix const * A, matrix * B, int row, int col) {
  int i, j;
  if (!A || !B || B->rows + row - 1 > A->rows || B->cols + col - 1 > A->cols)
    return -1;
  for (j = 1; j <= B->cols; j++)
    for (i = 1; i <= B->rows; i++)
      setE(B, i, j, getE(A, i + row - 1, j + col - 1));
  return 0;
}

/* Finds a suitable pivot in column j of M and
 * permutes rows if needed to bring said pivot
 * to row j.  Returns 0 if successful and -1 if
 * a pivot is not found.
 */
static int pivot(matrix * M, int j) {
  int k = j;
  int v = 1;
  double e, f;
  while(k <= M->rows){
    if (getE(M, k, j) == 0.00){
      k++;
    }
    else if(getE(M, k, j) != 0.00){
      while(v <= M->cols){
        getElement(M, j, v, &e);
        getElement(M, k, v, &f);
        setElement(M, j, v, f);
        setElement(M, k, v, e);
        v++;
      }
      return 0;
    }
  }
  return -1;
}

/* Puts column j of matrix M in row echelon form.
 * That is, 1 on the diagonal, and 0 below.  The rest
 * of the matrix is adjusted accordingly.
 */
static void rowEchelon(matrix * M, int j) {
  int k = j + 1;
  int v = 1;
  double e, f, g, h;
  if (getE(M, j, j) != 1.00){
    getElement(M, j, j, &e);
    while (v <= M->cols){
      f = getE(M, j, v) / e;
      setElement(M, j, v, f);
      v++;
    }
  }
  v = 1;
  while (k <= M->rows){
    if (getE(M, k, j) == 0.00){
      k++;
    }
    else if(getE(M, k, j) != 0.00){
      getElement(M, k, j, &e);
      while (v <= M->cols){
        f = getE(M, j, v) * e;
        setElement(M, j, v, f);
        g = getE(M, k, v) - getE(M, j, v);
        setElement(M, k, v, g);
        v++;
      }
      v = 1;
      while (v <= M->cols){
        getElement(M, j, j, &e);
        h = getE(M, j, v) / e;
        setElement(M, j, v, h);
        v++;
      }
      k++;
    }
  }
}

/* Puts column j of matrix M in reduced row
 * echelon form. That is, 1 on the diagonal and 0
 * elsewhere.  The column is supposed to be
 * already in row echelon form.  The rest
 * of the matrix is adjusted accordingly.
 */
static void reducedRowEchelon(matrix * M, int j) {
  int k = j - 1;
  int v = 1;
  double e, f, g, h;
  while (k > 0) {
    if (getE(M, k, j) == 0.00){
      k--;
    }
    else if(getE(M, k, j) != 0.00){
      getElement(M, k, j, &e);
      while (v <= M->cols){
        f = getE(M, j, v) * e;
        setElement(M, j, v, f);
        g = getE(M, k, v) - getE(M, j, v);
        setElement(M, k, v, g);
        v++;
      }
      v = 1;
      while (v <= M->cols){
        getElement(M, j, j, &e);
        h = getE(M, j, v) / e;
        setElement(M, j, v, h);
        v++;
      }
      k--;
    }
  }
}

/* Extremely naive implementation. */
int gaussJordan(matrix const * A, matrix * GJ) {
  int i;
  /* Check for malformed input */
  if (!A || !GJ || A->rows != GJ->rows || A->cols != GJ->cols)
    return -1;
  if (A->rows > A->cols)
    return -1;
  /* Initialize GJ to a copy of A. */
  memcpy(GJ->data, A->data,
         A->rows * A->cols * sizeof(double));
  /* Gaussian elimination. */
  for (i = 1; i <= GJ->rows; i++) {
    if (pivot(GJ, i) == -1)
      return -1; /* rank-deficient */
    rowEchelon(GJ, i);
  }
  /* Zero entries above diagonal. */
  for (i = GJ->rows; i > 0; i--) {
    reducedRowEchelon(GJ, i);
  }
  return 0;
}
