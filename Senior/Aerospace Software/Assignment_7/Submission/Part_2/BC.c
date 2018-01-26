#include<stdio.h>
#include<stdlib.h>

double BC(int problem_num, double x, double y) {
  double g;
  if (problem_num==1) {
    g=x;
  }
  else if (problem_num==2) {
    g=0.0;
  }
  else if (problem_num==3) {
    g=0.0;
  }
  else if (problem_num==4) {
    g=0.0;
  }
  else if (problem_num==5) {
    g=343.0;
  }
  return g;
}
