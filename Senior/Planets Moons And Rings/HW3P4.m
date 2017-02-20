close all
clear all
clc

G=6.67e-11;
M=9.4e20;
R=473000;
g=G*M/R^2;
rho=2161;

i=1;
for r=0:R
    P_a(i)=g*rho*(R-r);
    P_b(i)=(2/3)*G*pi*(rho^2)*(R^2-r^2);
    radius(i)=r;
    i=i+1;
end

figure
hold on
plot(radius,P_a)
plot(radius,P_b)
xlabel('Radius from center (m)')
ylabel('Pressure (N/m^2)')
title('Pressure inside a planet')
legend('Pressure pt A','Pressure pt B')