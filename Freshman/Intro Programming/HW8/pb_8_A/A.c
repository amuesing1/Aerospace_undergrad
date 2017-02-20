#include<stdio.h>
#include<stdlib.h>

static int icompare(void const * x, void const * y) {
  int ix = * (int *)x;
  int iy = * (int *)y;
  return ix - iy;
}

int main(void){
  size_t size=0, count=0;
  int *numbers=0;
  int a;
  int ret; 
  while ((ret=scanf("%d" ,&a)) !=EOF){
    if (ret!=1){
    printf("expected only integers\n");
    return -1;
    }
    if (count==size){
    int *tmp;
    size=(2*size)+1;
    tmp=realloc(numbers, size*sizeof(int));
      if (tmp==NULL){
      free(numbers);
      return -1;
      }
    numbers=tmp;
    }
  numbers[count]=a;
  count++;
  }
  qsort(numbers,count,sizeof(int),icompare);
  double median;
  int half=count/2;
  if (count%2==0){
    median=.5*(numbers[half]+numbers[half-1]);
  }
  else{
    median=numbers[half];
  }
  printf("The median is:%f\n", median);
  return 0;
}
