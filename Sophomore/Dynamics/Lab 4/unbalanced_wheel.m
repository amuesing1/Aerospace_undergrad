function [theta,omega] = unbalanced_wheel(M,M0,m,R,g,beta,r,k,tau,theta)
%Lab 4 - 2003 Dynamics & Systems
%Chad Eberl
%Jeremy Muesing
%Josh Mellin

%Purpose:  This is code for lab 4 for ASEN 2003

%Inputs: M = mass of the wheel [kg]
%        M0 = mass of the trailing apparatus [kg]
%        m = mass of added rod [kg]
%        R = radius of wheel [m]
%        g = gravity [m/s^2]
%        beta = angle of the ramp [deg]
%        r = distance from center of wheel to extra mass [m]
%        k = radius of gyration [m]
%        tau = torque due to friction [N*m]
%        theta = angle that the wheel has turned [rad]

%Outputs: omega = angular velocity of the wheel [rad/sec]
%         theta = angle relative to the omega [rad]


beta = beta*pi/180; %convert beta to radians

top = (M+M0)*theta*R*g*sin(beta) + m*g*R*theta*sin(beta) + m*g*r*cos(beta) - ... 
    m*g*r*cos(theta+beta) - tau*theta;

bottom = 1/2*(M+M0)*R^2 + 1/2*M*k^2 + ... 
    1/2*m*(R^2+r^2-2*R*r*cos(pi-theta));

omega = sqrt(top./bottom);

end