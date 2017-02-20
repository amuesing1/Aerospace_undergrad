#include<stdio.h>

int main() {
int a,e,i,o,u=0;
char c;
while (scanf("%c", &c) != EOF) {
if (c == 'a' || c == 'A')
a+=a+1;
if (c == 'e' || c == 'E')
e+=e+1;
if (c == 'i' || c == 'I')
i+=i+1;
if (c == 'o' || c == 'O')
o+=o+1;
if (c == 'u' || c == 'u')
u+=u+1;
}
printf("a:%d\ne:%d\ni:%d\no:%d\nu:%d\n", a, e, i, o, u);
return 0;
}
