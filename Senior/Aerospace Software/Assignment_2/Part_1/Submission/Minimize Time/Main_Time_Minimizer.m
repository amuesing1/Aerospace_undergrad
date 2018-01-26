% Main_Time_Minimizer.m
% Aaron McCusker and Jeremy Muesing
% Feb 6, 2017
%
% This script begins the task of finding the minimum time necessary to
% return the astronauts to Earth safely.

% Housekeeping
clc
clearvars
close all

% Start profiling
profile on

% Insert your best guess here. Best guess was obtained using SucessFinder.m
x0 = [-60 50]; % [m/s]

% Call the minimizer function with your initial conditions
x = fminsearch(@objectivefunction2,x0); % [m/s]

% Call spacecraft_simulator using the optimized velocities to get the time
% at the end of the sim
[t,~,IE] = spacecraft_simulator(x(1),x(2));

% Print the velocity and total time to save the astronauts
fprintf('The best delta V is dx = %3.4f m/s and dy = %3.4f m/s. The astronauts reach earth in %5.0f seconds\n',x(1),x(2),t);

% End the profiler
profile off

% View the profile
profile viewer