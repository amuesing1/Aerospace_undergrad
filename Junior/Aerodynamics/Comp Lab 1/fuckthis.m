close all
clear all
clc
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
for k=1:N/4
    N_prime_upper=N_prime_upper+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1))^2)*q_inf)+p_inf)*cos(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*cos(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*cos(theta(2*k+1))));
    A_prime_upper=A_prime_upper+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1)^2)*q_inf)+p_inf)*sin(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*sin(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*sin(theta(2*k+1)))));
end

N_prime_lower=0;
A_prime_lower=0;
for k=N/4:N/2
    N_prime_lower=N_prime_lower+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1))^2)*q_inf)+p_inf)*cos(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*cos(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*cos(theta(2*k+1))));
    A_prime_lower=A_prime_lower+((h/3)*(d/2)*(((((1-4*sin(theta(2*k-1)^2)*q_inf)+p_inf)*sin(theta(2*k-1)))+...
        4*((((1-4*sin(theta(2*k))^2)*q_inf)+p_inf)*sin(theta(2*k)))+(((1-4*sin(theta(2*k+1))^2)*q_inf)+p_inf)*sin(theta(2*k+1)))));
end

N_prime=-N_prime_upper+N_prime_lower;
A_prime=-A_prime_upper+A_prime_lower;


L_prime=N_prime;
D_prime=A_prime;