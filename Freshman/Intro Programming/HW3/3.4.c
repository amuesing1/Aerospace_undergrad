#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

int sumArray(int *a, int len, int *sum){
if(!a || !sum) return -1;
int i;
for (i=0; i< len; i++)
*sum+=a[i];
return 0;
}

#define N 4
int main() {
int s;
int a[N];
int i;
for(i=0; i<N; i++)
a[i]=i;
sumArray(a, N, &s);
printf("%d\n", s);
return 0;
}
