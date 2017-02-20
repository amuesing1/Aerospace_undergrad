#ifndef COORD_H_
#define COORD_H_

#include <complex.h>

/* The type declaration of the ADT. */
typedef double complex * coord;
typedef double complex const * const_coord;

/* Create a coordinate. */
coord newCoord(void);

/* Deletes a coordinate. */
void deleteCoord(coord c);

/* "getters" */
double getX(const_coord c);
double getY(const_coord c);

/* Returns the radius component. */
double getR(const_coord c);

/* Returns the angle component. */
double getTheta(const_coord c);

/* "setters" */
/* For Cartesian coordinates. */
void setX(coord c, double x);
void setY(coord c, double y);

/* Set the radius/angle components. */
void setR(coord c, double r);
void setTheta(coord c, double th);

#endif
