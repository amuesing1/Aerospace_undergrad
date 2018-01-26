#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <omp.h>
#include "ReadFile.h"
#include "beta.h"
#include "alpha.h"
#include "Output.h"

int main(int argc, char *argv[]){

	clock_t start = clock();

	int number_of_rows = 9100, number_of_stocks = 45; // # of stocks does NOT include S&P500

	char tickers[46][6] = {"SP500", "AAPL", "XOM", "AXP", "LMT", "NYT", "WMT",
	"NKE", "AET", "ALCO", "ALE", "BMY", "BRT", "CAT", "DCO", "DD", "DIS", "EMR",
	"FDX", "FL", "GE", "GTY", "IBM", "JNJ", "KO", "LLY", "MMM","MO","MRK","MSI",
	"NAV","NC","PBI","PCG","PEI","PEP","PFE","SJW","SPA","SYY","TXN","UIS","UTX","WFC","WY","XRX"};

	int k;
	for (k = 1; k <= number_of_stocks; k++) {

		double *BaselinePrice = ReadFile(tickers[0],number_of_rows);
		double *Price = ReadFile(tickers[k],number_of_rows);

		int i,j = 0;

		int *Good_i = (int *)malloc(sizeof(int *)*(number_of_rows));
		double *all_beta = (double *)malloc(sizeof(double *)*(number_of_rows));

		double Beta, Alpha;

		for (i = 0; i < (number_of_rows); i++){
			Beta = beta(Price[i],BaselinePrice[i],Price[i+1],BaselinePrice[i+1]);
			if ((Price[i*+1]-Price[i]) > 0 && abs(Beta) > 1){
				Good_i[j] = i;
				all_beta[j]=Beta;
				// printf("%d\n",i );
				j++;
				// You've decided to buy the stock if these two conditions are met (ie it's trending up and it has a "large" beta value)
			}
		}

		i = 0;
		double *all_alpha = (double *)malloc(sizeof(double *)*j);
		double *alpha_trend = (double *)malloc(sizeof(double *)*j);
		double total_alpha = 0.0;

		for (i = 0; i < (number_of_rows); i++){
			Alpha = alpha(Price[i],BaselinePrice[i],Price[i+1],BaselinePrice[i+1]);
			all_alpha[i]=Alpha;
			if (Good_i[i]==i)
			{
				total_alpha=total_alpha+Alpha;
				alpha_trend[i]=total_alpha;
			}
			
			// Store Alpha somewhere
			//	printf("%f\n",Alpha);
			i++;
		}

		Output(tickers[k],j,Good_i,all_beta,all_alpha,alpha_trend);

		free(all_alpha);
		free(all_beta);
		free(Good_i);
		free(Price);
//		int core_num;
//		core_num = omp_get_thread_num();
//		printf("Core #: %d | Stock: %s\n",core_num+1,tickers[k] );
	}

	printf("Code ran through successfully\n");

	double diff = (double)(clock() - start) / CLOCKS_PER_SEC;

	printf("Runtime: %f ms\n",diff*1000);

	return 0;
}
