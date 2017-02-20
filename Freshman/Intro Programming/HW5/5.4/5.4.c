#include<stdio.h>

void printUsage() {
printf("Usage: min < [data file], where the file is a nonempty list of integers\n");
}

int main() {
int min;
int max;

if (scanf("%d", &min) !=1) {
printUsage();
return -1;
}

int c, val;
while ((c=scanf("%d", &val)) !=EOF) {
if (c == 0) {
printUsage();
return -1;
}
if (val < min)
min = val;
if (val > max)
max = val;
}
printf("%d is the range\n", max-min);
return 0;
}
