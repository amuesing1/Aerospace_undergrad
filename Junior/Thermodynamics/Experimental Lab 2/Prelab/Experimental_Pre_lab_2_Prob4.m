%% 8======================================================================D
% Author: TEAM
% Date: 10/22/2015
% Class: ASEN 3113
% Experimental Lab #2
% Problem: 3
%% 8======================================================================D
%% Initial Clearance 8====================================================D
clear all;
close all;
clc;

%% Variables 8============================================================D

% Memory allocation for iterative calculation arrays
lamda = zeros;
B = zeros;
trans = zeros;
Temp = zeros;

% Constants
x = 3;
t = 1000;
n = linspace(1,10,10);
T_0 = 5;
alpha = 0.0744;
H = 26.32;
L = 5.0004;
p = 10;
homo = T_0 + (H*x);

%% General Solution Calculation 8=========================================D

for i = 1:p
    
    lamda(1,i) = (((2*(i)) - 1) * pi) / (2*L);
    
    B(1,i) = (-8*H*L*((-1)^(i+1))) / ((((2*i) - 1)*pi)^2);
    
    trans(1,i) = B(1,i) * sin(lamda(1,i)*x) * exp(-((lamda(1,i))^2)*alpha*t);
    
    Temp(1,i) = homo + sum(trans);
    
end

%% Plot for Convergence 8=================================================D

figure;
hold on;
title('Temperature vs Number of Fourier Terms')
xlabel('Number of Terms')
ylabel('Temperature (C)')
plot(n,Temp,'r')
hold off;

%% END 8==================================================================D