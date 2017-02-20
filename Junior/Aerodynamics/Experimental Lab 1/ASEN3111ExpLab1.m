%% Script to plot results

clear all;
close all;
clc;

[D1 Cd1 Cdtot1 V1 dy1] = computeDrag('15mps_13mm');
[D2 Cd2 Cdtot2 V2 dy2] = computeDrag('15mps_33mm');
[D3 Cd3 Cdtot3 V3 dy3] = computeDrag('25mps_13mm');
[D4 Cd4 Cdtot4 V4 dy4] = computeDrag('25mps_33mm');

figure;
hold on
plot(V1,dy1)
plot(Cd1,dy1)
title('Velocity and Coeff Drag Profile for 15 m/s @ 13 mm');
xlabel('Coeff Drag/ Velocity [m/s]');
ylabel('dy [m]');
legend('Velocity Profile', 'Coefficient of Drag Profile');

figure;
hold on;
plot(V2,dy2)
plot(Cd2,dy2)
title('Velocity and Coeff Drag Profile for 15 m/s @ 33 mm');
xlabel('Coeff Drag/ Velocity [m/s]');
ylabel('dy [m]');
legend('Velocity Profile', 'Coefficient of Drag Profile');

figure;
hold on;
plot(V3,dy3)
plot(Cd3,dy3)
title('Velocity and Coeff Drag Profile for 25 m/s @ 13 mm');
xlabel('Coeff Drag/ Velocity [m/s]');
ylabel('dy [m]');
legend('Velocity Profile', 'Coefficient of Drag Profile');

figure;
hold on;
plot(V4,dy4)
plot(Cd4,dy4)
title('Velocity and Coeff Drag Profile for 25 m/s @ 33 mm');
xlabel('Coeff Drag/ Velocity [m/s]');
ylabel('dy [m]');
legend('Velocity Profile', 'Coefficient of Drag Profile');

figure;
hold on;
plot(Cd1,dy1)
plot(Cd2,dy2)
plot(Cd3,dy3)
plot(Cd4,dy4)
legend('15mps 13mm','15mps 33mm','25mps 13mm','25mps 33mm');
title('Coefficient of Drag Profiles');
xlabel('Coeff Drag');
ylabel('dy [m]');

figure;
hold on;
plot(V1,dy1)
plot(V2,dy2)
plot(V3,dy3)
plot(V4,dy4)
legend('15mps 13mm','15mps 33mm','25mps 13mm','25mps 33mm');
title('Velocity Profiles');
xlabel('Velocity [m/s]');
ylabel('dy [m]');