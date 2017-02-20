clear all;
close all;
clc;


% Set up anonymous function for the object function to be optimized
f = @(x) x(1).^3*exp(x(2)-x(1).^2-8*(x(1)-x(2)).^2);

% Set up the initial guess for x0(n) 
x0(1) = -0.1;
x0(2) = -0.1;

% Call optimization for 1-D constrained, fminbnd
[xOpt,Phimin] = fminunc(f,x0)

