#include<assert.h>
#include<stdlib.h>
#include<stdio.h>

int suffix(char *str, char *suf) {
if (!suf || !str) return 0;
int i;
int j;
for (i=8;str[i];i--);
for (j=4;suf[j];j++);
if (suf[i-j] != str[i])
return 0;
return 1;
}

int main(){
char str[]="playing";
char suf[]="ing";
int err=suffix(str,suf);
if (err!=1) 
printf("%s is not a suffix of %s\n", suf, str);
else printf("%s is a suffix of %s\n", suf, str);
return 0;
}
