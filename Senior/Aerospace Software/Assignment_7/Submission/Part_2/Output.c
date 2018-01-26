#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void Output(int problem_num, int cells_per_side, double L, double * d){
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
  char cellstr[10],problemstr[10];
  sprintf(cellstr, "%1.0d", cells_per_side);
  sprintf(problemstr, "%1.0d", problem_num);
  char * name_of_the_file;
  char * start = "heat_solution_";
  char * middle = "_";
  name_of_the_file = malloc(strlen(start)+strlen(cellstr)+strlen(middle)+strlen(problemstr));
  strcpy(name_of_the_file,start);
  strcat(name_of_the_file,cellstr);
  strcat(name_of_the_file,middle);
  strcat(name_of_the_file,problemstr);

  FILE *new_file;

  new_file = fopen(name_of_the_file,"w");
  for (i = 0; i < nodes_per_side; i++)
  {
    for (j = 0; j < nodes_per_side; j++){
      fprintf(new_file,"%lf ",x_array[i]);
      fprintf(new_file,"%lf ",y_array[j]);
      fprintf(new_file,"%lf ",d[(int)index[i*nodes_per_side+j]]);
      fprintf(new_file,"\n");
    }
  }

  fclose(new_file);
}
