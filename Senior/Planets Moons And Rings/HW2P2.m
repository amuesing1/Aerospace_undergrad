close all
clear all
clc

V=(4/3)*pi*(4000^3);
rho_r=2.65e12;
rho_fe=7.87e12;

i=1;
for r_c=0:4000
    M_r(i)=(V-(4/3)*pi*r_c^3)*rho_r;
    M_fe(i)=((4/3)*pi*r_c^3)*rho_fe;
    M_p(i)=M_r(i)+M_fe(i);
    radius(i)=r_c;
    i=i+1;
end

figure
hold on
plot(radius,M_p)
plot(radius,M_r)
plot(radius,M_fe)
xlabel('Radius of the Core (km)')
ylabel('Mass of the Planet (kg)')
title('Mass of the Planet with respect to core size')
legend('Mass of planet','Mass of Mantle','Mass of Core')