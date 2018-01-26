function [d] = distance_finder(pos_A,pos_B)
% distance_finder.m
% Aaron McCusker and Jeremy Muesing
% 
% Returns distance between objects
% 
% Inputs: Position vector of objects A & B
% 
% Output: distance bewteen objects
% 
d = sqrt((pos_A(1)-pos_B(1))^2+(pos_A(2)-pos_B(2))^2);
end

