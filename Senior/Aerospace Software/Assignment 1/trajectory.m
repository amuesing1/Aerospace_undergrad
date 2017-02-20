% Jeremy Muesing
% ASEN 4057
% trajectory.m
% Created: 1/23/17
% Modified: 1/23/17
function [time_vec,x,y] = trajectory(theta,V,time)
% Finds the position vectors over time of a projectile

% Inputs: launch angle (theta), initial velocity (V), time to impact (time)

% Outputs: time vector, horizontal position vector (x), vertical position
% vector (y)

g= -9.81; %m/s^2

y(1)=0;
x(1)=0;
time_vec=linspace(0,time);
x=V*cosd(theta).*time_vec;
y=.5*g.*time_vec.^2+V*sind(theta).*time_vec;
end

