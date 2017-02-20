close all
clear all
clc

n=100; %panels

%making cylinder
r=1;
ang=linspace(0,2*pi,n); 
x=r*cos(ang);
y=r*sin(ang);
plot(x,y);

%calc Cp
V_inf=50;
alpha=0;
Cp_calc=source_panel(x,y,V_inf,alpha);

%theory Cp
Cp_theory=1-4*sin(ang).^2;

figure(1)
plot(ang,Cp_theory)
hold on
plot(ang(1:n-1),Cp_calc)