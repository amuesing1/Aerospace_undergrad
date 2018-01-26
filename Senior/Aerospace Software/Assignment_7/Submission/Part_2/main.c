#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<lapacke.h>
#include "Build_LHS.h"
#include "Build_RHS.h"
#include "Output.h"

int main(int argc, char **argv) {
  double L;
  if (atof(argv[2])==5) {
    L=0.025;
  } else {
    L=1.0;
  }
  double * K=Build_LHS(atof(argv[2]),atof(argv[1]),L);
  double * F=Build_RHS(atof(argv[2]),atof(argv[1]),L);
  int N=(int)pow(atof(argv[1])+1,2);
  int ipiv[N];
  int info;
  int NRHS = 1;
  // Solve system of linear equations
  dgesv_(&N,&NRHS,K,&N,ipiv,F,&N,&info);
  // Output to file
  Output(atof(argv[2]),atof(argv[1]),L,F);
  return 0;
}
