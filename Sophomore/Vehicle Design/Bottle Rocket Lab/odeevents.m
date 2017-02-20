function [value,isterminal,direction] = odeevents(t,y)
% Locate the time when height passes through zero in a 
% decreasing direction and stop integration.
% 'doc odeset' for more info

% The height can suddenly go imaginary, actually ends integration .005 m
% above 0
value = real(y(3)) - 0.005;
isterminal = 1;
direction = -1;