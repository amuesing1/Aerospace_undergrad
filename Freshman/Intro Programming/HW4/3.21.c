#include<assert.h>
#include<stdio.h>
#include<stdlib.h>

int copyStringN(char * in, char * out, int n) {
int i=0;
if (!in || !out || !n) return -1;
while (in[i] != '\0') {out[i]=in[i];
if (i==n)
return -2;
i++;
}
out='\0';
return 0;
}

int main() {
char i[]="Hello";
char o[6];
int err=copyStringN(i,o,6);
assert(!err);
printf("%s\n",o);
return 0;
}
