% This script is used for Lab 6 in ASEN 2003 for the rigid arm
clear all
close all

% Set constants
initial_angle = -15*pi/180;
desired_angle = 15*pi/180;
K_g = 70;
K_m = 0.00767;
K_p = 9.3;
K_d = 0.38;
J = 0.0021 + 0.0059;
R_m = 2.6;

% create errors for instability
if K_p < 0 | K_d < 0
    error('System is unstable')
end

% Closed	loop	system	
num	= K_p*K_g*K_m/J/R_m;
den	= [1 (K_g^2*K_m^2/J/R_m + K_d*K_g*K_m/J/R_m) num];
sysTF =	tf(num,den);

% Step response
[x,t] = step(sysTF,3);
x = x*2*desired_angle - desired_angle;

% set overshoot limit
overshoot = (max(x) - desired_angle)/desired_angle*100;      % percent
if max(x) > 1.05 * desired_angle
    error('The overshoot is greater than 5%')
end

% set limit for maximum volts
volts = K_p*(desired_angle - initial_angle) - K_d*initial_angle;
if volts > 5
    error('Volts are greater than 5')
end

% plot model vs actual
figure(1);clf;
plot(t,x,'r');
hold on
data = load('Group20_21');
time = data(:,1);
angle = data(:,2);
plot(time,angle)
xlabel('Time (s)')
ylabel('Angle (rad)')
hold off

