#include<stdio.h>

int main(int argc, char **argv) {
if (argc !=3) {
printf("*cough* Expected precisely two arguments.\n");
return -1;
}
int n;
int m;
if (sscanf(argv[1], "%d",&n)==0 || sscanf(argv[2], "%d",&m)==0) {
printf("Erm, expected an integer.\n");
return -1;
}
int sum=0;
for (m=1;m <= n; m++) sum +=m;
printf("Sum: %d\n",sum);
return 0;
}
