%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: TEAM
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
T_0 = 5;
x = [0.0, 0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5];
T = [5.0, 18.17,31.33,44.50,57.66,70.83,83.99,97.16,110.32];

%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear interpolation
shift = (T(1) - T(2)) * ((x(3) - x(2))/(T(3) - T(2))) + x(2);

% Add the shift
x = ((-1)*shift) + x;
x(1) = 0.0;

% Find the slope of the linear equation
H = (T(2) - T_0)/x(2);

% Steady state solution for temperature
T_s = T_0 + (H * x);

%% Plot for the experimental data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
hold on;
title('Experimental Data vs Distance')
xlabel('Length (in)')
ylabel('Temperature (C)')
plot(x,T)
hold off;

%% Plot for the data that is calculated with the calculated slope %%%%%%%%%
figure;
hold on;
title('Steady State Temperature vs Distance')
xlabel('Length (in)')
ylabel('Temperature (C)')
plot(x,T_s,'r')
hold off;

%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%