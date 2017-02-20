% Jeremy Muesing
% ASEN 3111
% Computation Lab 1
% Date 9/11/15
% Cylinder.m


close all
clear all
clc
% setting constants
rho_inf=0.9093; %kg/m^3
p_inf=7.012e4; %Pa
V_inf=25; %m/s
d=2; %m
q_inf=.5*rho_inf*V_inf^2; %Pa
N_prime_upper=0;
A_prime_upper=0;
N = 1000;
h = (2*pi)/N;
theta=linspace(0,2*pi,N+1);
% simpsons for theta 1-90
for k=1:N/4
    N_prime_upper=N_prime_upper+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1))^2)*q_inf)+p_inf)*cos(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*cos(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*cos(theta(2*k+1))));
    bullshit(k)=((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1))^2)*q_inf)+p_inf)*cos(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*cos(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*cos(theta(2*k+1))));
    A_prime_upper=A_prime_upper+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1)^2)*q_inf)+p_inf)*sin(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*sin(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*sin(theta(2*k+1)))));
end

%simpsons for theta 90-180
N_prime_lower=0;
A_prime_lower=0;
for k=N/2:N/4
    N_prime_lower=N_prime_lower+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1))^2)*q_inf)+p_inf)*cos(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*cos(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*cos(theta(2*k+1))));
    bullshit(k)=N_prime_lower+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1))^2)*q_inf)+p_inf)*cos(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*cos(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*cos(theta(2*k+1))));
    A_prime_lower=A_prime_lower+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1)^2)*q_inf)+p_inf)*sin(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*sin(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*sin(theta(2*k+1)))));
end

% adding forces together
N_prime=-N_prime_upper+N_prime_lower;
A_prime=-A_prime_upper+A_prime_lower;

% because angle of attack = 0, lift and drag are simply equal to normal and
% axial forces
L_prime=N_prime
D_prime=A_prime