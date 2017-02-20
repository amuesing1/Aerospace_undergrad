clc
clear all

alt=200000;
RE=149.4E6;
RJ=778.6E6;
mu_sun=132712E6;
mu_j=126686000;
radius_j=71490;
rp=radius_j+alt;

% inbound
a=(RE+RJ)/2
VJ=sqrt(mu_sun/RJ);
V_1=sqrt(mu_sun*((2/RJ)-(1/a)));
V_inf=VJ-V_1;
e=1+((rp*V_inf^2)/mu_j);
delta=2*asin(1/e);
delta_V=2*V_inf*sin(delta/2)

%outbound
phi=delta+pi;
V_2=sqrt((VJ+V_inf*cos(phi))^2+(V_inf*sin(phi))^2);
a_2=(-mu_sun)/(2*((V_2^2/2)-(mu_sun/RJ)))
h_2=RJ*V_2;
e_2=sqrt(1-((h_2^2)/(mu_sun*a_2)))