#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

int mean(int *a, int len, int *mn) {
if (a==NULL || mn==NULL || len<=0)
return -1;
int i;
int s;
for (i=0;i<len;i++)
s+=a[i];
*mn=s/len;
return 0;
}
int main() {
int a[]={-1,4,2};
int x;
mean(a, 3, &x);
assert(x==1);
printf("%d\n",x);
return 0;
}

