function [x_bar, median_x, sigma_x ] = deviations( x )

%mean
x_bar=mean(x);

%median
median_x=median(x);

%stadard deviation
sigma_x=std(x);


end

