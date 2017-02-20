function [x,y] = Loop( r, x0 , y0 )
%UNTITLED4 Summary of this function goes here
%   r is the radius of the loop and y0 and x0 is where the last section end
%   and where is going to start

theta = 0:0.001: 2*pi;

x = r * cos(theta) + x0;
y = r * sin(theta) + r + y0;
end

