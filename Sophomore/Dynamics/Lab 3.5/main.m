% Group Members: Jeremy Muesing, Zachary Jardinico
% Purpose: To determine the Normal forces, angular velocity, angle, and
% position of a bar leaning against a wall while falling and compare
% results to an analytical solution
% Inputs: None
% Outputs: Time until A no longer has force on side wall (seconds), Angle
% at time A no longer has force on side wall (degrees), step size of time
% interval (seconds)
clear all;close all;clc
mass=18; %kg
l=4; %m
g=9.81; %m/s^2
% convert inital angle to degree for calculations
theta0=(5*pi)/180; %rad
t0=0; %sec
omega0=0; %rad/sec

step=[0.1,0.01,0.001];
% run function for each step size
[t1,omega1,theta1,alpha1,normal_A1,normal_B1,pos1] = fun( mass,l,g,theta0,omega0,step(1));
[t2,omega2,theta2,alpha2,normal_A2,normal_B2,pos2] = fun( mass,l,g,theta0,omega0,step(2));
[t3,omega3,theta3,alpha3,normal_A3,normal_B3,pos3] = fun( mass,l,g,theta0,omega0,step(3));

% convert from radians back to degrees for plotting
theta1_deg=(theta1.*180)/pi;
theta2_deg=(theta2.*180)/pi;
theta3_deg=(theta3.*180)/pi;

% analytical solution
a_theta = linspace(theta0,theta1(end),1000);
a_omega = sqrt((3*g/l)*(cosd(5)-cos(a_theta)));
a_theta_deg=a_theta*(180/pi);

% print table
fprintf('%s %20s %24s\n','Step Size (s)','Time left wall (s)','Angle at Time (deg)');
fprintf('%.3f %18.3f %25.3f\n',step(1),t1(end),theta1_deg(end));
fprintf('%.3f %18.3f %25.3f\n',step(2),t2(end),theta2_deg(end));
fprintf('%.3f %18.3f %25.3f\n',step(3),t3(end),theta3_deg(end));

% plot Theta vs Time graph
figure()
set(gcf,'defaultAxesFontSize',11);
hold on;
plot(t1,theta1_deg)
plot(t2,theta2_deg,'r')
plot(t3,theta3_deg,'k')
xlabel('Time (seconds)')
ylabel('Theta (degrees)')
title('Theta vs Time')
legend('Step Size=0.1','Step Size=0.01','Step Size=0.001')
hold off;

% plot Omega vs Time graph
figure()
set(gcf,'defaultAxesFontSize',11);
hold on;
plot(t1,omega1)
plot(t2,omega2,'r')
plot(t3,omega3,'k')
xlabel('Time (seconds)')
ylabel('Omega (rad/s)')
title('Omega vs Time')
legend('Step Size=0.1','Step Size=0.01','Step Size=0.001')
hold off;

% plot Normal Forces at each point over Time graph
figure()
set(gcf,'defaultAxesFontSize',11);
hold on;
plot(t3,normal_A3)
plot(t3,normal_B3,'r')
xlabel('Time (seconds)')
ylabel('Normal Force (N)')
title('Normal Force vs Time')
legend('Normal Force at A','Normal Force at B')
hold off;

% plot position of bar over time graph
figure()
set(gcf,'defaultAxesFontSize',11);
hold on;
for i=1:100:size(pos3,1)
    plot([pos3(i,2) 0],[0 pos3(i,1)])
end
xlabel('Position along ground')
ylabel('Position along wall')
title('Bar Position Over Time')
hold off;

% plot our experimental solution compared to analytical solution graph
figure()
set(gcf,'defaultAxesFontSize',11);
hold on;
plot(theta1_deg,omega1,'*')
plot(a_theta_deg,a_omega,'r')
xlabel('Theta (deg)')
ylabel('Omega (rad/s)')
title('Comparison of Analytical vs Experimental')
legend('Experimental Data','Analytical Solution')