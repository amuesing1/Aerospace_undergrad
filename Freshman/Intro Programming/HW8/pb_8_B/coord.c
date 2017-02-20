#include <complex.h>
#include "coord.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

coord newCoord(void){
  coord c = (coord) malloc(sizeof(double complex));
  if (!c){
    printf("Error allocate\n");
    exit(-1);
  }
  *c = 0.0 + 0.0*I;
  return c;
}

void deleteCoord(coord c){
  assert(c);
  free(c);
}

void setX(coord c, double x){
  assert(c);
  double y = cimag(*c);
  *c = x + y*I;
}

void setY(coord c, double y){
  assert(c);
  double x = creal(*c);
  *c = x + y*I;
}

double getX(const_coord c){
  assert(c);
  double x = creal(*c);
  return x;
}

double getY(const_coord c){
  assert(c);
  double y = cimag(*c);
  return y;
}

double getR(const_coord c){
  assert(c);
  double a = (creal(*c) * creal(*c) + (cimag(*c) * cimag(*c))), r;
  r = sqrt(a);
  return r;
}
double getTheta(const_coord c){
  assert(c);
  double th = atan2(cimag(*c), creal(*c));
  return th;
}

void setR(coord c, double r){
  assert(c);
  double th = carg(*c);
  *c = r + th*I;
}

void setTheta(coord c, double th){
  assert(c);
  double r = cabs(*c);
  *c = r + th*I;
}
