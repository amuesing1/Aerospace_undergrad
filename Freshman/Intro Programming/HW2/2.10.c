#include<stdlib.h>
#include<stdio.h>
int power(int a, int n, int *p){
int i;
if (n<=0||p==NULL)
return -1;
*p=a;
for (i=2;i<=n;i++) {
*p=*p*a;
}
return *p;
}

int main(){
int x,y,p;
printf("Type the base number:\n");
scanf("%d", &x);
printf("Type the exponent:\n");
scanf("%d", &y);
power(x,y,&p);
printf("%d^%d=%d\n",x,y,p);
return 0;
}
