function [theta,omega] = balanced_wheel(M,M0,R,g,beta,k,theta)
%Lab 4 - 2003 Dynamics & Systems
%Chad Eberl
%Jeremy Muesing
%Josh Mellin

%Purpose:  This is code for lab 4 for ASEN 2003

%Inputs: M = mass of the wheel [kg]
%        M0 = mass of the trailing apparatus [kg]
%        R = radius of wheel [m]
%        g = gravity [m/s^2]
%        beta = angle of the ramp [deg]
%        k = radius of gyration [m]
%        theta = angle that the wheel has turned [rad]

%Outputs: omega = angular velocity of the wheel [rad/sec]
%         theta = angle relative to the omega [rad]

mt = M+M0; %total mass of the system [kg]
beta = beta*pi/180; %convert beta to radians

I = M*k^2; %moment of inertia
top = mt*g*theta*R*sin(beta); %top of our equation for omega
bottom = 1/2*mt*R^2 + 1/2*I; %bottom of our equation for omega

omega = sqrt(top/bottom);




end