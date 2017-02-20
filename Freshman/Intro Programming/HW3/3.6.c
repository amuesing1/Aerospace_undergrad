#include <assert.h>
#include <stdlib.h>

int vectorSum(int x[], int y[], int n, int sum[]) {
if (x == NULL || y == NULL || sum == NULL)
return -1;
if (n <= 0)
return -2;

int i;
for (i=0;i<n;i++)
sum[i]=x[i]+y[i];
return 0;
}

#define n 4
int main() {
int x[n],y[n],s[n];
vectorSum(x,y,n,s);
return 0;
}
