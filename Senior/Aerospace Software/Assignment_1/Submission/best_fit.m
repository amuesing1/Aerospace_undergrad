% Jeremy Muesing
% ASEN 4057
% best_fit.m
% Created: 1/23/17
% Modified: 1/23/17
function [m,b] = best_fit(x,y)
% This funciton takes two input vectors (x and y) and outputs the line of
% best fit returning the slope and y intercept (m and b).

% Inputs: x and y vectors

% Outputs: slope (m), y intercept (b)

A=sum(x);
B=sum(y);
C=sum(x.*y);
D=sum(x.^2);
N=length(x);
    
m=(A*B-N*C)/(A^2-N*D);
b=(A*C-B*D)/(A^2-N*D);
end

