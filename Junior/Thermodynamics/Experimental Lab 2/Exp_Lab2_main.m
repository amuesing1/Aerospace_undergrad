close all
clear all
clc

% L = 4 + (1/8); % in
L=0.104; %m

% Aluminum, 20 Volts, 190 miliamps, 10 degrees C
Data = load('Aluminum_20V_190mA_10DegC.txt');
time = Data(:,1);
T1 = Data(:,2);
T2 = Data(:,3);
T3 = Data(:,4);
T4 = Data(:,5);
T5 = Data(:,6);
T6 = Data(:,7);
T7 = Data(:,8);
T8 = Data(:,9);

T_Snapshot = [T1(end-15), T2(end-15), T3(end-15), T4(end-15),...
    T5(end-15), T6(end-15), T7(end-15), T8(end-15)];
Slope = zeros;
for i = 1:7
    Slope(i) = (Data(end-15,i+2) - Data(end-15,i+1))/0.5;
end
H = mean(Slope);
% H = (T8(end-15) - T1(end-15))/4;

T0 = T1(1);

% shift = (T0 - T1(end-15)) * ((.5)/(T2(end-15) - T1(end-15))) + 0;
% shift = (T0 - T1(end-15))/H;
x = linspace(0,4,length(time));
k=48E-05;
rho=2.81;
cp=960;
shift=0;
for i=1:8
    Bn=(-8*H*L*(-1)^(i+1))/((2*i-1)*pi)^2;
    lambda=((2*i-1)*pi)/(2*L);
    alpha=k/(rho*cp);
    shwifty=@(x,t) Bn*sin(lambda*x)*exp(-lambda^2*alpha*t);
    shift=shift+shwifty(x,time);
end

% Anonymous Equation for slope line
slope_line = @(x) T0 + H*x - shift;

x_shift=linspace(0,4,8);
figure
hold on
plot(x_shift,slope_line(x_shift),'b')
plot(x_shift,Data(end-15,2:end),'r*')
xlabel('Position (inches)')
ylabel('Temperature (C)')
title('Experimental Vs Analytical');
time(end-15)