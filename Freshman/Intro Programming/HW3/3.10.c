#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

int numOccur(int a[], int n, int v, int *occ) {
int i;
if (a==NULL || occ==NULL)
return -1;
if (n<0)
return -2;
for(i=0;i<n;i++)
if (a[i]==v)
*occ=*occ+1;
return 0;
}

#define n 5
int main() {
int a[]={4,4,4,5,6};
int x;
numOccur(a, 5, 4, &x);
printf("%d\n",x);
return 0;
}
