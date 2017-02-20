function [wind_angles] = AirRelativeVelocityVectorToWindAngles(velocity_body)

% ASEN 3128 Lab 2 part 1b)
% David Barker, Dylan Richards, Andrew Quinn

% Problem: Calculate the wind angles from the aircraft ... 
% air relative velocity in body coordinates. The input and output of...
% the function should be three-dimensional column vectors.

% Input: velocity_body = [u; v; w];
%
% Output: wind_angles = [V;, beta, alpha];

%break down velocity_body vector
u = velocity_body(1, :);
v = velocity_body(2, :);
w = velocity_body(3, :);

V = sqrt((u.^2)+(v.^2)+(w.^2));
beta = asin(v./V);
alpha = atan(w./u);

wind_angles = [V; beta; alpha];