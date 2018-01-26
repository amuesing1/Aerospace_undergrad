#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include<cblas.h>

int * getSize(const char * name) {
  int i;
  int* sizeA=malloc(2 * sizeof(int));
  FILE *fileA;
  fileA=fopen(name, "r");
  for (i = 0; i < 2; i++) {
    fscanf(fileA,"%d",&sizeA[i]);
  }
  return sizeA;
}

double * populate(const char * name)
{
  int i,j;
  int* sizeA=malloc(2 * sizeof(int));
  FILE *fileA;
  fileA=fopen(name, "r");
  for (i = 0; i < 2; i++) {
    fscanf(fileA,"%d",&sizeA[i]);
  }
  double * mat=malloc(sizeA[0]*sizeA[1]*sizeof(double));
  for (i = 0; i < sizeA[0]; i++)
  for (j = 0; j < sizeA[1]; j++)
  fscanf(fileA,"%lf",&mat[i*sizeA[1]+j]);
  return mat;
}
void mat_add(double* A,double* B, int n) {
  cblas_daxpy(n,1,A,1,B,1);
}

void mat_subtract(double* A,double* B, int n) {
  cblas_daxpy(n,-1,B,1,A,1);
}

void mat_mult(double* A, double* B, double* new,int m,int n,int k) {
  cblas_dgemm(CblasRowMajor,CblasNoTrans,CblasNoTrans,m,n,k,1.0,A,k,B,n,1.0,new,n);
}

int main(int argc, char **argv) {
  int i,j,m,n,p,o,q,r;

  int *sizeA=getSize(argv[1]);
  int *sizeB=getSize(argv[2]);
  int *sizeC=getSize(argv[3]);
  m=sizeA[0];
  n=sizeA[1];
  o=sizeB[0];
  p=sizeB[1];
  q=sizeC[0];
  r=sizeC[1];

  double * A=populate(argv[1]);
  double * B=populate(argv[2]);
  double * C=populate(argv[3]);

  if (n!=o || p!=q) {
    printf("Cannot multiply %s %s %s. Wrong size arrays.\n",argv[1],argv[2],argv[3]);
  }
  else {
    double * E=(double*) calloc(m*r, sizeof(double));
    double * D=(double*) calloc(m*p, sizeof(double));
    mat_mult(A,B,D,m,p,n);
    mat_mult(D,C,E,m,r,q);

    char * name_with_extension;
    char * middle = "_mult_";
    name_with_extension = malloc(strlen(argv[1])+strlen(middle)+strlen(argv[2])+strlen(middle)+strlen(argv[3]));
    strcpy(name_with_extension,argv[1]);
    strcat(name_with_extension,middle);
    strcat(name_with_extension,argv[2]);
    strcat(name_with_extension,middle);
    strcat(name_with_extension,argv[3]);

    FILE *new_file;

    new_file = fopen(name_with_extension,"w");
    fprintf(new_file,"%d %d\n",m,r);

    for (i = 0; i < m; i++)
    {
      for (j = 0; j < r; j++){
        fprintf(new_file,"%lf ",D[i*r+j]);
      }
      fprintf(new_file,"\n");
    }

    fclose(new_file);
    free(D);
    free(E);
    free(name_with_extension);
  }
  if (n!=o || m!=q || p!=r) {
    printf("Cannot perform %s %s +- %s. Wrong size arrays.\n",argv[1],argv[2],argv[3]);
  }
  else {
    double * D=(double*) calloc(m*p, sizeof(double));
    double * C_copy_add=C;
    mat_mult(A,B,D,m,p,n);
    mat_add(D,C_copy_add,q*r);
    mat_subtract(D,C,q*r);

    char * middle = "_mult_";
    char * middle2 = "_plus_";
    char * middle3 = "_minus_";

    char * name_with_extension;
    name_with_extension = malloc(strlen(argv[1])+strlen(middle)+strlen(argv[2])+strlen(middle2)+strlen(argv[3]));
    strcpy(name_with_extension,argv[1]);
    strcat(name_with_extension,middle);
    strcat(name_with_extension,argv[2]);
    strcat(name_with_extension,middle2);
    strcat(name_with_extension,argv[3]);

    FILE *new_file;

    new_file = fopen(name_with_extension,"w");
    fprintf(new_file,"%d %d\n",m,p);

    for (i = 0; i < m; i++)
    {
      for (j = 0; j < r; j++)
      fprintf(new_file,"%lf ",C_copy_add[i*r+j]);
      fprintf(new_file,"\n");
    }

    fclose(new_file);
    free(name_with_extension);
    name_with_extension = malloc(strlen(argv[1])+strlen(middle)+strlen(argv[2])+strlen(middle3)+strlen(argv[3]));
    strcpy(name_with_extension,argv[1]);
    strcat(name_with_extension,middle);
    strcat(name_with_extension,argv[2]);
    strcat(name_with_extension,middle3);
    strcat(name_with_extension,argv[3]);

    new_file = fopen(name_with_extension,"w");
    fprintf(new_file,"%d %d\n",m,p);

    for (i = 0; i < m; i++)
    {
      for (j = 0; j < r; j++)
      fprintf(new_file,"%lf ",D[i*r+j]);
      fprintf(new_file,"\n");
    }
    free(D);
    fclose(new_file);
    free(name_with_extension);
  }
  if (p!=q || m!=o || n!=r) {
    printf("Cannot perform %s +- %s %s. Wrong size arrays.\n",argv[1],argv[2],argv[3]);
  }
  else {
    double * D=(double*) calloc(o*r, sizeof(double));
    mat_mult(B,C,D,o,r,p);
    double * D_copy=D;
    mat_add(A,D,m*n);
    mat_subtract(A,D_copy,m*n);

    char * middle = "_mult_";
    char * middle2 = "_plus_";
    char * middle3 = "_minus_";

    char * name_with_extension;
    name_with_extension = malloc(strlen(argv[1])+strlen(middle2)+strlen(argv[2])+strlen(middle)+strlen(argv[3]));
    strcpy(name_with_extension,argv[1]);
    strcat(name_with_extension,middle2);
    strcat(name_with_extension,argv[2]);
    strcat(name_with_extension,middle);
    strcat(name_with_extension,argv[3]);

    FILE *new_file;

    new_file = fopen(name_with_extension,"w");
    fprintf(new_file,"%d %d\n",o,r);

    for (i = 0; i < m; i++)
    {
      for (j = 0; j < r; j++)
      fprintf(new_file,"%lf ",D[i*r+j]);
      fprintf(new_file,"\n");
    }

    fclose(new_file);
    free(name_with_extension);
    name_with_extension = malloc(strlen(argv[1])+strlen(middle3)+strlen(argv[2])+strlen(middle)+strlen(argv[3]));
    strcpy(name_with_extension,argv[1]);
    strcat(name_with_extension,middle3);
    strcat(name_with_extension,argv[2]);
    strcat(name_with_extension,middle);
    strcat(name_with_extension,argv[3]);

    new_file = fopen(name_with_extension,"w");
    fprintf(new_file,"%d %d\n",o,r);

    for (i = 0; i < m; i++)
    {
      for (j = 0; j < r; j++)
      fprintf(new_file,"%lf ",A[i*r+j]);
      fprintf(new_file,"\n");
    }
    free(D);
    fclose(new_file);
    free(name_with_extension);
  }
  return 0;
}
