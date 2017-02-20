function [x, y] = First_section(r, y)
%UNTITLED2 Summary of this function goes here
%   R is the radius of the circle 
% and Y is how much you want to be from the ground

x = 0:0.01:r;
y = - sqrt(r^2 - (x - r).^2) + r + y;
end

