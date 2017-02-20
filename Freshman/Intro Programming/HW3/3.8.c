#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

int minmax(int *a, int n, int *min, int *max) {
if (a==NULL || min==NULL || max==NULL)
return -1;
if (n<=0)
return -2;
int i;
int s=a[0];
int b=a[0];
for(i=0; i<n; i++)
if(a[i] < s)
s=a[i];
for(i=0; i<n; i++)
if(b < a[i])
b=a[i];
*min=s;
*max=b;
return 0;
}

int main() {
int a[] = {-9,4,-2,10,8};
int x;
int y;
minmax(a,5,&x,&y);
assert(x==-9);
assert(y==10);
return 0;
}
