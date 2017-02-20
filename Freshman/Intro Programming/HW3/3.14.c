#include <stdlib.h>
#include <stdio.h>

int unzip(int *a, int *b, int *c, int n) {
if (!a || !b || !c) return -1;
int i;
for (i=0; i<n; i++) {
a[i]=c[2*i];
b[i]=c[2*i+1];
}
return 0;
}

#define n 3
int main() {
int c[]={1,2,3,4,5,6};
int a[n];
int b[n];
unzip(a,b,c,n);
return 0;
}
