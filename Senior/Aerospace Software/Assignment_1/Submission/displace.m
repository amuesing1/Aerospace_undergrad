% Jeremy Muesing
% ASEN 4057
% displace.m
% Created: 1/23/17
% Modified: 1/23/17
function [W_air] = displace(r,h)
%Finds the weight of the air displaced by the balloon

% Inputs: radius of the balloon (r), height of balloon (h)

% Outputs: weight of the air displaced

% Finds the density of the air at altitude
rho=density(h);
W_air=(4*pi*rho*r^3)/3;

end

