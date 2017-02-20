#include<assert.h>
#include<stdio.h>
int minmax(int a, int b, int *min, int *max){
if (a<b){
return 0;
}
else if (b<a) {
*max=a;
*min=b;
return 0;
}
else {
return -1;
}
}
int main(void){
int x=3;
int y=7;
int rv=minmax(x,y,&x,&y);
assert (rv==0);
assert (y>x);

printf("The maximum number is: %d\n", y);
printf("The minimum number is: %d\n", x);
return 0;
}
