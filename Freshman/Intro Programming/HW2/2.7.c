#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

int _mul(int n){
if (n==1){
 return 1;
}
else {
return _mul(n-1)*n;
}
}

int mul(int n, int *m){
if (n <=0 || m==NULL){
return -1;
}
else {
*m=_mul(n);
return 0;
}
}

int main() {
int m, n, err;
printf("Type a number:\n");
scanf("%d", &n);
err=mul(n,&m);
assert (err == 0);
printf("%d! is equal to:%d\n",n, m);
err=mul(-3, &m);
assert (err !=0);
return 0;
}
