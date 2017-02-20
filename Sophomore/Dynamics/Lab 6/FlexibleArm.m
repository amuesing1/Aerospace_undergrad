% This script is used for Lab 6 in ASEN 2003 for the flexible arm

clear all
close all

% Set constants
desired_angle = 15*pi/180;       % rad
K_g = 70;
K_m = 0.00767;              % Nm/amp
K_1 = 11.6;                  % neg values are unstable
K_2 = -70;                  % positive values are unstable
K_3 = 2;                    % neg values are unstable
K_4 = 1.5;                    % neg values are unstable
J_hub = 0.0021;             % Kg*m^2
L = 0.45;                   % m
Jl = 0.0042;                % Kg*m^2
R_m = 2.6;                  % W
fc = 1.8;                   % Hz
K_arm = (2*pi*fc)^2*(Jl+J_hub); 

% create errors for instability
if K_1 < 0 | K_2 > 0 | K_3 < 0 | K_4 < 0
    error('System is unstable')
end

% solve for p, q, and r values
p_1 = -(K_g^2*K_m^2)/(J_hub*R_m);
q_1 = K_arm/(L*J_hub);
r_1 = (K_g*K_m)/(J_hub*R_m);
p_2 = (K_g^2*K_m^2*L)/(J_hub*R_m);
q_2 = -(K_arm*(J_hub+Jl))/(Jl*J_hub);
r_2 = -(K_g*K_m*L)/(J_hub*R_m);

% solve for lambda's
lambda_3 = -p_1 + K_3*r_1 + K_4*r_2;
lambda_2 = -q_2 + K_1*r_1 + K_2*r_2 + K_4*(p_2*r_1-r_2*p_1);
lambda_1 = p_1*q_2 - q_1*p_2 + K_3*(q_1*r_2-r_1*q_2) + K_2*(p_2*r_1-r_2*p_1);
lambda_0 = K_1*(q_1*r_2-r_1*q_2);

% create vectors for numerators
num1 = K_1*[r_1 0 (q_1*r_2-r_1*q_2)];
num2 = K_1*[r_2 (p_2*r_1-r_2*p_1) 0];

% create vectors for den
den = [1 lambda_3 lambda_2 lambda_1 lambda_0];

% create transfer functions
sysTF1 = tf(num1,den);
sysTF2 = tf(num2,den);

% step response for arm
[x,t] = step(sysTF1,3);
% x = -x;
x = x*2*desired_angle - desired_angle;

% create step response for deflection
[x1,t1] = step(sysTF2,3);
% x1 = -x1;

% set overshoot limit
overshoot = (max(x) - desired_angle)/desired_angle*100;      % percent
if max(x) > 1.05 * desired_angle
    error('The overshoot is greater than 5%')
end

% create values for dtheta_dt
dtheta = diff(x);
dt = diff(t);
dtheta_dt = dtheta./dt;

% create values for the change in deflection over time
def = diff(x1);
dt = diff(t1);
def_dt = def./dt;

% find maximum volts
volts = K_1*(desired_angle - x(2:end)) - K_3*dtheta_dt - K_2*x1(2:end) - K_4*def_dt;
max_volts = max(volts);

% set voltage limit
if max_volts > 5
    error('Max volts are greater than 5')
end

% plot angle versus time for the hub
figure
plot(t,x,'r')
hold on
data = load('Group33_34_flex');
time = data(:,1);
angle = data(:,2);
plot(time,angle)
xlabel('Time (s)')
ylabel('Angle (rad)')

% plot angular velocity for the hub
figure
plot(data(:,4))
hold on
plot(dtheta_dt)
hold off

% plot deflection of the tip over time
figure
plot(t1,x1,'r')

hold on
deflection = data(:,3);
plot(time,deflection)
xlabel('Time (s)')
ylabel('Deflection (m)')
