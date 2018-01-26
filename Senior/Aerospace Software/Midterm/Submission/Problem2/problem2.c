#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(int argc, char **argv) {
  int h,i,j,k,m,n,o,p;

  // Block for opening files and finidng sizes
  int sizeA[1][2]={};
  FILE *fileA;
  fileA=fopen(argv[1], "r");
  for (h = 0; h < 2; h++) {
    fscanf(fileA,"%d",&sizeA[0][h]);
  }

  int sizeB[1][2]={};
  FILE *fileB;
  fileB=fopen(argv[2], "r");
  for (h = 0; h < 2; h++) {
    fscanf(fileB,"%d",&sizeB[0][h]);
  }
  m=sizeA[0][0];
  n=sizeA[0][1];
  p=sizeB[0][0];
  o=sizeB[0][1];

  // Check if they can be multiplied
  if (n!=p) {
    printf("Cannot multiply. Wrong size arrays. %s %s\n",argv[1],argv[2]);
    exit(1);
  }
  else if (n==p) {
    // read in the arrays
    double** mat_A=malloc(m*sizeof(double*));
    double** mat_B=malloc(p*sizeof(double*));
    for(i = 0; i < m; i++)
    {
      mat_A[i]=malloc(n*sizeof(double));
      for(j = 0; j < n; j++)
      {
        if (!fscanf(fileA, "%lf", &mat_A[i][j]))
        break;
      }
    }
    for(i = 0; i < p; i++)
    {
      mat_B[i]=malloc(o*sizeof(double));
      for(j = 0; j < o; j++)
      {
        if (!fscanf(fileB, "%lf", &mat_B[i][j]))
        break;
      }
    }
    fclose(fileA);
    fclose(fileB);

    // making the file name
    // Checking for slashs (if calling from directory)

    int k,flag1=0,flag2=0;
    char newA[15];
    char newB[15];
    for ( i = 1; i <= 2; i++) {
      int j=0,l=0;
      while (argv[i][j] != '\0'){
        // checking if the name is inside directory
        if (argv[i][j] == '/'){
          if (i==1) {
            flag1=1;
          } else if (i==2) {
            flag2=1;
          }
          // read in backwards until you hit a "/"
          k=strlen(argv[i])-1;
          while (k!=0) {
            if (argv[i][k] == '/') {
              break;
            }
            else {
              if (flag1==1 && i==1) {
                newA[l]=argv[i][k];
              } else if (flag2==1 && i==2) {
                newB[l]=argv[i][k];
              }
              l++;
            }
            k--;
          }
          if (flag1==1 && i==1) {
            newA[k]=0;
          } else if (flag2==1 && i==2) {
            newB[k]=0;
          }
          // reverse the string
          if (i==1) {
            int a,b;
            char temp;
            a=0;
            b = strlen(newA) - 1;
            while (a < b) {
              temp = newA[a];
              newA[a] = newA[b];
              newA[b] = temp;
              a++;
              b--;
            }
          }
          else if (i==2) {
            int a,b;
            char temp;
            a=0;
            b = strlen(newB) - 1;
            while (a < b) {
              temp = newB[a];
              newB[a] = newB[b];
              newB[b] = temp;
              a++;
              b--;
            }
          }
        }
        j++;
      }
    }
    char final[50],mult[7];
    if (flag1==1) {
      strcpy(final,newA);
    }
    else {
      strcpy(final,argv[1]);
    }
    strcat(final,"_mult_");
    if (flag2==1) {
      strcat(final,newB);
    }
    else {
      strcat(final,argv[2]);
    }

    // Making the file
    FILE *f = fopen(final, "w");
    if (f == NULL)
    {
      printf("Error opening file!\n");
      exit(1);
    }
    fprintf(f, "%d %d\n",m,o ); // print the array size

    // multiplying the arrays
    double** mat_C=malloc(m*sizeof(double*));
    for(i = 0; i < m; i++)
    {
      mat_C[i]=(double*)malloc(o*sizeof(double));
    }
    for(i=0;i<m;i++){
      for(j=0;j<o;j++){
        mat_C[i][j]=0;
        for(k=0;k<n;k++){
          mat_C[i][j]+=mat_A[i][k]*mat_B[k][j];
        }
        fprintf(f,"%lf ",mat_C[i][j]);
      }
      fprintf(f,"\n");
    }
    fclose(f);
    return 0;
  }
}
