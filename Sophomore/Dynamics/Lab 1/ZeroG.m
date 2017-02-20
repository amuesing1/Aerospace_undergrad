function [x,y] = ZeroG(h0, angle, x0, y0)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

g = 9.81;

V0 = sqrt(2 * g * (h0-y0) );

Vx0 = V0 * cos(angle);
Vy0 = V0 * sin(angle);
t = 0:0.01:2 * Vy0 / g;

x = Vx0 .* t + x0;
y = Vy0 .* t - 0.5 * g * t.^2 + y0;
end

