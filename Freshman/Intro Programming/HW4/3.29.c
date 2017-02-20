#include<assert.h>
#include<stdio.h>
#include<stdlib.h>

int strcmp(char *str1, char *str2) {
if (str1==NULL || str2==NULL)
return 0;
int i;
int j;
for (i=0;str1[i];i++){
for (j=0;str2[j];j++){
if (str1[i+j]<str2[j])
return -1;
if (str1[i+j]>str2[j])
return 1;
if (str1[i+j]>str2[j])
return 0;
}}
return 0;
}

int main() {
printf("aardvark, aardwolf %d\n", strcmp("aardvark", "aardwolf"));
printf("AVAST, avast %d\n", strcmp("AVAST", "avast"));
printf("ahoy, ahoy %d\n", strcmp("ahoy", "ahoy"));
printf("Watch for aardvarks!, "
	"Watches aren't for aardwolves. %d\n",
	strcmp("Watch for aardvarks!",
		"Watches aren't for aardwolves."));
printf("zoology, zoo %d\n", strcmp("zoology", "zoo"));
return 0;
}
