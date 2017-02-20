% Dylan Richards, Jeremy Muesing, Chris Choate
% ASEN 3128
% RunSimLab3.m
% Created: 2/8/14
% Modified: 2/20/16
%
% This code requires several other functions (M-Files) written by the
% students for Lab 2 and for Lab 3.

close all;
clear all;
clc


%%% Defines geometry of the aircraft model being displayed
DefineDefaultAircraft;


%%% Defines mass parameters and aerodynamic coefficients of the aircraft
%%% being simulated
recuv_tempest;

inertia_matrix = [aircraft_parameters.Ix 0 -aircraft_parameters.Ixz; 0 aircraft_parameters.Iy 0; -aircraft_parameters.Ixz 0 aircraft_parameters.Iz];


%%%%%% Initialize inertial position, velocity, and angular velocity

%%% Set desired trim condition
V_trim = 21;
h_trim = 1609.34; %[1 mile!];
throttle_trim = .1; % Given for now...


%%% Determine values to be in steady trim
[alpha_trim, elev_trim] = TrimHeight(h_trim,aircraft_parameters,V_trim); %STUDENT COMPLETED
pitch_trim = alpha_trim;
[velocity_body] = WindAnglesToAirRelativeVelocityVector([V_trim; 0; alpha_trim]);
velocity_body = velocity_body';

%%% Initialize inertial position, velocity, and angular velocity
position_inertial = [0 0 -1800]; %STUDENT COMPLETED
euler_angles = [15 -12 27]*(pi/180); %STUDENT COMPLETED
velocity_body = [19 3 -2]; %STUDENT COMPLETED
omega_body = [.08 -.2 0]*(pi/180); %STUDENT COMPLETED
aircraft_state0 = [position_inertial; euler_angles; velocity_body; omega_body];


%%% Set trim values of control surfaces
control_surfaces_trim = [5*(pi/180) 2*(pi/180) -13*(pi/180) .3];


%%% Run the model
tfinal = 150;
tstep = 0.1;
sim('aircraft_simulation',[0:tstep:tfinal]);

PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', control_input_array.data', 'b');

