#include <stdio.h>
#include <stdlib.h>

double beta(double stock_start, double baseline_start, double stock_end, double baseline_end) {

double Beta, Covariance, Variance, stock_mean, baseline_mean;

stock_mean = (stock_end + stock_start)/2;

baseline_mean = (baseline_end + baseline_start)/2;

Covariance = (stock_start - stock_mean)*(baseline_start - baseline_mean) + (stock_end - stock_mean)*(baseline_end - baseline_mean);

Variance = ((baseline_start - baseline_mean)*(baseline_start - baseline_mean) + (baseline_end - baseline_mean)*(baseline_end - baseline_mean))/2;

Beta = Covariance / Variance;

return Beta;

}
