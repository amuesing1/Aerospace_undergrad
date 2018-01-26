#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include "Conductivity.h"

double * Build_LHS(int problem_num, int cells_per_side, double L) {
  // h=Mesh Size
  // x_array=array of x positions
  // y_array=array of y positions
  // nodes_per_side=number of nodes per side
  int i,j;
  double h=(1.0/(double)cells_per_side);
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
  double *K=malloc(pow(nodes_per_side,4)*sizeof(double));

  for ( i = 1; i < cells_per_side; i++) {
    for ( j = 1; j < cells_per_side; j++) {
      // determine position of center
      double x= x_array[i];
      double y= y_array[j];

      // determine the indicies assocaited with five-point stencil
      int index_center = index[i*nodes_per_side+j];
      int index_bottom = index[i*nodes_per_side+j-1];
      int index_top = index[i*nodes_per_side+j+1];
      int index_left = index[(i-1)*nodes_per_side+1];
      int index_right = index[(i+1)*nodes_per_side+j];

      // determine conductivities
      int kappa_bottom=Conductivity(problem_num,x,y-(h/2));
      int kappa_top=Conductivity(problem_num,x,y+(h/2));
      int kappa_left=Conductivity(problem_num,x-(h/2),y);
      int kappa_right=Conductivity(problem_num,x+h,y);

      // determine contributions to LHS matrix
      K[index_center*(int)pow(nodes_per_side,2)+index_center]=(kappa_bottom+kappa_top+kappa_left+kappa_right)/pow(h,2);
      K[index_center*(int)pow(nodes_per_side,2)+index_bottom]=(-kappa_bottom)/pow(h,2);
      K[index_center*(int)pow(nodes_per_side,2)+index_top]=(-kappa_top)/pow(h,2);
      K[index_center*(int)pow(nodes_per_side,2)+index_left]=(-kappa_left)/pow(h,2);
      K[index_center*(int)pow(nodes_per_side,2)+index_right]=(-kappa_right)/pow(h,2);
    }
  }
  // Boundary Assembly left and right
  for ( j = 0; j < nodes_per_side; j++) {
    int i_right=nodes_per_side-1;
    int index_left=index[j];
    int index_right=index[i_right*nodes_per_side+j];
    K[index_left*(int)pow(nodes_per_side,2)+index_left]=1;
    K[index_right*(int)pow(nodes_per_side,2)+index_right]=1;
  }
  // Boundary Assembly top and bottom
  for ( i = 0; i < nodes_per_side; i++) {
    int j_bottom = 0;
    int j_top = nodes_per_side-1;
    int index_bottom = index[i*nodes_per_side+j_bottom];
    int index_top = index[i*nodes_per_side+j_top];
    K[index_bottom*(int)pow(nodes_per_side,2)+index_bottom] = 1;
    K[index_top*(int)pow(nodes_per_side,2)+index_top] = 1;
  }
  return K;
}
