% Chris Choate
% ASEN 3128
% TrimHeight.m
% Created: 2/8/16
% Modified: 2/15/16
%
% This is code intended to solve for trim at a height

function [at,et] = TrimHeight(h,ap,Vt)

% Grab density
[T,a,P,rho] = atmosisa(h);

% Define matrix
M = inv([ap.CLalpha,ap.CLde;ap.Cmalpha,ap.Cmde]);

% Define Set Terms
A = [2*ap.W/rho/Vt^2/ap.S;-ap.Cm0];
B = M*A;

% Divide Terms
at = B(1,1);
et = B(2,1);

end