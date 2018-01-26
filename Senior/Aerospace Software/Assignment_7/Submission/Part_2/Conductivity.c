#include<stdio.h>
#include<stdlib.h>

int Conductivity(int problem_num, double x, double y) {
  int k;
  if (problem_num==1) {
    k=1; //W/mK
  }
  else if (problem_num==2) {
    k=1; //W/mK
  }
  else if (problem_num==3) {
    k=1; //W/mk
  }
  else if (problem_num==4) {
    if (x>0.5) {
      k=20; //W/mK
    }
    else {
      k=1; //W/mK
    }
  }
  else if (problem_num==5) {
    if (x>=0.01 && x<=0.015 && y>=0.01 && y<=0.015) {
      k=167; //W/mK
    } else {
      k=157; //W/mK
    }
  }
  return k;
}
