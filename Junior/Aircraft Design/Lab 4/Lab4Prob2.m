%% Anthony Torres
% ASEN 3128 - 011
% Lab4Prob2.m
% Lab 4
% Created: 2/29/16
% Modified: 2/29/16

% Clear workspace
clear all;
close all;

% Initialize MODEFLIER
modeflier.m

% Initialize goals
height = 1800; % m


% Calculate trim variables
[alpha_trim, elev_trim] = CalculateSteadyTrim( h0, u0, aircraft_parameters )