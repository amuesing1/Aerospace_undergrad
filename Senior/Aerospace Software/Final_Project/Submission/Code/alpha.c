#include <stdio.h>
#include <stdlib.h>
#include "beta.h"

double alpha(double stock_start, double baseline_start, double stock_end, double baseline_end) {

double alpha,realized_return,market_return,risk_free_return,Beta;

realized_return = 100*((stock_end - stock_start)/stock_start);

market_return = 100*((baseline_end - baseline_start)/baseline_start);

risk_free_return = 1.5/12; // This is a percentage based on the average return of a 10 year US Treasury bond and the average annual rate of inflation. Divided by 12 because we are just doing 1 month intervals. If interval changes, THIS VALUE MUST CHANGE!!!

Beta = beta(stock_start,baseline_start,stock_end,baseline_end);

alpha= realized_return - (risk_free_return + (market_return - risk_free_return)*Beta);

return alpha;
}
