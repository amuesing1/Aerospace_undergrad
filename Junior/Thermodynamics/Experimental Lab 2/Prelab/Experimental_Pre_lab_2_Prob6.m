%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date: 10/22/2015
% Class: ASEN 3113
% Experimental Lab #2
% Problem: 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initial Clearance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time(1,1) = 0;

% Constants
x = 3;
n = 1;
T_0 = 5;
alpha = 0.0744;
H = 26.32;
L = 5.0004;
p = 500;

lamda = ((2 - 1) * pi) / (2*L);
    
B = (-8*H*L*((-1)^(2))) / (((2 - 1)*pi)^2);
    
trans(1,1) = B * sin(lamda*x) * exp(-((lamda(1,i))^2)*alpha*time(1,1));
    
Temp(1,1) = sum(trans);

%% Transient Solution Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:p
   
    time(1,i+1) = time(1,i) + 1;
    
    trans(1,i) = B(1,i) * sin(lamda*x) * exp(-((lamda^2)*alpha*t(1,p)));
    
    Temp(1,i) = sum(trans);
    
end





















