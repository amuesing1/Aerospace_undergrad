% Jeremy Muesing
% ASEN 4057
% density.m
% Created: 1/23/17
% Modified: 1/23/17
function [rho] = density(h)
% Finds the density of the air at different altitudes

% Inputs: altitude (h)

% Outputs: density of the air

if 0<h<=11000
    T=15.04-.00649*h;
    P=101.29*((T+273.1)/288.08)^5.256;
elseif 1100<h<=25000
   T=-56.46;
   P=22.65*e^(1.73-.000157*h);
elseif h>25000
   T=-131.21+.00299*h;
   P=2.488*((T+273.1)/216.6)^-11.388;
end

rho=P/(.2869*(T+273.1));

end

