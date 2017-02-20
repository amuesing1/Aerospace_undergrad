clc
clear all
close all

N = 1000;
theta = linspace(0.25,2*pi - 0.25,N);
inf_values = find(theta == pi);
theta(inf_values) = pi + 0.001;
r = (pi - theta)./(sin(theta));

% Convert to cartesian
x = r.*cos(theta);
y = r.*sin(theta);

plot(x,y)
hold on
plot(0,0,'gp')
xlim([-3 10]);
ylim([-4.5 4.5]);
title('Shape of a Semi-Infinite Body with uniform stream')
xlabel('Distance from Source (ft)')
ylabel('Distance from Source (ft)')
legend('Semi-Infinite Body','Source')
hold off

Cp = -(2./r).*cos(theta) - (1./(r.^2));
figure
plot(x,Cp)
xlabel('Distance Along Centerline (ft)')
ylabel('C_p')
title('Pressure Coefficient Distribution Over Body')
ylim([-0.8 1])