% Aaron McCusker, Jeremy Muesing, Dustin Fishelman
% ASEN 3128
% Homework 2, Problem 2
% Finding the needed angle of attack and elevator deflection to perform a
% certain maneuver. Some aircraft data used in this script was found in
% Problem 1 (Prob_1.m)

Cw = .1822;
inv_mu = 0.0061;
Gamma = -0.00207;
rho = .8191;
Cmalpha = -0.0088;
Clalpha = 0.088;
Cldelta = 0.0108;
Cmdelta = -0.0246;
Cmq = -22.9;
n = 1.1;
Clq = 0;

Deltadelta = (n-1)*((-Cw/Gamma)*(Cmalpha - (1/2)*(inv_mu)*(Clq*Cmalpha - Clalpha*Cmq)));
Deltaalpha = (n-1)*(1/Clalpha)*(Cw - Clq*(Cw*inv_mu*(1/2)) - Cldelta*(Deltadelta/(n-1)));

b = [Cw;-0.071];
A = [0.088 0.0108; -0.0088 -0.0246];
x = A\b;
alpha_trim = x(1);
delta_trim = x(2);

Alpha_new = alpha_trim + Deltaalpha;
Delta_new = delta_trim + Deltadelta;