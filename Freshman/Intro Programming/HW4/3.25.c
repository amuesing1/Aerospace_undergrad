#include<assert.h>
#include<stdlib.h>
#include<stdio.h>

int streq(char *str1,char *str2) {
if (str1==NULL || str2==NULL) return 0;
int i;
int j;
for (i=0;str1[i];i++) {
for (j=0;str2[j];j++) {
if (str1[i+j]!=str2[j]) return 0;
}
if (str1[i+j]==str2[j]) return 1;
}
return 0;
}

int main() {
char str1[]="Waz up";
char str2[]="Waz up";
int err=streq(str1,str2);
if (err!=1){ printf("str1 does not equal str2\n");}
else{ printf("str1 is equal to str2\n");}
return 0;
}
