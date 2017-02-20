function [wind_angles] = AirRelativeVelocityVectorToWindAngles(velocity_body)
%% Purpose: 
% Calculate the wind angles from the aircraft air relative velocity in body coordinates. The
% input and output of the function should be three-dimensional column vectors.

% Inputs:
%   - velocity_body = column vector with [u; v; w] in body coordinates of
%   aircraft air relative velocity vector
% Outputs:
%   - wind_angles = column vector with [V; beta; alpha] (the wind angles)

%% Set Variables from Input
u = velocity_body(1);
v = velocity_body(2);
w = velocity_body(3);
%% Get Wind Angles
V = sqrt(u.^2 + v.^2 + w.^2);
alpha = atan(w ./ u);
beta = asin(v ./ V);

wind_angles = [V; beta; alpha];

end

