% Main script for ASEN 3112 Lab 1 analysis and plotting
% Author: Ansel Rothstein-Dowden
% Created:  10/9/15
% Modified: 10/12/15

% clear workspace
clear
close all
clc

% read in files
closedtest = csvread('400inlb_torsion_test.csv');
opentest = csvread('20inlb_torsion_test.csv');

% extract and name relevant information
gamma_c_exp = closedtest(:,2);
T_c = closedtest(:,4);
gamma_o_exp = opentest(:,2);
T_o = opentest(:,4);

% parameters that don't change
L = 1;
G = 3.75e6;
Re = 3/8;
t = 1/16;

% plotting specifications
line_width = 2;
font_size  = 18;
mkr_size   = 8;
set(0,'DefaultLineLineWidth' ,line_width);
set(0,'DefaultAxesFontSize'  ,font_size);
set(0,'DefaultLineMarkerSize',mkr_size);

%% closed

% define specimen parameters
Ri = Re-t;
Ravg = mean([Re Ri]);
Ae = pi*Ravg^2;
p = 2*pi*Ravg;
J_c_approx = 4*Ae^2*t/p;
J_c_exact = pi/2*(Re^4 - Ri^4);

% get theory values
gamma_c_th_approx = ( T_c / (G * 2 * t * Ae) ) * 180/pi;
gamma_c_th_exact = ( T_c * Re / (G * J_c_exact) ) * 180/pi;
rigidity_th_approx = G*J_c_approx * ones(size(T_c));
rigidity_th_exact = G*J_c_exact * ones(size(T_c));

% find phi and rigidity
phi_c_exp = gamma_c_exp*(pi/180)*L/Re;
rigidity_c_exp = T_c*L./phi_c_exp;

% plot comparisons
figure
grid on
plot(T_c, gamma_c_exp, T_c, gamma_c_th_exact, ...
    T_c, gamma_c_th_approx);
title('Shear Strain in Closed Wall Specimen');
xlabel('Torque [lb \cdot in]');
ylabel('\gamma [°]');
legend('Experimental Data','Exact Theory','Approximate Theory', ...
    'Location','NorthWest')

figure
grid on
plot(T_c(7:end), rigidity_c_exp(7:end), T_c, rigidity_th_approx, ...
    T_c, rigidity_th_exact);
title('Rigidity in Closed Wall Specimen');
xlabel('Torque [lb \cdot in]');
ylabel('Torsional Rigidity GJ [lb \cdot in^2]');
legend('Experimental Data','Approximate Theory','Exact Theory', ...
    'Location','NorthEast')

%% open

% define specimen parameters
b = 2*pi*Ravg;
[Ja,Jb] = findJ_OTW(b,t);

% get theory values
gamma_o_th = ( T_o*t/(G*Ja) ) * 180/pi;
rigidity_o_th = G*Jb * ones(size(T_o));

% find phi and rigidity
phi_o_exp = gamma_o_exp*(pi/180)*L/t;
rigidity_o_exp = T_o*L./phi_o_exp;

% plot comparisons
figure
grid on
plot(T_o, gamma_o_exp, T_o, gamma_o_th);
title('Shear Strain in Open Specimen');
xlabel('Torque [lb \cdot in]');
ylabel('\gamma [°]');
legend('Experimental Data','Theory','Location','NorthWest')

figure
grid on
plot(T_o(12:end), rigidity_o_exp(12:end), T_o, rigidity_o_th);
title('Rigidity in Open Specimen');
xlabel('Torque [lb \cdot in]');
ylabel('Torsional Rigidity GJ [lb \cdot in^2]');
legend('Experimental Data','Theory','Location','SouthEast')