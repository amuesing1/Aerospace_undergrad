#include<stdio.h>

int main() {
int r;
printf("type 1 for shout, type 2 for whisper\n");
scanf("%d", &r);
char c;
if (r==1) {
while (scanf("%c", &c) !=EOF) {
if ('a' <=c && c <='z')
c +='A' - 'a';
printf("%c", c);
}
}
if (r==2) {
while (scanf("%c", &c) !=EOF) {
if ('A' <=c && c <='Z')
c +='a'-'A';
printf("%c", c);
}
}
if (r!=1 || r!=2) return -1;
printf("\n");
return 0;
}
