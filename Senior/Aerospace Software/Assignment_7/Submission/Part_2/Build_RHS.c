#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include "BC.h"
#include "Source.h"

double * Build_RHS(int problem_num, int cells_per_side, double L) {
  // x_array=array of x positions
  // y_array=array of y positions
  // nodes_per_side=number of nodes per side
  int i,j;
  int nodes_per_side=cells_per_side+1;
  double *x_array, *y_array;
  x_array=(double *)malloc(nodes_per_side*sizeof(double));
  y_array=(double *)malloc(nodes_per_side*sizeof(double));
  for ( i = 0; i < nodes_per_side; i++) {
    x_array[i]=L*((double)(i)/(nodes_per_side-1.0));
    y_array[i]=L*((double)(i)/(nodes_per_side-1.0));
  }


  // Takes two-dimentional index(i,j) to single index
  double * index=malloc(nodes_per_side*nodes_per_side*sizeof(double));
  for ( i = 0; i < nodes_per_side; i++) {
    for ( j = 0; j < nodes_per_side; j++) {
      index[i*nodes_per_side+j]=i*nodes_per_side+j;
    }
  }
  double *F=(double *)malloc(pow(nodes_per_side,2)*sizeof(double));

  for ( i = 1; i < cells_per_side; i++) {
    for ( j = 1; j < cells_per_side; j++) {
      // determine position of center
      double x= x_array[i];
      double y= y_array[j];

      int index_center = index[i*nodes_per_side+j];

      F[index_center]=Source(problem_num,x,y);
    }
  }
// Boundary Assembly left and right
  for ( j = 0; j < nodes_per_side; j++) {
    double x_left=x_array[0];
    double x_right=x_array[nodes_per_side-1];
    double y=y_array[j];
    int i_right=nodes_per_side-1;
    int index_left=index[j];
    int index_right=index[i_right*nodes_per_side+j];
    F[index_left]=BC(problem_num,x_left,y);
    F[index_right]=BC(problem_num,x_right,y);
  }
  // Boundary Assembly top and bottom
  for ( i = 0; i < nodes_per_side; i++) {
    double x=x_array[i];
    double y_bottom=y_array[0];
    double y_top=y_array[nodes_per_side-1];
    int j_bottom = 0;
    int j_top = nodes_per_side-1;
    int index_bottom = index[i*nodes_per_side+j_bottom];
    int index_top = index[i*nodes_per_side+j_top];
    F[index_bottom]=BC(problem_num,x,y_bottom);
    F[index_top]=BC(problem_num,x,y_top);
  }
  return F;
}
