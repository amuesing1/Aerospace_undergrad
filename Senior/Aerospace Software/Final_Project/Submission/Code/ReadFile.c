#include <stdio.h>
#include <stdlib.h>

double *ReadFile(char Ticker[],int number_of_rows){

char filename[20];

snprintf(filename,20,"StockData/%s.csv",Ticker);

FILE *filehandle = fopen(filename,"r");

int i;

double read_split, total_split = 1;

double *Price = (double *)malloc(sizeof(double *)*number_of_rows);

for (i = 0; i < number_of_rows; i++){
	fscanf(filehandle,"%*f%*c%*f%*c%*f%*c%lf%*c%lf",&Price[i],&read_split);
	if (read_split != 1) {
		total_split = read_split*total_split;
	}
	Price[i] = total_split*Price[i];
}

fclose(filehandle);

return Price;

}
