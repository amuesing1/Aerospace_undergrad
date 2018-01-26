#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void Output(char *name, int size, int *months, double *betas, double *alphas, double *alpha_trend){
  char * name_of_the_file;
  char * buying_patterns = "_buying_patterns.txt";
  name_of_the_file = malloc(5+strlen(buying_patterns));
  strcpy(name_of_the_file,name);
  strcat(name_of_the_file,buying_patterns);

  FILE *new_file;

  new_file = fopen(name_of_the_file,"w");
  int i;
  for (i = 0; i < size; i++){
    fprintf(new_file,"%d ",months[i]);
    fprintf(new_file,"%lf ",betas[i]);
    fprintf(new_file,"%lf ",alphas[i]);
    fprintf(new_file,"%lf ",alpha_trend[i]);
    fprintf(new_file,"\n");
  }


  fclose(new_file);
free(name_of_the_file);
}
