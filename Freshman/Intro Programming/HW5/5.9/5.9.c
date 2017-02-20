#include<stdio.h>

int main() {
int r;
printf("type 1 for encrypt, type 2 for decrypt\n");
scanf("%d", &r);
char c;
if (r==1){
while (scanf("%c", &c) !=EOF){
c+=1;
printf("%c", c);
}}
if (r==2){
while (scanf("%c", &c) !=EOF){
c=c-1;
printf("%c", c);
}}
if (r!=1||r!=2) return -1;
printf("\n");
return 0;
}
