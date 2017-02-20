% Aspen Coates, Javeyn Faulk, Jeremy Muesing
% ASEN 3200 Lab O-3
% Problem 2
% Date Created:  15 April 2016
% Last Modified: 15 April 2016

close all
clear all
clc

% Define Givens/Constants
delta_t = 60;              % [sec]        Time Step
e       = 0.001;           %              Eccentricity
P       = 6200;            % [sec]        Period
time       = 0:delta_t:3*P;   % [sec]        Duration of 3 Orbits
inc       = deg2rad(45);              % [deg]        Inclination
Omega   = deg2rad(10);              % [rad]        Right Ascension of Ascending Node
omega   = deg2rad(45);              %              Argument of Perigee
theta   = deg2rad(315);             % [rad]       True anomoly
J2      = 0.00108263;
mu     = 398600.4418;     % [km^3/s^2]   Earth's Gravitational Parameter
R_E       = 6378.137;        % [km]         Radius of Earth
a=((P/(2*pi))^2*mu)^(1/3); %semi major axis

%% Problem 2
%finding the initial r and v vectors
[r,v]=randv(a,e,inc,Omega,omega,theta,mu);
X_0=[r;v];
% setting the options for ODE 45
tol     = 1e-10;
options = odeset('RelTol',tol,'AbsTol',tol);
[t,x]   = ode45('orbit', time, X_0, options); %J2 perturbation
r=[x(:,1),x(:,2),x(:,3)];
v=[x(:,4),x(:,5),x(:,6)];
%part a
%finding the energy and z component of the angular velocity
E = zeros(1,length(r));
h = zeros(length(r),3);
for i=1:length(x)
    U=(mu/norm(r(i,:)))*(1+(J2/2)*(R_E/norm(r(i,:)))^2*(1-3*(x(i,3)/norm(r(i,:)))^2));
    E(i)=norm(v(i,:))^2/2-U;
    h(i,:)=cross(r(i,:),v(i,:));
end
%plotting the figure for energy and hz
figure
plot(t,E-E(1),'Linewidth',2)
title('Energy difference from Epoch','Fontsize',18)
xlabel('time (s)','Fontsize',18)
ylabel('E-E_{Epoch} (J)','Fontsize',18)

figure
plot(t,h(:,3)-h(1,3),'Linewidth',2)
xlabel('Time (s)','Fontsize',18)
ylabel('h_z-h_z_{Epoch} (J)','Fontsize',18)
title('hz differnce from Epoch','Fontsize',18)

%part b
% setting up the orbit with out the J2 effect
[t_2,x_2]   = ode45('orbit_2body', time, X_0, options);
r_2=[x_2(:,1),x_2(:,2),x_2(:,3)];
v_2=[x_2(:,4),x_2(:,5),x_2(:,6)];

%plotting the ECI differences
figure
hold on
plot(t,r(:,1)-r_2(:,1),'b','linewidth',2)
plot(t,r(:,2)-r_2(:,2),'g','linewidth',2)
plot(t,r(:,3)-r_2(:,3),'k','linewidth',2)
title('Comparison of coordinates w/wo J_2 effect','Fontsize',18)
xlabel('Time (s)','Fontsize',18)
ylabel('Difference in inertial coordinates (km)','Fontsize',18)
legend('X','Y','Z')
hold off

%part c
%concatenate r and v vectors into one matrix
nonJ2_matrix = [r,v];
J2_matrix = [r_2,v_2];

%difference between J2 and nonJ2
ECI_differences = nonJ2_matrix-J2_matrix;
R_vector = zeros(length(ECI_differences),1);
I_vector = zeros(length(ECI_differences),1);
C_vector = zeros(length(ECI_differences),1);
%convert to RIC 
for i=1:length(r)
    [R,I,C]=FromXYZtoRIC(r_2(i,:),v_2(i,:),ECI_differences(i,:));
    R_vector(i) = R;
    I_vector(i) = I;
    C_vector(i) = C;
end

%plot RIC differences
figure
hold on
plot(t,R_vector,'k','linewidth',2)
plot(t,I_vector,'g','linewidth',2)
plot(t,C_vector,'c','linewidth',2)
title('RIC graph','Fontsize',18)
legend('Radial','In-track','Cross-track')
xlabel('Time (s)','Fontsize',18)
ylabel('Distance (km)','Fontsize',18)
set(gca,'Fontsize',14)
grid on
hold off

%% Problem 3
% GST found using http://www.celnav.de/longterm.htm
GST = 99.9595; %greenich Sidereal time
[X_0_ECF] = ConvertECI2ECF(X_0,GST);
% numerically integrate using ECF coordinates
[t_3,x_3]   = ode45('ECF_orbit', time, X_0_ECF, options);

%convert from ECF back to ECI
ECI = zeros(length(t_3),3);
V_ECI = zeros(length(t_3),3);
for i = 1:length(t_3)
    [ECI(i,:),V_ECI(i,:)] = ConvertECF2ECI(x_3(i,:),t_3(i));
end

%print values for table
fprintf('Part 1 values, ECI')
disp(r(1,:))
disp(r(60,:))
disp(r(end,:))
disp(v(1,:))
disp(v(60,:))
disp(v(end,:))
fprintf('Part 3 values, ECI-EFC-ECI')
disp(ECI(1,:))
disp(ECI(60,:))
disp(ECI(end,:))
disp(V_ECI(1,:))
disp(V_ECI(60,:))
disp(V_ECI(end,:))

fprintf('\n differences\n')
diff_r = r - ECI;
diff_v = v - V_ECI;

disp(diff_r(1,:))
disp(diff_r(60,:))
disp(diff_r(end,:))
disp(diff_v(1,:))
disp(diff_v(60,:))
disp(diff_v(end,:))


% figure
% hold on
% plot(t,r(:,1)-ECI(:,1),'b')
% plot(t,r(:,2)-ECI(:,2),'g')
% plot(t,r(:,3)-ECI(:,3),'k')
% title('Comparison of coordinates from different frames')
% xlabel('Time (s)')
% ylabel('Difference in inertial coordinates (km)')
% legend('X','Y','Z')
% hold off

%find COE
inclination = zeros(length(r),1);
Omega = zeros(length(r),1);
e = zeros(length(r),1);
omega = zeros(length(r),1);
a = zeros(length(r),1);
for i = 1:length(r)
    [~,inclination(i),Omega(i),e(i),omega(i),~,a(i),~,~,~] = FindCOE(r(i,:),v(i,:));
end

%plot the classical orbital elements
chicken_PLOT_pie(inclination,Omega,e,omega,a,time);

% figure
% hold on
% [xs,ys,zs]=sphere;
% surf(xs*R_E,ys*R_E,zs*R_E)
grs80 = referenceEllipsoid('grs80','km');
figure('Renderer','opengl'); hold on;
ax = axesm('globe','Geoid',grs80,'Grid','on',...
    'GLineWidth',1,'GLineStyle','-',...
    'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
ax.Position = [0 0 1 1];
view(3)
load topo
geoshow(topo,topolegend,'DisplayType','texturemap')
demcmap(topo)
land = shaperead('landareas','UseGeoCoords',true);
plotm([land.Lat],[land.Lon],'Color','black')
rivers = shaperead('worldrivers','UseGeoCoords',true);
plotm([rivers.Lat],[rivers.Lon],'Color','blue')
plot3(x(:,1),x(:,2),x(:,3))
plot3(x_2(:,1),x_2(:,2),x_2(:,3))
plot3(ECI(:,1),ECI(:,2),ECI(:,3))
axis equal off
title('Orbits with earth for shits and giggles')
hold off