#include <assert.h>
#include <stdio.h>
int _mul(int n) {
assert (n>0);
int i=2, s=1;
while (i <=n) {
s=s*i;
i=i+1;
}
return s;
}
int mul(int n,int *s) {
if (n <= 0||s==NULL)
return -1;
*s=_mul(n);
return 0;
}

int main(){
int f, s, err;
printf("Type number here:\n");
scanf("%d", &f);
err=mul(f,&s);
assert (err==0);
printf("%d! is equal to:%d\n", f, s);
err=mul(-3, &s);
assert (err !=0);
return 0;
}
