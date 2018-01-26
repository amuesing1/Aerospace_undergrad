% Jeremy Muesing
% ASEN 4057
% time_2_impact.m
% Created: 1/23/17
% Modified: 1/23/17
function [time] = time_2_impact(theta,V,x)
% Finds the time it takes to impact the ground.
% Inputs: launch angle (theta), initial velocity (V), initial vertical
% position (x)

% Outputs: time to hit ground

g=-9.81;
a=.5*g;
b=V*sind(theta);
c=x; %This marks the starting height. For this assignment it is 0m
% Solves quadratic equation and finds the positive root. For this problem
% there will always be a positive root with the other either being 0 or
% negative.
time=max(roots([a,b,c]));
end

