function [F] = force_g(pos_A,pos_B,m_A,m_B)
% force_g.m
% Aaron McCusker and Jeremy Muesing
%
% This function is used to find the force acting between two objects due
% to gravity
%
% Input:
% pos_A -- [x, y] = x and y coordinates of object A [m]
% pos_B -- [x, y] = x and y coordinates of object B [m]
% m_A -- Mass of object A [kg]
% m_B -- Mass of object B [kg]
%
%
% Output
% F -- [Fx, Fy] = x and y components of force acting between two objects

% Inputs: Position vectors of objects A & B, mass of A & B

% Outputs: Force vector [F_x, F_y]

% Define Universal Gravitational Constant
G = 6.674E-11;

% Find distance between two objects
d = sqrt((pos_A(1)-pos_B(1))^2+(pos_A(2)-pos_B(2))^2);

% Find gravitational force between two objects
F(1) =((G*m_A*m_B)*(pos_A(1)-pos_B(1)))/(d^3);
F(2) =((G*m_A*m_B)*(pos_A(2)-pos_B(2)))/(d^3);
end

