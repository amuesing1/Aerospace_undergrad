clear all;
close all;
clc;

% Set up economic values
V = 150000; 
K1 = 10000;
K2 = 50;
K3 = 300;

% Set up anonymous function for the object function to be optimized
f = @(S) (V*(K1+(K2*S^0.5)))/(S)+K3*S^(2/3);

% Set up the constraints for S 
Sl = 1;
Su = 50000;

% Call optimization for 1-D constrained, fminbnd
[Sopt,PhiOpt] = fminbnd(f,Sl,Su)

