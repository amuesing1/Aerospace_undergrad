#include<stdio.h>
#include<stdlib.h>
#include<math.h>

double Source(int problem_num, double x, double y){
  double f;
  if (problem_num==1) {
    f=0; //W/m^3
  }
  else if (problem_num==2) {
    f=2*(y*(1-y)+x*(1-x)); //W/m^3
  }
  else if (problem_num==3) {
    f=exp(-50*sqrt(pow((x-.5),2)+pow((y-.5),2))); //W/m^3
  }
  else if (problem_num==4) {
    if (x<0.1) {
      f=1; //W/m^3
    } else {
      f=0; //W/m^3
    }
  }
  else if (problem_num==5) {
    if (x>=0.01 && x<=0.015 && y>=0.01 && y<=0.015) {
      f=1600000; //W/m^3
    } else {
      f=0; //W/m^3
    }
  }
  return f;
}
