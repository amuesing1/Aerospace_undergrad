#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define ELEM(mtx, row, col) \
  mtx->data[(col-1) * mtx->rows + (row-1)]

typedef struct {
  int rows;
  int cols;
  double * data;
}matrix;

matrix * newMatrix(int rows, int cols) {
  if (rows <= 0 || cols <= 0) return NULL;
  matrix * m = (matrix *) malloc(sizeof(matrix));
  m->rows = rows;
  m->cols = cols;
  m-> data = (double *) malloc(rows*cols*sizeof(double));
  int i;
  for (i = 0; i < rows*cols; i++)
    m->data[i] = 0.0;

  return m;
}
matrix * copyMatrix(matrix * mtx){
  if (!mtx) return NULL;
  matrix * cp = newMatrix(mtx->rows, mtx->cols);
  memcpy(cp->data, mtx->data,
       mtx->rows * mtx->cols *sizeof(double));

  return cp;
}
int deleteMatrix(matrix * mtx){
  if (!mtx) return -1;
  assert (mtx->data);
  free(mtx->data);
  free(mtx);
  return 0;
}
int setElement(matrix * mtx, int row, int col, double val){
  if (!mtx) return -1;
  assert (mtx->data);
  if (row <=0 || row> mtx->rows || col <=0 || col > mtx->cols)
    return -2;

  ELEM(mtx, row, col) = val;
  return 0;
}
int getElement(matrix * mtx, int row, int col, double * val){
  if (!mtx || !val) return -1;
  assert (mtx->data);
  if (row <= 0 || row > mtx->rows || col <= 0 || col > mtx->cols)
    return -2;
  *val = ELEM(mtx, row, col);
  return 0;
}
int nRows(matrix * mtx, int * n){
  if (!mtx || !n) return -1;
  *n = mtx ->rows;
  return 0;
}
int nCols(matrix * mtx, int * n){
  if (!mtx || !n) return -1;
  *n = mtx->rows;
  return 0;
}
int printMatrix(matrix * mtx){
  if (!mtx) return -1;

  int row, col;
  for (row = 1; row <= mtx->rows; row++) {
    for (col = 1; col <= mtx->cols; col++) {
      printf("% 6.2f", ELEM(mtx, row, col));
    }
    printf("\n");
  }
  return 0;
}
int transpose(matrix * in, matrix * out){
  if (!in || !out) return -1;
  if (!in->rows != out->cols || in->cols != out ->rows)
    return -2;

  int row,col;
  for (row = 1; row <= in->rows; row++)
    for (col = 1; col <= in->cols; col++)
      ELEM(out, col, row) = ELEM(in, row, col);
  return 0;
}
int sum(matrix * mtx1, matrix * mtx2, matrix * sum){
  if (!mtx1 || !mtx2 || !sum) return -1;
  if (mtx1->rows != mtx2->rows || mtx1->rows != sum->rows || mtx1->cols != mtx2->cols || mtx1->cols != sum->cols)
    return -2;

  int row, col;
  for (col = 1; col <= mtx1->cols; col++)
    for (row = 1; row <= mtx1->rows; row++)
      ELEM(sum, row, col) =
        ELEM(mtx1, row, col) + ELEM(mtx2, row ,col);
  return 0;
}
int product(matrix *mtx1, matrix * mtx2, matrix * prod){
  if (!mtx1 || !mtx2 || !prod ) return -1;
  if (mtx1->cols != mtx2->rows || mtx1->rows != prod->rows || mtx2->cols != prod->cols)
    return -2;

  int row, col, k;
  for (col = 1; col <= mtx2->cols; col++)
    for (row = 1; row <= mtx1->rows; row++) {
      double val = 0.0;
      for (k = 1; k <= mtx1->cols; k++)
        val += ELEM(mtx1, row, k) * ELEM(mtx2, k, col);
      ELEM(prod, row, col) = val;
    }
  return 0;
}
int dotProduct(matrix * v1, matrix * v2, double * prod){
  if (!v1 || !v2 || !prod) return -1;
  if (v1->rows != v2->rows) return -3;

  *prod = 0;
  int i;
  for (i = 1; i <= v1->rows; i++)
    *prod += ELEM(v1 , i, 1) * ELEM(v2, i, 1);
  return 0;
}

matrix * getColumn(matrix * mtx, int col){
  if(!mtx||col<1||col>mtx->cols) return 0;
  matrix * v;
  v = newMatrix(mtx->rows,1);
  int i,r;
  double val;
  nRows(mtx,&r);
  for(i=1;i<=r;i++){
    getElement(mtx,i,col,&val);
    setElement(v,i,1,val);
  }
return v;
}

matrix * getRow(matrix * mtx, int row){
  if(!mtx||row<1||row>mtx->rows) return 0;
  matrix * v;
  v = newMatrix(mtx->cols,1);
  int j,c;
  double val;
  nCols(mtx,&c);
  for(j=1;j<=c;j++){
    getElement(mtx,row,j,&val);
    setElement(v,1,j,val);
  }
return v;
}

int main(){
  matrix *A;
  A = newMatrix(3,3);
  setElement(A,1,1,0.1);
  setElement(A,1,2,0.2);
  setElement(A,1,3,0.3);
  setElement(A,2,1,0.1);
  setElement(A,2,2,0.2);
  setElement(A,2,3,0.3);
  setElement(A,3,1,0.1);
  setElement(A,3,2,0.2);
  setElement(A,3,3,0.3);

  matrix *B;
  B = newMatrix(1,3);
  B = getColumn(A,3);
  printMatrix(B);

  matrix *C;
  C = newMatrix(3,1);
  C = getRow(A,3);
  printMatrix(C);

  deleteMatrix(A);
  deleteMatrix(B);
  deleteMatrix(C);
  
  return 0;
}
