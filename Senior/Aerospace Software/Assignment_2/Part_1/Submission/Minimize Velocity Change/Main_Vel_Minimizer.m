% Main_Vel_Minimizer.m
% Aaron McCusker and Jeremy Muesing
% Feb 6, 2017
%
% This script begins the task of finding the minimum velocity necessary to
% return the astronauts to Earth safely while minimizing the needed Delta V
% to make that happen.

% Housekeeping
clc
clearvars
close all

% Start profiling
profile on

% Insert your best guess here. Best guess was obtained using SucessFinder.m
x0 = [0 50];

% Call the minimizer function with your initial conditions
x = fminsearch(@objectivefunction1,x0);

% Print the minimum delta V needed to save the astronauts
fprintf('The best delta V is dx=%3.4f m/s and dy=%3.4f m/s\n',x(1),x(2));

% End the profiler
profile off

% View the profile
profile viewer
