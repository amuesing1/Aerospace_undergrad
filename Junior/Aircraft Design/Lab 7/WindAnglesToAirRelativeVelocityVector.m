function [velocity_body] = WindAnglesToAirRelativeVelocityVector(wind_angles)
%Purpose:
% Calculate the aircraft air relative velocity in body coordinates from the airspeed, angle of
% attack, and sideslip (the wind angles, see note below). The input and output of the
% function should be three-dimensional column vectors.

% Inputs:
%   - wind_angles = column vector with [V; beta; alpha] (the wind angles)  
% Outputs:
%   - velocity_body = column vector with [u; v; w] in body coordinates of
%   aircraft air relative velocity vector
%% Set Variables from Input
V = wind_angles(1);
beta = wind_angles(2);
alpha = wind_angles(3);
%% Get Wind Angles
u = V*cos(beta)*cos(alpha);
v = V*sin(beta);
w = V*cos(beta)*sin(alpha);

velocity_body = [u; v; w];



end

