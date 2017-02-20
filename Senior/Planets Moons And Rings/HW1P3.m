clear all
close all
clc


au2km = 1.496e8;
% mu_sun = 1.327e20;

table = [.49 2440 5.43 .240846; .73 6050 5.24 .615; 1 6370 5.51 1; ...
    1.52 3400 3.93 1.881; 5.21 69900 1.33 11.86; 9.55 58200 .69 29.46;...
    19.22 25400 1.27 84.01; 30.11 24600 1.64 164.8];

for i=1:length(table)
    % mass
    table(i,5) = table(i,2)^3*1e12*(4/3)*pi*table(i,3);
    % distance traveled
    table(i,6) = table(i,1)*au2km*2*pi;
    % velocity
    table(i,7) = table(i,6)/(table(i,4)*365*24*3600);
    % angular momentum
    table(i,8) = table(i,5)*table(i,7)*1e3*table(i,6)*1e3;
end

%part c
total_mass = sum(table(:,5));
total_angular_momentum = sum(table(:,8));

%part d
sun_R = 6.96e5; % km
sun_rho = 1.41; % g/cm^3
sun_m = (4/3)*pi*sun_R^3*1e12*sun_rho;

sun_angular = (4*pi*sun_m*(sun_R*1e3)^2)/(5*25*24*3600);

per_m = (sun_m/(sun_m+total_mass))*100;
per_angular = (sun_angular/(sun_angular+total_angular_momentum))*100;