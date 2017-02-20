%% ASEN 2004 Experimental Design Lab 1
% Group 6
% Last Updated: 2 February 2015


clear all
close all
clc

load variables.mat
%% Comparing Vinf using Qinf

VHigh = sqrt((QinfHigh / (.5*RhoHigh)));
VLow = sqrt((QinfLow / (.5*RhoLow)));

sigmaVHigh = 2*std(VHigh)*ones(size(VHigh));

hold on
plot(VHigh,VinfHigh)
plot(VLow,VinfLow)
title('Comparing Velocities')
xlabel('Velocity Data')
ylabel('Computed Velocity')
errorbar(VHigh,VinfHigh,sigmaVHigh)
hold off


VW = VWind - VNW; % Subtracting the still velocity 
CalcVWind = sqrt((QinfWind / (.5*RhoWind)));
sigmaVWind = 2*std(CalcVWind)*ones(size(CalcVWind));
Lift = NormalWind - NormalStill;
Drag = AxialWind - AxialStill;

figure
plot(VWind,CalcVWind)
title('F-16 Calcualte Velocities')
xlabel('Velocity Data (m/s)')
ylabel('Computed Velocity from Q (m/s)')
errorbar(VWind,CalcVWind,sigmaVWind)

figure
hold on
plot(AOAWind,Lift,'r')
plot(AOAWind,Drag)
legend('Lift','Drag')
title('Lift and Drag Versus AOA')
xlabel('AOA')
ylabel('Force (N)')
hold off












