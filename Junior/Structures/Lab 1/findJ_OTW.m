function [ Jalpha, Jbeta ] = findJ_OTW( b, t )

r = t/b;
alpha = (1/3) * (1 + 0.6095*r + 0.8865*r^2 - 1.8025*r^3 + .91*r^4)^-1;
beta = (1/3) - 0.21*r * (1 - (1/12)*r^4);

Jalpha = alpha*b*t^3;
Jbeta = beta*b*t^3;

end