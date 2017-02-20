%Christopher Brown, Tony_____, _____,
%Purpose: Optimization of bottle rocket using thermodynamic model, isp model, and
%interpolation model.
close all
clear all
clc

%%Baseline data
theta_o = 45 * (pi/180); %radians
M_owater = 1; %kg
rho_w = 1000; %kg/m^3
d_t = 0.021; %diameter of throat (M)
a_t = (pi*d_t*d_t)/4;  %Area of bottle throat (M^2)
m_oy = 0.157; %kilograms
mbm1 = 0.158; %kg
T = 277.1; % standard atmosphere temperature (kelvin)

%% Calculate Coefficients of drag
%Baseline coefficient of drag
ty = load('data/WTData_Test1(yellow).txt');
qty = mean(ty(:,3));  %All data points for the dynamic pressure over the five air speeds
%Grab the axial forces at the different airspeeds and average them
Aty = mean(ty(:,7));
%Calculate the coefficent of drag
Cdt = dragrocket(Aty,qty);

%Model 1
m1 = load('data/TestRocket2(wnose).txt');
qm1 = mean(m1(:,3));  %All data points for the dynamic pressure over the five air speeds
%Grab the axial forces at the different airspeeds and average them
Am1 = mean(m1(:,7));
%Calculate the coefficent of drag
Cdm1 = dragrocket(Am1,qm1);

%Model 2
m2 = load('data/TestRocket3(model2).txt');
qm2 = mean(m2(:,3));  %All data points for the dynamic pressure over the five air speeds
%Grab the axial forces at the different airspeeds and average them
Am2 = mean(m2(:,7));
%Calculate the coefficent of drag
Cdm2 = dragrocket(Am2,qm2);

%Model 3
m3 = load('data/TestRocket4(model3).txt');
qm3 = mean(m3(:,3));  %All data points for the dynamic pressure over the five air speeds
%Grab the axial forces at the different airspeeds and average them
Am3 = mean(m3(:,7));
%Calculate the coefficent of drag
Cdm3 = dragrocket(Am3,qm3);

%% Baseline Thermo
disp('Baseline Thermo')
[t, Y] = model(M_owater, theta_o, rho_w, mbm1, Cdm1, a_t, T, 'thermo', 'data/Group5_test5.txt');
x = Y(:,1);
range_thermo = max(x);
y = Y(:,2);
z = Y(:,3);
vx = Y(:,4);
vy = Y(:,5);
vz = Y(:,6);
V = Y(:,7);
mair = Y(:,8);
mr = Y(:,9);
figure;
subplot(1, 2, 1)
plot3(x, y, z)
daspect([1 1 1])
xlabel('x')
ylabel('y')
zlabel('z')
subplot(1, 2, 2)
plot(t, vx, t, vy, t, vz)
xlabel('t')
ylabel('V')
legend('V_x', 'V_y', 'V_z')

%% Baseline ISP Model
disp('Baseline ISP')
[t, Y] = model(M_owater, theta_o, rho_w, mbm1, Cdm1, a_t, T, 'isp', 'data/Group5_test5.txt');
x = Y(:,1);
range_isp = max(x);
y = Y(:,2);
z = Y(:,3);
vx = Y(:,4);
vy = Y(:,5);
vz = Y(:,6);
V = Y(:,7);
mair = Y(:,8);
mr = Y(:,9);
figure;
subplot(1, 2, 1)
plot3(x, y, z)
daspect([1 1 1])
xlabel('x')
ylabel('y')
zlabel('z')
subplot(1, 2, 2)
plot(t, vx, t, vy, t, vz)
xlabel('t')
ylabel('V')
legend('V_x', 'V_y', 'V_z')

%% Baseline Interpolation Model
disp('Baseline Interpolation')
[t, Y] = model(M_owater, theta_o, rho_w, mbm1, Cdm1, a_t, T, 'inter', 'data/Group5_test5.txt');
x = Y(:,1);
range_inter = max(x);
y = Y(:,2);
z = Y(:,3);
vx = Y(:,4);
vy = Y(:,5);
vz = Y(:,6);
V = Y(:,7);
mair = Y(:,8);
mr = Y(:,9);
figure;
subplot(1, 2, 1)
plot3(x, y, z)
daspect([1 1 1])
xlabel('x')
ylabel('y')
zlabel('z')
subplot(1, 2, 2)
plot(t, vx, t, vy, t, vz)
xlabel('t')
ylabel('V')
legend('V_x', 'V_y', 'V_z')

%% Compare data sets
disp('Dataset Comparison')
files = {'data/Group5_test5.txt', 'data/Group7_test1.txt', 'data/Group8_test2.txt', 'data/Group13_test1.txt', 'data/Group13_test4.txt'};
figure
subplot(1, 2, 1)
hold on
title('ISP')
for i = 1:length(files)
	[t, Y] = model(M_owater, theta_o, rho_w, mbm1, Cdm1, a_t, T, 'isp', files{i});
	plot(Y(:,1), Y(:,3))
end
legend(files)
subplot(1, 2, 2)
hold on
title('Interpolation')
for i = 1:length(files)
	[t, Y] = model(M_owater, theta_o, rho_w, mbm1, Cdm1, a_t, T, 'inter', files{i});
	plot(Y(:,1), Y(:,3), '--')
end
legend(files)
hold off

%% Air/Water ratio optimization
disp('Optimizing Water Mass')
M_water = 0.1:0.1:1; %kg
range = zeros(size(M_water));
for i = 1:length(M_water)
	%fprintf('\tCurrent Water Mass: %f\n', M_water(i))
	[t, Y] = model(M_water(i), theta_o, rho_w, mbm1, Cdm1, a_t, T, 'thermo', files{1});
	range(i) = max(Y(:,1));
end
[opt_v, opt_i] = max(range);
fprintf('Optimal Mass: %f kg | Baseline: %.2f m | Range: %.2f m | Change: %.2f %%\n', M_water(opt_i), range_thermo, opt_v, (opt_v - range_thermo)/range_thermo)
figure
plot(M_water, range)

%% Water Density optimization
% disp('Optimizing Water Density')
% rho = 1000:1025; %kg/m^3
% range = zeros(size(rho));
% for i = 1:length(rho)
% 	fprintf('Current Water Density: %f\n', rho(i))
% 	[t, Y] = model(M_owater, theta_o, rho(i), mbm1, Cdm1, a_t, T, 'thermo', files{1});
% 	range(i) = max(Y(:,1));
% end
% [opt_v, opt_i] = max(range);
% fprintf('Optimal Density: %.2f kg/m^3 | Range: %.2f m\n', rho(opt_i), opt_v)
% figure
% plot(rho, range)

%% Nozzle optimization
disp('Optimizing Throat Diameter')
a_throat = linspace(0.000262, a_t, 20); %Variable area of the throat m^2
range = zeros(size(a_throat));
for i = 1:length(a_throat)
	%fprintf('\tCurrent Throat Diameter: %f\n', a_throat(i))
	[t, Y] = model(M_owater, theta_o, rho_w, mbm1, Cdm1, a_throat(i), T, 'thermo', files{1});
	range(i) = max(Y(:,1));
end
[opt_v, opt_i] = max(range);
fprintf('Optimal Area: %f m^2 | Baseline: %.2f m | Range: %.2f m | Change: %.2f %%\n', a_throat(opt_i), range_thermo, opt_v, (opt_v - range_thermo)/range_thermo)
figure
plot(a_throat, range)

%% Angle Optimization
disp('Optimizing Launch Angle')
theta = (0:2:90)*(pi/180);
range = zeros(size(theta));
for i = 1:length(theta)
	%fprintf('\tCurrent Launch Angle: %f\n', radtodeg(theta(i)))
	[t, Y] = model(M_owater, theta(i), rho_w, mbm1, Cdm1, a_t, T, 'inter', files{1});
	range(i) = max(Y(:,1));
end
[opt_v, opt_i] = max(range);
fprintf('Optimal Angle: %f° | Baseline: %.2f m | Range: %.2f m | Change: %.2f %%\n', theta(opt_i), range_inter, opt_v, (opt_v - range_inter)/range_inter)
figure
plot(radtodeg(theta), range)
