% Lance Walton, Jeremy Muesing, Aspen Coates
% ASEN 3200: Lab O-1
% Created: 03-18-2016
% Modified: 03-18-2016

clear all 
close all 
clc

% Need a, e, i, Omega, omega, Theta


Greenwich = deg2rad(100.43878);
time = 23*3600 + 56*60 + 4.091;   % One day 
a = 7271.93;                        % Km semimajor axis
e = 0.01;                           % Eccentricity
i = deg2rad(66);                    % Inclination
Omega = deg2rad(236.121);           % Longitude of ascending node
omega = 0;                          % Argument of Perigee 
Theta = 0;                          % True Anomoly 

Groundtrack([a e i Omega omega Theta],Greenwich,time)
