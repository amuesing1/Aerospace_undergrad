function [value,isterminal,direction] = Event_Check(~,y)
% Event_Check.m
% Aaron McCusker and Jeremy Muesing
% 
% This function serves as an option for the ode45 function to check for a
% termination case.
% 
% Case 1: The astronauts survied
% Case 2: The spacecraft hit the moon
% Case 3: The spacecraft became lost in space
% 
% Input:
% y -- Solution vector containing velocities and positions of the 3 bodies
% 
% Output:
% value -- The checked value against termination conditions. If it starts
% to become negative, the function will stop
% isterminal -- Specifying if the value case should cause a function
% termination
% direction -- specifying the direction of the value that would cause a
% termination

d_ES = distance_finder([0 0],[y(5) y(6)]);
d_MS = distance_finder([y(7) y(8)],[y(5) y(6)]);
d_EM = distance_finder([0 0],[y(7) y(8)]);

% Survived
value(1) = abs(d_ES) - 6371000;

% Hit moon
value(2) = abs(d_MS) - 1737100;

% Lost in space
value(3) = 2*abs(d_EM) - d_ES;

isterminal(1) = 1;
isterminal(2) = 1;
isterminal(3) = 1;

% All directions are set to be negative (when an event occurs, value 1, 2,
% or 3 will become negative)
direction(1) = -1;
direction(2) = -1;
direction(3) = -1;

end

