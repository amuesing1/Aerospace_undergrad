% Jeremy Muesing
% ASEN 4057
% problem2.m
% Created: 1/23/17
% Modified: 1/23/17

close all
clear all
clc

% Read in data
data = csvread('data_set_2.csv');

[m,b]=best_fit(data(:,1),data(:,2));

% Create x vector for graphing
x=linspace(min(data(:,1)),max(data(:,1)));

figure
hold on
scatter(data(:,1),data(:,2))
plot(x,m*x+b);
xlabel('Angle of Attack (deg)')
ylabel('Coefficient of Lift')
title('C_l for various \alpha')
legend('Data','Line of Best Fit')