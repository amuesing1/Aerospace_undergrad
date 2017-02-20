function [ x,y ] = connection(x0,xi,y0)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

x = x0:0.001:xi;
L = length(x);

y = zeros(L);
for i = 1:L
    y(i) = y0;
end
end

