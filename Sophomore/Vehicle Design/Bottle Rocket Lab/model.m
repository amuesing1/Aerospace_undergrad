function [t, Y] = model(M_prop, Theta, rho_prop, M_b, Cd, a_t, T, model, file)
%Directory hub that declares constants and variables while directing to a
%specific model
global rho_amb u_k C_D s a_b P_0 V_0 T_0 R v_wind rho_Prop P_a discharge_coeff A_t g Force_x volume_bottle theta thrust launch_length Massair_i dmdt MassB

%Constants
%%Bottle
s = .0095; %Cross-sectional area of the bottle
A_t = a_t; %area of throat
volume_bottle = 0.002; %M^3
d_b = .105; %diameter of bottle (M)
a_b = (pi*d_b*d_b)/4; %area of bottle (M^2)
discharge_coeff = .9;
V_prop = M_prop/rho_prop; %initial volume of prop in bottle (M^3)
C_D = Cd; %Coeff of drag
V_0 = volume_bottle-V_prop; %initial volume of air in bottle (M^3)
P_o = 40*6894.75729; %Pressure of bottle (Pa)

%%Surroundings
v_wind = convvel([1,0,0],'mph','m/s');
Force_x = [];
rho_Prop = rho_prop; %Density of propellant 
rho_amb = 1.0441; %Density of air (kg/m^3)
P_a = 8.3175*10^4; %Ambient pressure (pa)
T_0 = T; %Ambient temperature (Kelvin)
g = 9.81; %standard gravity
u_k = 0.05;  %Coefficient of drag on the rails
R = 287.058; % Specific gas constant for air
launch_length = 0.762; %m 

%%Initial values
P_0 = P_o + P_a; %intial absolute pressure of air
VelI = 0.0;  % initial velocity of rocket
theta = Theta; %initial angle (radians)
AltL = 0.01; % initial altitide of launch
MassB = M_b; % mass of bottle itself(kg)

Massair_i = (P_0/(R*T_0))*V_0; %Initial mass of air

% Calculate and save thrust profile
[thrust, dmdt] = interpolation(file);

switch model
	case 'thermo'
		y0(1) = 0; %initial x-position (m)
		y0(2) = 0; %initial y-position (m)
		y0(3) = AltL; %initial z-position (m)
		y0(4) = 0; %initial x-velocity (m/s)
		y0(5) = 0; %initial y-velocity (m/s)
		y0(6) = 0; %initial z-velocity (m/s)
		y0(7) = V_0; %inital volumme of air in bottle
		y0(8) = Massair_i; %initial mass of air
		y0(9) = MassB + Massair_i + M_prop; % inital mass of rocket (kg)
	case 'isp'
		dV = Isp(MassB + Massair_i + M_prop, MassB, file);
		y0(1) = 0; %initial x-position (m)
		y0(2) = 0; %initial y-position (m)
		y0(3) = AltL; %initial z-position (m)
		y0(4) = dV*cos(theta); %initial x-velocity (m/s)
		y0(5) = 0; %initial y-velocity (m/s)
		y0(6) = dV*sin(theta); %initial z-velocity (m/s)
		y0(7) = V_0; %inital volumme of air in bottle
		y0(8) = Massair_i; %initial mass of air
		y0(9) = MassB + Massair_i; % inital mass of rocket (kg)
	case 'inter'
		y0(1) = 0; %initial x-position (m)
		y0(2) = 0; %initial y-position (m)
		y0(3) = AltL; %initial z-position (m)
		y0(4) = 0; %initial x-velocity (m/s)
		y0(5) = 0; %initial y-velocity (m/s)
		y0(6) = 0; %initial z-velocity (m/s)
		y0(7) = V_0; %inital volumme of air in bottle
		y0(8) = Massair_i; %initial mass of air
		y0(9) = MassB + Massair_i + M_prop; % inital mass of rocket (kg)
end

%fprintf('%s | Mb: %.2f | Mp: %.2f | Ma: %.2f | Mi: %.2f\n', file, MassB, M_prop, Massair_i, MassB + Massair_i + M_prop)
%Chooses which model to use based on model number passed in
odefun = @(t, Y) traj(t, Y, model);
y0 = y0'; %Tanspose the matrix to make it compatible with ode45
tspan = [0, 1000]; %time span over which to model (s)
options = odeset('AbsTol', 1e-12, 'Stats', 'off', 'Events', @odeevents);
[t, Y] = ode45(odefun, tspan, y0, options);
end

