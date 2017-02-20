close all
clear all
clc

Re = 6E6;
Temp = 300; % K
mu = 1.846E-5; % kg/m*s
c = 1; % m
V_inf = (Re*mu)/c; % m/s
a = sqrt(1.4*287*Temp);
Mach = V_inf/a;

Mach=0.15;
V_inf=Mach*a;

alpha = 15;

xcomponent = cosd(alpha);
ycomponent = sind(alpha);

V_x = xcomponent*V_inf;
V_y = ycomponent*V_inf;